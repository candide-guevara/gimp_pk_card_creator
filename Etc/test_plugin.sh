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
    <card id="#992LV84" occurrence="2" image="mrrufo2.jpg"/>
  </pokemons>
  <trainers>
    <card id="#marrobones" occurrence="1" image="marrobone.png"/>
  </trainers>
  <energies>
    <card id="#punch" occurrence="1" format="jpg"/>
  </energies>
</batch>
'

test_energy_render() {
  energy_render=( python-fu-energy-card RUN-NONINTERACTIVE '"fire"' )
  run_gimp ${energy_render[@]}
  [[ -f "energy_fire.png" ]] || exit_with_msg "Failed ${FUNCNAME[0]}"
}

test_trainer_render() {
  trainer_render=( python-fu-trainer-card RUN-NONINTERACTIVE 
    '"test_trainer"' '"23"' '"'$test_image'"' '"Test trainer. Card description"' )
  run_gimp ${trainer_render[@]}
  [[ -f "trainer_test_trainer.png" ]] || exit_with_msg "Failed ${FUNCNAME[0]}"
}

test_pokemon_render() {
  pk_render=( python-fu-pk-card RUN-NONINTERACTIVE
    '"Test Pk"' '"PkName"' '"66"' '"leaf"' '"'$test_image'"'
    '"attack"' 1 2 '"water"' '"test attack"' '"Attack description"' '"10+"'
    '"attack"' 1 3 '"fire"' '"test attack"' '"Second attack description"' '"30"'
    '"psy"' '"punch"' 2 '"pk description lv66"'
  )
  run_gimp ${pk_render[@]}
  [[ -f "pokemon_pkname.png" ]] || exit_with_msg "Failed ${FUNCNAME[0]}"
}

test_batch_render() {
  local test_dir="$1"
  local test_batch="`mktemp --tmpdir="$test_dir" test_batch.XXXXXX.xml`"
  local batch_dir="${test_batch%.*}"
  echo "$TEST_BATCH" > "$test_batch"

  batch_render=( python-fu-batch-render RUN-NONINTERACTIVE '"'$test_batch'"' )
  run_gimp ${batch_render[@]}
  [[ -f "$batch_dir/Energies/energy_punch_0.jpg" ]] || exit_with_msg "Failed ${FUNCNAME[0]} energy"
  [[ -f "$batch_dir/Trainers/trainer_marrobones_0.png" ]] || exit_with_msg "Failed ${FUNCNAME[0]} trainer"
  [[ -f "$batch_dir/Pokemons/pokemon_mr_rufo_992lv84_0.png" ]] || exit_with_msg "Failed ${FUNCNAME[0]} pokemon"
  [[ -f "$batch_dir/Pokemons/pokemon_mr_rufo_992lv84_1.png" ]] || exit_with_msg "Failed ${FUNCNAME[0]} pokemon"
}

test_all_plugins() {
  local test_image="$REPO_ROOT/SourceImages/test_image.png"
  local test_dir="`mktemp --directory`"

  echo "### Cards generated in '$test_dir' ###"
  pushd "$test_dir" > /dev/null || exit 1
  test_energy_render
  test_trainer_render
  test_pokemon_render
  test_batch_render "$test_dir"
  popd
}

while getopts "gh" arg; do
  case $arg in
    g) RUN_WITH_GUI=1 ;;
    *) echo "$USAGE" ; exit 1 ;;
  esac
done

find_repo_root "$0"
test_all_plugins

