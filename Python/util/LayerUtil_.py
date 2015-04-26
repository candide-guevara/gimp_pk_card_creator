'''
Created on May 9, 2009
@summary: Some useful manipulations on layers.
@author: guevara
'''

from gimpfu import *
from util.Cst_ import *
logger = logging.getLogger(__name__)

DEF_LY_WIDTH = 100
DEF_LY_HEIGHT = 100

class LayerUtil (object):
  
  LY_TOP_POSITION = "top"
  LY_BOTTOM_POSITION = "bottom"
  
  def __init__(self, image):
    self.image = image
  
  def select(self, x, y, width, height, operation=CHANNEL_OP_REPLACE):
    pdb.gimp_rect_select(self.image, x, y, width, height, operation, False, 0.0)
    return None
  
  def selectNone(self):
    pdb.gimp_selection_none(self.image)
    return None
  
  def clear(self, layer, all=True):
    if all == True:
      self.selectAll()
    pdb.gimp_edit_clear(layer)
    return layer
  
  def addOffset(self, layer, x, y):
    layer.set_offsets(layer.offsets[0] + x, layer.offsets[1] + y)
    return layer
  
  def justify(self, layer, mode=TEXT_JUSTIFY_FILL):
    pdb.gimp_text_layer_set_justification(layer, mode)
    return layer
  
  def selectAll(self):
    pdb.gimp_selection_all(self.image)
    return None
  
  def fillLayer(self, layer, color):
    gimp.set_foreground(color)
    layer.fill(FOREGROUND_FILL)
    return layer
  
  def fill(self, layer, color, fill_mode=FG_BUCKET_FILL, paint_mode=NORMAL_MODE, opacity=100):
    gimp.set_foreground(color)
    pdb.gimp_edit_bucket_fill(layer, fill_mode, paint_mode, opacity, 128, False, 0, 0)
    return None
  
  def fillPattern(self, layer, pattern, paint_mode=NORMAL_MODE, opacity=100):
    pdb.gimp_context_set_pattern(pattern)
    pdb.gimp_edit_bucket_fill(layer, PATTERN_BUCKET_FILL, paint_mode, opacity, 128, False, 0, 0)
    return None
  
  def fillGradient(self, layer, gradient, x1, y1, x2, y2, reverse=False, 
                   gradientType=GRADIENT_LINEAR, repeat=REPEAT_NONE):
    if isinstance(gradient, str):
      pdb.gimp_context_set_gradient(gradient)
      pdb.gimp_edit_blend(layer, CUSTOM_MODE, NORMAL_MODE, gradientType, 100, 0, repeat, 
                          reverse, False, 1, 0, True, x1, y1, x2, y2)
    else:
      pdb.gimp_edit_blend(layer, gradient, NORMAL_MODE, gradientType, 100, 0, repeat, 
                          reverse, False, 1, 0, True, x1, y1, x2, y2)
    return None

  def renderNewLayer(self, name, width=DEF_LY_WIDTH, height=DEF_LY_HEIGHT):
    newLayer = gimp.Layer(self.image, name, width, height, RGBA_IMAGE, 100, NORMAL_MODE)
    self.image.add_layer(newLayer)
    self.select(0, 0, width, height)
    self.clear(newLayer, False)
    return newLayer
  
  def renderTextLayer(self, text, font, color, size):
    gimp.set_foreground(color)
    textLayer = pdb.gimp_text_fontname(self.image, None, 0.0, 0.0, text, -1, True, size, PIXELS, font)
    return textLayer
  
  def loadLayer(self, file):
    logger.debug("Loading image as layer " + file)
    layer = pdb.gimp_file_load_layer(self.image, file)
    self.image.add_layer(layer)
    return layer  
  
  def mergeLayer(self, layers, position=0, mode=EXPAND_AS_NECESSARY):
    reverseLayers = layers[:]
    reverseLayers.reverse()
    for ly in reverseLayers:
      pdb.gimp_image_raise_layer_to_top(self.image, ly)
    
    mergedLayer = layers[0]
    for ly in layers[1:]:
      mergedLayer = pdb.gimp_image_merge_down(self.image, mergedLayer, mode)
      
    self.setLayerPostion(mergedLayer, position)      
    return mergedLayer
  
  def scale(self, width, height, layer=None, interpolation=INTERPOLATION_LANCZOS, origin=True):
    if layer: pdb.gimp_layer_scale_full(layer, width, height, origin, interpolation)
    else: pdb.gimp_layer_scale_full(self.image, width, height, interpolation)
    return layer
  
  def setLayerPostion(self, layer, position):
    lyPosition = self.getLayerPosition(layer)
    
    if position == LayerUtil.LY_TOP_POSITION:
      pdb.gimp_image_raise_layer_to_top(self.image, layer)
    elif position == LayerUtil.LY_BOTTOM_POSITION:
      pdb.gimp_image_lower_layer_to_bottom(self.image, layer)
    elif lyPosition < position:
      for i in range(lyPosition, position):      
        self.image.lower_layer(layer)
    else :
      for i in range(position, lyPosition):      
        self.image.raise_layer(layer)
    return layer
  
  def getLayerPosition(self, layer):    
    return pdb.gimp_image_get_layer_position(self.image, layer)
  
  def getLayerByName(self, name):
    layer = None
    layers = self.image.layers
    for ly in layers:
      if name == ly.name: layer = ly
    return layer
