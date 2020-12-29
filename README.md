# Generate playing cards

This is a collection of gimpfu plugins to script the creation of playing cards with Gimp.
It is based on the [pokemon card game][1] I used to play with my younger cousin and brother.

The project ships with 4 different plugins.
* pkcard : generates pokemon cards given a complex set of parameters
* trainercard : generates trainer cards
* energycard : generates any kind of energy card
* batchrender : uses the plugins above to render a complete deck from an xml file

## Dependencies

* Gimp : If your distribution has an **gimp-extra** package you need that too
* [Gimpfu][2] : The python scripting interface for Gimp
* OPTIONAL [Vagrant][3] : to run in a sandboxed environment


## Getting started

### Running gimp on your machine

> WARNING: Currently broken because gimp can only use python2. Many distributions ship gimp without python-fu to avoid depending on python2.

* Run `Etc/install_plugin.sh` to install the plugin on your user gimp home folder.
  * `Etc/test_plugin.sh` can be run to check the installation.
* Launch Gimp, the plugins should be available under `<menu bar>/PkRender`
* You can also run then in batch mode : `Etc/render.sh`
  * Run `Etc/render.sh list "<pokemon>"` to search for available pokemons.
* In case of errors, check the logs at `./poke_plugins.log`

### Running gimp on a vagrant VM

* Run `cd Vagrant ; VAGRANT_HOME=vagrant.d vagrant up` to download, provision and start the VM.
  * `vagrant halt` or `vagrant destroy` to stop or clean the VM.
* Run `Etc/render.sh vm single "<pokemon>" "<image>"` to render a card into the current working dir.

## Directory structure

* `Batches/` : contains an example of batch xml input. It also contains `PkCardsClassicSet.xml`. This file contains all the metadata needed to render cards in batch mode.
* `Etc/` : contains the helper scripts and a some card demos
  * `Etc/LegacySchemeRenderer/` : _deprecated_ version of the plugin written in Scheme (I could not cope with the weird syntax)
* `Python/` : the python-fu code for the plugins (sorry for the awkward file naming convention)
* `SourceImages/` : The base images used to compose the final card
* `Vagrant/` : Configuration and homedir for the VM

## Demo

![card demo](Etc/EyeCandyDemo/mr_rufo.png)

[1]: http://en.wikipedia.org/wiki/Pok%C3%A9mon_Trading_Card_Game#Gameplay
[2]: http://www.gimp.org/docs/python/index.html
[3]: https://www.vagrantup.com/

