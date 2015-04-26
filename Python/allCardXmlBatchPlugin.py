'''
Created on May 19, 2009
@summary: Gimp plugin that takes a batch file and render the listed cards.
@author: guevara
'''

from gimpfu import *
from util.Cst_ import *
logger = logging.getLogger(__name__)

#################### HEADER INFO ############################

pluginName = 'batch_render'
registerHeader = [ pluginName,
  "Executes a Pokemon card batch job.",
  "Parses a Pokemon batch job xml file containing the cards to be rendered. You need to have the PkCards database to use this plugin.",
  "Candide Guevara",
  "GNU General Public License, version 2",
  "2015",
  Cst.PLUGIN_FOLDER + '/' + pluginName,
  "", # Leave empty because we create new images
]

#################### PARAMETERS ############################

registerParameters = [(PF_STRING, "batchFile", "The xml batch file.", "")]

#################### PLUGIN MAIN ############################

def pkBatchRenderer(*plugin_args):
  logger.info("Launching batch rendering : %r", plugin_args)
  try:
    from batchrender.BatchRenderer_ import BatchRenderer
    renderer = BatchRenderer(*plugin_args)
    renderer.render()
    renderer.finalAction()
  except:
    logger.exception("Batch plugin end KO\n\n")
    raise
  logger.info("Batch plugin end ok\n\n")

#################### REGISTER TO THE PDB ############################

register(registerHeader[0], registerHeader[1], registerHeader[2], registerHeader[3], registerHeader[4], registerHeader[5], registerHeader[6], registerHeader[7],
      registerParameters, [],
      pkBatchRenderer)

#################### END ############################
main()
