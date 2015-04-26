'''
Created on Jan 2, 2011
Renders the trainer card header text layers
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from util.LayerUtil_ import LayerUtil
from tr.TrCst_ import TrCst
logger = logging.getLogger(__name__)

class TrainerHeader(LayerUtil):
  
  def __init__(self, image, name, damage, trId):
    LayerUtil.__init__(self, image)
    self.id = trId
    self.name = name
    self.damage = damage
    return
  
  def render(self):
    logger.debug("Rendering header text layers for trainer " + self.id)
    nameLayer = self.renderName()
    damageLayer = self.renderDamage()
    self.orderLayers(nameLayer, damageLayer)
    self.selectNone()
    return
  
  def renderName(self):
    layer = self.renderTextLayer(self.name, TrCst.NAME_FONT,
                                 TrCst.NAME_FONT_COLOR, TrCst.NAME_FONT_SIZE)
    self.justify(layer, TEXT_JUSTIFY_LEFT)
    
    x = TrCst.TRAINER_CORNER[0]
    height = TrCst.IMAGE_CORNER[1] - TrCst.TRAINER_CORNER[1] - TrCst.TRAINER_DIMENSION[1]
    y = (height-layer.height) / 2 + TrCst.TRAINER_CORNER[1] + TrCst.TRAINER_DIMENSION[1]
    pdb.gimp_layer_set_offsets(layer, int(x), int(y))
    
    pdb.gimp_drawable_set_name(layer, TrCst.LY_NAME)
    return layer
  
  def renderDamage(self):  
    if not self.damage:
      logger.debug("Trainer " + self.id + " has no damage field")
      return None  
    layer = self.renderTextLayer(self.damage, TrCst.HP_FONT,
                                 TrCst.HP_FONT_COLOR, TrCst.HP_FONT_SIZE)
    self.justify(layer, TEXT_JUSTIFY_RIGHT)
    
    x = TrCst.TRAINER_CORNER[0] + TrCst.TRAINER_DIMENSION[0] - layer.width
    height = TrCst.IMAGE_CORNER[1] - TrCst.TRAINER_CORNER[1] - TrCst.TRAINER_DIMENSION[1]
    y = (height-layer.height) / 2 + TrCst.TRAINER_CORNER[1] + TrCst.TRAINER_DIMENSION[1]
    pdb.gimp_layer_set_offsets(layer, int(x), int(y))
    
    pdb.gimp_drawable_set_name(layer, TrCst.LY_HP)
    return layer
  
  def orderLayers(self, frontLayer, backLayer):
    return
  
