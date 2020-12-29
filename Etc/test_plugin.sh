#! /bin/bash
USAGE="Runs pk render plugins with test data and checks images are produced.
Prerequisite: plugins must be installed into gimp.
  -g    Display plugin results in gimp user interface
"

source "`dirname "$0"`/common.sh" || exit 1
# '<?' has to be the first 2 chars of the file
TEST_BATCH='<?xml version="1.0" encoding="UTF-8"?>
<batch xmlns="coquimon" group="3*2" resize="1024*768">
  <pokemons>
    <card id="#992LV84" occurrence="1" image="mrrufo2.jpg"/>
  </pokemons>
  <trainers>
    <card id="#marrobones" occurrence="1" image="marrobone.png"/>
  </trainers>
  <energies>
    <card id="#punch" occurrence="1" format="jpg"/>
  </energies>
</batch>
'

run_plugins() {
  local test_image="$REPO_ROOT/SourceImages/test_image.png"
  local test_batch="`mktemp -t test_batch.XXXXXX.xml`"
  echo "$TEST_BATCH" > "$test_batch"

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
    *) echo "$USAGE" ; exit 1 ;;
  esac
done

find_repo_root "$0"
run_plugins

