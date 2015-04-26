'''
Created on Jan 2, 2011
Renders the trainer card description background frame.
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from util.LayerUtil_ import LayerUtil
from tr.TrCst_ import TrCst
logger = logging.getLogger(__name__)

class TrainerTextBkg(LayerUtil):
  
  def __init__(self, image, trId):
    LayerUtil.__init__(self, image)
    self.id = trId
    return
  
  def render(self):
    logger.debug("Rendering description frame for trainer " + self.id)
    bkgLayer = self.renderBackground()
    shadowLayer = self.renderShadow(bkgLayer)
    self.orderLayers(bkgLayer, shadowLayer)
    self.selectNone()
    return
  
  def renderBackground(self):
    layer = self.renderNewLayer(TrCst.LY_DESCRIPTION_BKG, 
                                TrCst.DESCRIPTION_DIMENSION[0], TrCst.DESCRIPTION_DIMENSION[1])
    pdb.gimp_layer_set_offsets(layer, TrCst.DESCRIPTION_CORNER[0], TrCst.DESCRIPTION_CORNER[1])
    self.selectAll()
    
    yStart = TrCst.DESCRIPTION_DIMENSION[1]
    yEnd = -TrCst.DESCRIPTION_GRAD_VERT_OFFSET
    self.fillGradient(layer, TrCst.DESCRIPTION_GRAD,
                      0, yStart, 0, yEnd)    
    pdb.gimp_layer_set_mode(layer, HARDLIGHT_MODE)
    return layer
  
  def renderShadow(self, frontLayer):
    self.select(TrCst.DESCRIPTION_CORNER[0], TrCst.DESCRIPTION_CORNER[1],
                TrCst.DESCRIPTION_DIMENSION[0], TrCst.DESCRIPTION_DIMENSION[1])
    shadowParams = [self.image, frontLayer] + TrCst.DESCRIPTION_SH + [False]
    pdb.script_fu_drop_shadow(*shadowParams)
    
    # We suppose that the shadow layer is at the top
    layer = self.image.layers[0]
    pdb.gimp_drawable_set_name(layer, TrCst.LY_DESCRIPTION_SH)
    return layer
  
  def orderLayers(self, frontLayer, shadowLayer):
    frontPosition = self.getLayerPosition(frontLayer)
    self.setLayerPostion(shadowLayer, frontPosition)
    return
  
