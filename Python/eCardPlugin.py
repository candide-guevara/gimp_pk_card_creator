'''
Created on Dec 28, 2010
@summary: Gimp plugin that creates energy cards. It currently only can customize the xcf templates.
@author: guevara
'''

from gimpfu import *
from util.Cst_ import *
logger = logging.getLogger(__name__)

#################### HEADER INFO ############################

pluginName = 'energy_card'
registerHeader = [ pluginName,
  "Creates an Energy card.",
  "Renders an Energy card game by entering its type. Special energy cards an also be rendered.",
  "Candide Guevara",
  "GNU General Public License, version 2",
  "2015",
  Cst.PLUGIN_FOLDER + '/' + pluginName,
  "", # Leave empty because we create a new image
]

#################### PARAMETERS ############################

registerParameters = [(PF_STRING, "type", "The Energy card type.", "")]
registerReturn = [(PF_IMAGE, "EnergyCard", "The energy card of the requested type")]

#################### PLUGIN MAIN ############################

def eManualMain(*plugin_args):
  logger.info("Launching energy card rendering : %r", plugin_args)
  try:
    from energy.RenderECard_ import RenderECard
    renderer = RenderECard(*plugin_args)  
    cardImage = renderer.render()
    renderer.finalAction(cardImage) 
  except:
    logger.exception("Energy plugin end KO\n\n")
    raise
  logger.info("Energy plugin end ok\n\n")
  return cardImage

#################### REGISTER TO THE PDB ############################

register(registerHeader[0], registerHeader[1], registerHeader[2], registerHeader[3], registerHeader[4], registerHeader[5], registerHeader[6], registerHeader[7],
      registerParameters, registerReturn,
      eManualMain)

#################### END ############################
main()

