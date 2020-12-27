#! /bin/bash
USAGE="Installs pk render plugins and test runs them.
  -i    Installs the plugins only
  -t    Runs the tests but do not re-install the plugins
  -g    Display plugin results in gimp user interface
  -c    Clean the gimp plugins repo before installation
"

REPO_ROOT=''
PLUGIN_DIR=''

run_cmd() {
  echo "Running : $@"
  $@
}
run_gimp() {
  if [[ "$RUN_WITH_GUI" == 1 ]]; then
    local -a gimp_cmd=( gimp -b "( $* )" )
  else
    local -a gimp_cmd=(
      gimp-console --no-interface --new-instance
      -b "( $* )" -b "(gimp-quit 0)"
    )
  fi
  echo "Running : ${gimp_cmd[@]}"
  "${gimp_cmd[@]}"
}
exit_with_msg() {
  echo "[ERROR] $1"
  exit 1
}

find_repo_root() {
  local script_root="`readlink -f "$1/.."`"
  local cwd="`pwd`"
  local repo_from_script="`cd "$script_root" && git rev-parse --show-toplevel 2> /dev/null`"
  local repo_from_cwd="`git rev-parse --show-toplevel 2> /dev/null`"

  [[ -d "$repo_from_cwd" ]] && REPO_ROOT="$repo_from_script"
  [[ -d "$repo_from_script" ]] && REPO_ROOT="$repo_from_script"
  [[ -d "$REPO_ROOT" ]] || exit_with_msg "REPO_ROOT='$REPO_ROOT' is not a directory"
}

find_plugin_dir() {
  # https://www.gimp.org/man/gimprc.html
  [[ -f "$HOME/.gimprc" ]] && grep --quiet plug-in-path "$HOME/.gimprc" \
    && exit_with_msg "'$HOME/.gimprc' plug-in-path not supported"
  local version_sort_file="`mktemp`"
  local candidate_file="`mktemp`"
  {
     find "$HOME" -maxdepth 1 -type d -iname '.gimp*'
     [[ -z "$XDG_CONFIG_HOME" ]] || find "$XDG_CONFIG_HOME/GIMP" -maxdepth 1 -mindepth 1 -type d
     find "$HOME/.config/GIMP" -maxdepth 1 -mindepth 1 -type d
  } > "$candidate_file"
  grep --quiet '' "$candidate_file" || exit_with_msg "No candidates for PLUGIN_DIR found"

  gawk -e 'match($0, /.*([0-9]+)\.([0-9]+)$/, grp) 
             { printf("%03d%03d %s\n", grp[1], grp[2], $0); }' "$candidate_file" \
    | sort -nf \
    | sed -r 's/^.* //' \
    > "$version_sort_file"
  local latest_dir="`cat "$version_sort_file" | tail -n1`"
  PLUGIN_DIR="$latest_dir/plug-ins"

  [[ -d "$PLUGIN_DIR" ]] || exit_with_msg "PLUGIN_DIR='$PLUGIN_DIR' is not a directory"
}

install_plugin() {
  [[ $TEST_ONLY == 1 ]] && return

  # [CAUTION] Cleans everything
  [[ "$CLEAN_ALL" == 1 ]] \
    && find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 | xargs --no-run-if-empty rm -rf

  [[ -d "$PLUGIN_DIR"/Batches ]] || run_cmd mkdir "$PLUGIN_DIR"/Batches
  run_cmd cp -rf $REPO_ROOT/Batches/*.xml "$PLUGIN_DIR"/Batches
  run_cmd cp -rf $REPO_ROOT/SourceImages "$PLUGIN_DIR"
  run_cmd cp -r $REPO_ROOT/Python/* "$PLUGIN_DIR"
  find "$PLUGIN_DIR" -iname '*.pyc' | xargs --no-run-if-empty rm
}

run_plugins() {
  [[ "$INSTALL_ONLY" == 1 ]] && return
  local test_image="$REPO_ROOT/SourceImages/test_image.png"
  local test_batch="$REPO_ROOT/Batches/batch_example.xml"

  energy_render=( python-fu-energy-card RUN-NONINTERACTIVE '"fire"' )
  run_gimp ${energy_render[@]}

  trainer_render=( python-fu-trainer-card RUN-NONINTERACTIVE 
    '"test_trainer"' '"23"' '"'$test_image'"' '"Test trainer. Card description"' )
  run_gimp ${trainer_render[@]}

  pk_render=( python-fu-pk-card RUN-NONINTERACTIVE
    '"Test Pk"' '"PkName"' '"66"' '"leaf"' '"'$test_image'"'
    '"attack"' 1 2 '"water"' '"test attack"' '"Attack description"' '"10+"'
    '"attack"' 1 3 '"fire"' '"test attack"' '"Second attack description"' '"30"'
    '"psy"' '"punch"' 2 '"pk description lv66"'
  )
  run_gimp ${pk_render[@]}

  batch_render=( python-fu-batch-render RUN-NONINTERACTIVE '"'$test_batch'"' )
  run_gimp ${batch_render[@]}
}

while getopts "gcith" arg; do
  case $arg in
    g) RUN_WITH_GUI=1 ;;
    c) CLEAN_ALL=1 ;;
    i) INSTALL_ONLY=1 ;;
    t) TEST_ONLY=1 ;;
    *) echo "$USAGE" ; exit 1 ;;
  esac
done

find_plugin_dir
find_repo_root "$0"
install_plugin
run_plugins

