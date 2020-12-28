# Installs a VM, provisions gimp and installs the pokemon card plugins inside.

source "`dirname "$0"`/../Etc/common.sh" || exit 1
# needed by Vagrantfile
find_repo_root
# https://www.vagrantup.com/docs/other/environmental-variables
export VAGRANT_HOME="$REPO_ROOT/Vagrant/vagrant.d"
export VAGRANT_NO_PLUGINS=yes

pushd "`dirname "$0"`" &> /dev/null || exit 1
# Common commands include `up`, `status`, `halt`, `destroy`
vagrant "$@"

# Other common tasks :
# * Check machine got installed with `vboxmanage list vms`
# * Clean vagrant data `rm -rf "$VAGRANT_HOME"`

