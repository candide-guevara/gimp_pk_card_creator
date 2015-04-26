'''
Created on Jan 2, 2011
Renders the image layers
@author: guevara
'''
from gimpfu import *
from util.LayerUtil_ import LayerUtil
from util.Cst_ import *
from tr.TrCst_ import TrCst
logger = logging.getLogger(__name__)

class TrainerImage(LayerUtil):
  
  def __init__(self, image, pictureFile, trId):
    LayerUtil.__init__(self, image)
    self.id = trId
    self.pictureFile = pictureFile
    return
  
  def render(self):
    logger.debug("Rendering image and frame for trainer " + self.id)
    pictureLayer = self.renderPicture()
    shadowLayer = self.renderShadow(pictureLayer)
    self.orderAndMergeLayers(pictureLayer, shadowLayer)
    self.selectNone()
    return
  
  def renderPicture(self):
    fullPath = findImageFile(Cst.TR_IMG_DIR, self.pictureFile)
    layer = self.loadLayer(fullPath)
    self.scale(TrCst.IMAGE_DIMENSION[0], TrCst.IMAGE_DIMENSION[1], layer)
    pdb.gimp_layer_set_offsets(layer, TrCst.IMAGE_CORNER[0], TrCst.IMAGE_CORNER[1])    
    return layer
  
  def renderShadow(self, frontLayer):
    self.select(TrCst.IMAGE_CORNER[0], TrCst.IMAGE_CORNER[1],
                TrCst.IMAGE_DIMENSION[0], TrCst.IMAGE_DIMENSION[1])
    shadowParams = [self.image, frontLayer] + TrCst.IMAGE_SH + [False]
    pdb.script_fu_drop_shadow(*shadowParams)
    
    # We suppose that the shadow layer is at the top
    layer = self.image.layers[0]
    return layer
  
  def orderAndMergeLayers(self, frontLayer, shadowLayer):
    finalLayer = self.mergeLayer([frontLayer, shadowLayer])
    pdb.gimp_drawable_set_name(finalLayer, TrCst.LY_IMAGE)
    return
  
