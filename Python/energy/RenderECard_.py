'''
Created on Dec 28, 2010
Main entry point to the python code for the render energy card plugin.
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from util.LayerUtil_ import LayerUtil
from util.ImageIO_ import ImageIO
from energy.ECst_ import ECst
logger = logging.getLogger(__name__)

class RenderECard():

  def __init__(self, type):
    self.type = type
  
  def cardName(self, extra_id=None):
    if extra_id:
      return "energy_%s%s" % (self.type, extra_id)
    return 'energy_' + self.type

  def render(self):
    logger.debug("Rendering energy typed : %r", self.type)
    image = self.loadTemplate()
    self.paintBorder(image)

    logger.info("Finished, clearing selection and cleaning image")
    pdb.gimp_selection_none(image)
    image.clean_all()
    return image
  
  def paintBorder(self, image):
    layer = self.getBorderLayer(image)
    util = LayerUtil(image)
    util.selectAll()
    util.select(ECst.CARD_BORDER, ECst.CARD_BORDER, layer.width-2*ECst.CARD_BORDER,
                layer.height-2*ECst.CARD_BORDER, CHANNEL_OP_SUBTRACT)
    util.fillGradient(layer, ECst.GRAD_CARD_BORDER, 0, 0, ECst.CARD_DIMENSION[0], ECst.CARD_DIMENSION[1])
    return
  
  def getBorderLayer(self, image):
    lyUtil = LayerUtil(image)
    layer = lyUtil.getLayerByName(ECst.LY_BORDER)
    if not layer:
      layer = lyUtil.renderNewLayer(ECst.LY_BORDER, ECst.CARD_DIMENSION[0], ECst.CARD_DIMENSION[1])
    lyUtil.setLayerPostion(layer, LayerUtil.LY_TOP_POSITION)
    return layer
  
  def loadTemplate(self):
    set = {ECst.TYPE_DOUBLE_E : ECst.CARD_NAME_DOUBLE_E,
           ECst.TYPE_ELECTRIC_E : ECst.CARD_NAME_ELECTRIC_E,
           ECst.TYPE_FIRE_E : ECst.CARD_NAME_FIRE_E,
           ECst.TYPE_HEAL_E : ECst.CARD_NAME_HEAL_E,
           ECst.TYPE_LEAF_E :ECst.CARD_NAME_LEAF_E,
           ECst.TYPE_POTION_E : ECst.CARD_NAME_POTION_E,
           ECst.TYPE_PSY_E : ECst.CARD_NAME_PSY_E,
           ECst.TYPE_PUNCH_E : ECst.CARD_NAME_PUNCH_E,
           ECst.TYPE_RAINBOW_E : ECst.CARD_NAME_RAINBOW_E,
           ECst.TYPE_WATER_E : ECst.CARD_NAME_WATER_E,
           ECst.TYPE_WHITE_E : ECst.CARD_NAME_WHITE_E}
    if set[self.type]:
      file = Cst.E_TEMPLATE_DIR + "/" + set[self.type] + "." + ECst.TEMPLATE_CARD_FORMAT
      template = ImageIO.loadImage(file)
    else:
      logger.error("Could not find energy template for type : " + self.type)  
    return template
  
  def finalAction(self, image):
    ImageIO.displayImageOrSaveIfNonInteractive(image, self.cardName())

