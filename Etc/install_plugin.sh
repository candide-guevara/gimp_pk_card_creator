#! /bin/bash
USAGE="Installs pk render plugins and test runs them.
  -i    Installs the plugins only
  -t    Runs the tests but do not re-install the plugins
  -g    Display plugin results in gimp user interface
  -c    Clean the gimp plugins repo before installation
"

ROOT_DIR=`dirname $0`
ROOT_DIR=`readlink -f $ROOT_DIR/..`
PLUGIN_DIR=~/.gimp-2.8/plug-ins
TEST_IMAGE="$ROOT_DIR/SourceImages/test_image.png"
TEST_BATCH="$ROOT_DIR/Batches/batch_example.xml"

run_cmd() {
  echo "Running : $@"
  $@
}
run_gimp() {
  if [[ $RUN_WITH_GUI == 1 ]]; then
    gimp_cmd=( gimp -b "( $* )" )
  else
    gimp_cmd=( gimp-console -b "( $* )" -b "(gimp-quit 0)" )
  fi
  echo "Running : ${gimp_cmd[@]}"
  "${gimp_cmd[@]}"
}

install_plugin() {
  [[ $TEST_ONLY == 1 ]] && return

  pushd $PLUGIN_DIR
  # [CAUTION] Cleans everything
  [[ $CLEAN_ALL == 1 ]] && run_cmd rm -rf $PLUGIN_DIR/*
  run_cmd mkdir ./Batches
  run_cmd cp -rf $ROOT_DIR/Batches/*.xml ./Batches
  run_cmd cp -rf $ROOT_DIR/SourceImages .
  run_cmd cp -r $ROOT_DIR/Python/* .
  find -iname '*.pyc' | xargs rm
  popd
}

run_plugins() {
  [[ $INSTALL_ONLY == 1 ]] && return

  energy_render=( python-fu-energy-card RUN-NONINTERACTIVE '"fire"' )
  run_gimp ${energy_render[@]}

  trainer_render=( python-fu-trainer-card RUN-NONINTERACTIVE 
    '"test_trainer"' '"23"' '"'$TEST_IMAGE'"' '"Test trainer. Card description"' )
  run_gimp ${trainer_render[@]}

  pk_render=( python-fu-pk-card RUN-NONINTERACTIVE
    '"Test Pk"' '"PkName"' '"66"' '"leaf"' '"'$TEST_IMAGE'"'
    '"attack"' 1 2 '"water"' '"test attack"' '"Attack description"' '"10+"'
    '"attack"' 1 3 '"fire"' '"test attack"' '"Second attack description"' '"30"'
    '"psy"' '"punch"' 2 '"pk description lv66"'
  )
  run_gimp ${pk_render[@]}

  batch_render=( python-fu-batch-render RUN-NONINTERACTIVE '"'$TEST_BATCH'"' )
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

install_plugin
run_plugins

