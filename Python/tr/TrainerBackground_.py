'''
Created on Jan 2, 2011
Renders the background layers for a trainer card.
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from util.LayerUtil_ import LayerUtil
from tr.TrCst_ import TrCst
logger = logging.getLogger(__name__)

class TrainerBackground(LayerUtil):
  
  def __init__(self, image, trId):
    LayerUtil.__init__(self, image)
    self.id = trId
    return
  
  def render(self):
    logger.debug("Rendering background for trainer " + self.id)
    bkgLayer = self.renderBackground()
    borderLayer = self.renderBorder()
    self.orderLayers(bkgLayer, borderLayer)
    self.selectNone()
    return
  
  def renderBackground(self):
    layer = self.renderNewLayer(TrCst.LY_BACKGROUND, TrCst.CARD_DIMENSION[0], TrCst.CARD_DIMENSION[1])
    self.selectAll()
    self.fillPattern(layer, TrCst.CARD_PATTERN)
    return layer
  
  def renderBorder(self):
    layer = self.renderNewLayer(TrCst.LY_BORDER, TrCst.CARD_DIMENSION[0], TrCst.CARD_DIMENSION[1])
    self.selectAll()
    self.select(TrCst.CARD_BORDER, TrCst.CARD_BORDER, layer.width-2*TrCst.CARD_BORDER,
                layer.height-2*TrCst.CARD_BORDER, CHANNEL_OP_SUBTRACT)
    self.fillGradient(layer, TrCst.GRAD_CARD_BORDER, 0, 0, TrCst.CARD_DIMENSION[0], TrCst.CARD_DIMENSION[1])
    return layer
  
  def orderLayers(self, bkgLayer, borderLayer):
    self.setLayerPostion(borderLayer, LayerUtil.LY_BOTTOM_POSITION)
    self.setLayerPostion(bkgLayer, LayerUtil.LY_BOTTOM_POSITION)
    return
