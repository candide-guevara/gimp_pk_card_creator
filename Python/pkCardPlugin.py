'''
Created on May 8, 2009
@summary: Gimp plugin that creates pokemon cards
@author: guevara
'''

from gimpfu import *
from pk.PkCst_ import PkCst
from util.Cst_ import *
logger = logging.getLogger(__name__)

#################### HEADER INFO ############################

pluginName = 'pk_card'
registerHeader = [ pluginName,
  "Creates a Pokemon card.",
  "Renders a Pokemon card game card. ALL the parameters must be entered by the user. Consider the more convinient xml based plugin.",
  "Candide Guevara",
  "GNU General Public License, version 2",
  "2015",
  Cst.PLUGIN_FOLDER + '/' + pluginName,
  "", # Leave empty because we create a new image
]

#################### PARAMETERS ############################

registerParameters = [
  (PF_STRING,   "evolution", "The Pokemon evolution.", "Basic Pokemon"),
  (PF_STRING,   "name", "The Pokemon name.", ""),
  (PF_STRING,   "hitPoints", "The Pokemon HP.", "40"),
  (PF_STRING,   "type", "The Pokemon element type.", PkCst.OPT_FIRE),
  (PF_FILE,     "imageFile", "The Pokemon image file name. Relative to image repo.", ""),
  
  (PF_STRING,   "fstAction", "The Pokemon first action type.", PkCst.OPT_ATTACK),
  (PF_INT,      "whiteEcost1", "The Pokemon first action white energy cost.", 1),
  (PF_INT,      "colorEcost1", "The Pokemon first action color energy cost.", 1),
  (PF_STRING,   "etype1", "The Pokemon first action energy element type.", PkCst.OPT_WHITE),
  (PF_STRING,   "fstActionName", "The Pokemon first action name.", ""),
  (PF_STRING,   "fstActionText", "The Pokemon first action description.", ""),
  (PF_STRING,   "fstActionDmg", "The Pokemon first action damage.", ""),
  
  (PF_STRING,   "scdAction", "The Pokemon scd action type.", PkCst.OPT_ATTACK),
  (PF_INT,      "whiteEcost2", "The Pokemon scd action white energy cost.", 1),
  (PF_INT,      "colorEcost2", "The Pokemon scd action color energy cost.", 1),
  (PF_STRING,   "etype2", "The Pokemon scd action energy element type.", PkCst.OPT_FIRE),
  (PF_STRING,   "scdActionName", "The Pokemon scd action name.", ""),
  (PF_STRING,   "scdActionText", "The Pokemon scd action description.", ""),
  (PF_STRING,   "scdActionDmg", "The Pokemon scd action damage.", ""),
  
  (PF_STRING,   "weakness", "The Pokemon weakness.", PkCst.OPT_FIRE),
  (PF_STRING,   "resistance", "The Pokemon resistance.", PkCst.OPT_WATER),
  (PF_INT,      "retreat", "The Pokemon energy retreat cost.", 1),
  (PF_STRING,   "pkDescription", "The Pokemon description.", ""),
]

registerReturn = [(PF_IMAGE, "PokemonCard", "The card renderer following the input parameters.")]

#################### PLUGIN MAIN ############################

def pkManualMain(*a_lot_of_args):
  logger.info("Launching pokemon card render : %r", a_lot_of_args)
  try:
    from pk.RenderPkCard_ import RenderPkCard
    renderer = RenderPkCard(*a_lot_of_args)
    cardImage = renderer.render()
    renderer.finalAction(cardImage)
  except:
    logger.exception("Pokemon plugin end KO\n\n")
    raise
  logger.info("Pokemon plugin end ok\n\n")
  return cardImage

#################### REGISTER TO THE PDB ############################

register(registerHeader[0], registerHeader[1], registerHeader[2], registerHeader[3], registerHeader[4], registerHeader[5], registerHeader[6], registerHeader[7],
      registerParameters, registerReturn,
      pkManualMain)

#################### END ############################
main()
