#! /bin/bash
USAGE='USAGE : render.sh COMMAND ARGS
  Commands :
  * list CARD_NAME_PAT
  * single CARD_NAME [IMG_NAME]
  * batch XML_FILE
'

source "`dirname "$0"`/common.sh" || exit 1
find_plugin_dir "$0"
XML_DB="$PLUGIN_DIR/Batches/PkCardsClassicSet.xml"
IMG_DB="$PLUGIN_DIR/SourceImages"
declare -A CMD_LIST

CMD_LIST['list']=1
list() {
  local pattern="$1"
  local awk_script="`mktemp`"
  cat > "$awk_script" <<eof
    match(\$0, /^\\s*<([[:alnum:]-]*${pattern}[^ ]*)/, grp) { 
      print("  * " grp[1]);
    }
eof
  echo "Found matching cards :"
  gawk -f "$awk_script" "$XML_DB"
  echo "Found matching images :"
  find "$IMG_DB" -type f -iname "*${pattern}*" \
    | xargs -I{} basename '{}' \
    | sed -r 's/^/  * /'
}

CMD_LIST['single']=1
single() {
  local card_tag="$1"
  local card_img="$2"
  local awk_script="`mktemp`"
  cat > "$awk_script" <<eof
    BEGIN { CARD_TYPE = ""; }
    /^\\s*<pokemons / { CARD_TYPE = "pokemons"; }
    /^\\s*<trainers / { CARD_TYPE = "trainers"; }
    /^\\s*<energies / { CARD_TYPE = "energies"; }
    /^\\s*<${card_tag}/ { 
      match(\$0, /id="([^"]+)"/, grp);
      print(CARD_TYPE " " grp[1]);
    }
eof
  local type_id="`gawk -f "$awk_script" "$XML_DB"`"
  local xmlid="${type_id#* }"
  local card_type="${type_id% *}"
  #echo "type=$card_type // id=$xmlid"
  local pokemon_elt=""
  [[ "$card_type" == "pokemons" ]] \
    && pokemon_elt="<card id=\"${xmlid}\" occurrence=\"1\" image=\"${card_img}\"/>"
  local energy_elt=""
  [[ "$card_type" == "energies" ]] \
    && energy_elt="<card id=\"${xmlid}\" occurrence=\"1\" />"
  local trainer_elt=""
  [[ "$card_type" == "trainers" ]] \
    && trainer_elt="<card id=\"${xmlid}\" occurrence=\"1\" image=\"${card_img}\"/>"
  # A tempfile in the current directory
  local batch_xml="`mktemp batch_single.XXXXXX.xml`"
  local batch_dir="${batch_xml%.*}"
  cat > "$batch_xml" <<eof
<?xml version="1.0" encoding="UTF-8"?>
  <batch xmlns="coquimon">
    <pokemons>${pokemon_elt}</pokemons>
    <trainers>${trainer_elt}</trainers>
    <energies>${energy_elt}</energies>
  </batch>
eof

  run_gimp python-fu-batch-render RUN-NONINTERACTIVE "\"$batch_xml\""
  find "$batch_dir" -type f | xargs --no-run-if-empty -I{} mv '{}' .
  [[ -f "$batch_xml" ]] && rm "$batch_xml"
  [[ -d "$batch_dir" ]] && rm -rf "$batch_dir"
}

CMD_LIST['batch']=1
batch() {
  run_gimp python-fu-batch-render RUN-NONINTERACTIVE "\"$1\""
}

main() {
  local command="$1"
  shift
  [[ -f "$XML_DB" ]] || exit_with_msg "Cannot find pk database at '$XML_DB'"
  [[ -d "$IMG_DB" ]] || exit_with_msg "Cannot find image database at '$IMG_DB'"
  if [[ -z "${CMD_LIST[$command]}" ]]; then
    echo "$USAGE"
  else
    "$command" "$@" || exit_with_msg "Failed cmd '$command' $@"
  fi
}
main "$@"

