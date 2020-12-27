# Common routine for Etc shell scripts

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

