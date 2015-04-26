'''
Created on May 16, 2009
@summary: Gimp plugin that creates trainer cards.
@author: guevara
'''

from gimpfu import *
from util.Cst_ import *
logger = logging.getLogger(__name__)

#################### HEADER INFO ############################

pluginName = 'trainer_card'
registerHeader = [ pluginName,
  "Creates a Trainer card.",
  "Renders a Trainer card game card. All the parameters must be entered by the user",
  "Candide Guevara",
  "GNU General Public License, version 2",
  "2015",
  Cst.PLUGIN_FOLDER + '/' + pluginName,
  "", # Leave empty because we create a new image
]

#################### PARAMETERS ############################

registerParameters = [
  (PF_STRING,   "name", "The Trainer name.", ""),
  (PF_STRING,   "hitPoints", "The Trainer HP (used for some special trainers).", ""),
  (PF_FILE,     "imageFile", "The Trainer image file name.", ""),
  (PF_STRING,   "description", "The Trainer description.", ""),
]

registerReturn = [(PF_IMAGE, "TrainerCard", "The card rendered following the input parameters.")]

#################### PLUGIN MAIN ############################

def trManualMain(*plugin_args):
  logger.info("Launching render trainer : %r", plugin_args)
  try:
    from tr.RenderTrCard_ import RenderTrCard
    renderer = RenderTrCard(*plugin_args)
    cardImage = renderer.render()
    renderer.finalAction(cardImage)
  except:
    logger.exception("Trainer plugin end KO\n\n")
    raise
  logger.info("Trainer plugin end ok\n\n")
  return cardImage

#################### REGISTER TO THE PDB ############################

register(registerHeader[0], registerHeader[1], registerHeader[2], registerHeader[3], registerHeader[4], registerHeader[5], registerHeader[6], registerHeader[7],
      registerParameters, registerReturn,
      trManualMain)

#################### END ############################
main()
