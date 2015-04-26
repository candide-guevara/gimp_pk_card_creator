'''
Created on Jan 2, 2011
Render the trainer card description text layer.
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from tr.TrCst_ import TrCst
from util.TextUtil_ import TextUtil
logger = logging.getLogger(__name__)

class TrainerText(TextUtil):
  
  BIG_FONT_MAX_LENGTH = 350
  
  def __init__(self, image, description, trId):
    TextUtil.__init__(self, image)
    self.id = trId
    self.description = description
    return
  
  def render(self):
    logger.debug("Rendering description text layer for trainer " + self.id)
    fontSize = self.getFontSize()
    self.renderDescription(fontSize)
    self.selectNone()
    return
  
  def getFontSize(self):
    fontSize = TrCst.DESCRIPTION_FONT_SIZE
    if len(self.description) > TrainerText.BIG_FONT_MAX_LENGTH:
      fontSize = TrCst.DESCRIPTION_SMALL_FONT_SIZE
    return fontSize
  
  def renderDescription(self, fontSize):
    maxLength = TrCst.DESCRIPTION_DIMENSION[0] - TrCst.DESCRIPTION_MARGIN
    toBePrinted = self.lineWrapper(self.description, maxLength,
                                   TrCst.DESCRIPTION_FONT, fontSize)
    layer = self.renderTextLayer(toBePrinted, TrCst.DESCRIPTION_FONT,
                                 TrCst.DESCRIPTION_FONT_COLOR, fontSize)
    self.justify(layer)
    
    x = (TrCst.DESCRIPTION_DIMENSION[0]-layer.width)/2 + TrCst.DESCRIPTION_CORNER[0]
    y = (TrCst.DESCRIPTION_DIMENSION[1]-layer.height)/2 + TrCst.DESCRIPTION_CORNER[1]
    pdb.gimp_layer_set_offsets(layer, int(x), int(y))
    
    pdb.gimp_drawable_set_name(layer, TrCst.LY_DESCRIPTION)
    return layer
  
