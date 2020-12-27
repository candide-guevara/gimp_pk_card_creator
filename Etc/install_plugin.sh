#! /bin/bash
USAGE="Installs pk render plugins into gimp plugin folder.
  -c    Clean the gimp plugins repo before installation
"

REPO_ROOT=''
PLUGIN_DIR=''
source "`dirname "$0"`/common.sh" || exit 1

install_plugin() {
  # [CAUTION] Cleans everything
  [[ "$CLEAN_ALL" == 1 ]] \
    && find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 | xargs --no-run-if-empty rm -rf

  [[ -d "$PLUGIN_DIR"/Batches ]] || run_cmd mkdir "$PLUGIN_DIR"/Batches
  run_cmd cp -rf $REPO_ROOT/Batches/*.xml "$PLUGIN_DIR"/Batches
  run_cmd cp -rf $REPO_ROOT/SourceImages "$PLUGIN_DIR"
  run_cmd cp -r $REPO_ROOT/Python/* "$PLUGIN_DIR"
  find "$PLUGIN_DIR" -iname '*.pyc' | xargs --no-run-if-empty rm
}

while getopts "gcith" arg; do
  case $arg in
    c) CLEAN_ALL=1 ;;
    *) echo "$USAGE" ; exit 1 ;;
  esac
done

find_plugin_dir
find_repo_root "$0"
install_plugin

