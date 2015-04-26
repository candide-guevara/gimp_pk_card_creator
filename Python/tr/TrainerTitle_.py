'''
Created on Jan 2, 2011
Renders the trainer card title layers
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from util.LayerUtil_ import LayerUtil
from tr.TrCst_ import TrCst
logger = logging.getLogger(__name__)

class TrainerTitle(LayerUtil):
  
  def __init__(self, image, trId):
    LayerUtil.__init__(self, image)
    self.id = trId
    return
  
  def render(self):
    logger.debug("Rendering title for trainer " + self.id)
    gradLayer = self.renderGradient()
    textLayer = self.renderText()
    self.orderLayers(gradLayer, textLayer)
    self.selectNone()
    return
  
  def renderGradient(self):
    layer = self.renderNewLayer(TrCst.LY_TITLE_BKG, 
                                TrCst.TRAINER_DIMENSION[0], TrCst.TRAINER_DIMENSION[1])
    pdb.gimp_layer_set_offsets(layer, TrCst.TRAINER_CORNER[0], TrCst.TRAINER_CORNER[1])
    self.select(TrCst.TRAINER_CORNER[0], TrCst.TRAINER_CORNER[1],
                TrCst.TRAINER_DIMENSION[0], TrCst.TRAINER_DIMENSION[1])
    
    yEnd = 0
    yStart = TrCst.TRAINER_DIMENSION[1] + TrCst.TRAINER_GRAD_VERT_OFFSET
    self.fillGradient(layer, TrCst.TRAINER_GRAD,
                      0, yStart, 0, yEnd)
    pdb.gimp_layer_set_mode(layer, HARDLIGHT_MODE)
    return layer
  
  def renderText(self):    
    layer = self.renderTextLayer(TrCst.TRAINER_TITLE, TrCst.TRAINER_FONT,
                                 TrCst.TRAINER_FONT_COLOR, TrCst.TRAINER_FONT_SIZE)
    pdb.gimp_text_layer_set_letter_spacing(layer, TrCst.TRAINER_FONT_LETTER_SPACE)
    self.justify(layer, TEXT_JUSTIFY_CENTER)
    
    x = (TrCst.TRAINER_DIMENSION[0]-layer.width) / 2 + TrCst.TRAINER_CORNER[0]
    y = (TrCst.TRAINER_DIMENSION[1]-layer.height) / 2 + TrCst.TRAINER_CORNER[1]
    pdb.gimp_layer_set_offsets(layer, int(x), int(y))
    
    pdb.gimp_drawable_set_name(layer, TrCst.LY_TITLE)
    return layer
  
  def orderLayers(self, frontLayer, shadowLayer):
    return
  
