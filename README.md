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

## Getting started

* Run **Etc/install\_plugin.sh -h**, to either install the plugin or run a small test suite.
* Launch Gimp, the plugins should be available under \<menu bar\>/PkRender
* You can also run then in batch mode :   
  gimp -b (python-fu-\<plugin name\> RUN-NONINTERACTIVE \<other args\>)
* In case of errors, check the **logs** at ~/.gimp-\<version\>/plug-ins/poke\_plugins.log  

## Directory structure

* Batches/ : contains an example of batch xml input. It also contains **PkCardsClassicSet.xml**.
  This file contains all the metadata needed to render cards in batch mode.
* Etc/ : contains the install script and a some card demos
* Etc/LegacySchemeRenderer/ : **deprecated** version of the plugin written in Scheme (I could
  not cope with the weird syntax)
* Python/ : the python-fu code for the plugins (sorry for the awkward file naming convention)
* SourceImages/ : The base images used to compose the final card

## Demo
![card demo](Etc/EyeCandyDemo/mr_rufo.png)

[1]: http://en.wikipedia.org/wiki/Pok%C3%A9mon_Trading_Card_Game#Gameplay
[2]: http://www.gimp.org/docs/python/index.html

