'''
Created on May 8, 2009
@summary: Holds background (image, frame, cloud layer) rendering info and can output a background layer.
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from pk.PkCst_ import PkCst
from util.RenderBase_ import RenderBase

class Background(RenderBase):

  def __init__(self, cardImage, type, imageFile):
    RenderBase.__init__(self, cardImage)
    self.cardImage = cardImage
    self.type = type
    self.imageFile = imageFile
    self.ly = None;
    self.backgroundLayer = None
    
  def getLayer(self):
    self.ly = [self.drawImageFrame(), self.drawPicture(), self.drawCardFrame(), self.drawClouds()]
    
    self.ly[0].set_offsets(PkCst.IMAGE_CORNER[0]-PkCst.IMAGE_BORDER, PkCst.IMAGE_CORNER[1]-PkCst.IMAGE_BORDER)
    self.ly[1].set_offsets(PkCst.IMAGE_CORNER[0], PkCst.IMAGE_CORNER[1])
    self.ly[2].set_offsets(0, 0)
    self.ly[3].set_offsets(0, 0)
    
    self.backgroundLayer = self.mergeLayer(self.ly)
    self.backgroundLayer.name = PkCst.LY_BACK
    return self.backgroundLayer
  
  def drawClouds(self):
    backLayer = self.renderNewLayer("Temp", PkCst.CARD_DIMENSION[0], PkCst.CARD_DIMENSION[1])
    self.fillLayer(backLayer, PkCst.BACKGROUND_COLOR)
    
    layers = []
    for i in range(PkCst.FOG_RUNS):
      pdb.python_fu_foggify(self.cardImage, backLayer, "Temp" + `i`, self.getEColor(self.type), 
                            PkCst.FOG_PARAMETERS[0], PkCst.FOG_PARAMETERS[1])
      layers += [self.getLayerByName("Temp" + `i`)]      
    layers += [backLayer]
    
    clouds = self.mergeLayer(layers)
    clouds.name = "Intern Layer Background"
    return clouds
  
  def drawCardFrame(self):
    frame = self.renderNewLayer("Intern Layer CardFrame", PkCst.CARD_DIMENSION[0], PkCst.CARD_DIMENSION[1])
    self.select(PkCst.CARD_BORDER, PkCst.CARD_BORDER, frame.width-2*PkCst.CARD_BORDER,
                frame.height-2*PkCst.CARD_BORDER, CHANNEL_OP_SUBTRACT)
    self.fillGradient(frame, PkCst.GRAD_CARD_BORDER, 0, 0, frame.width, frame.height)
    return frame
  
  def drawImageFrame(self):
    frame = self.renderNewLayer("Intern Layer ImageFrame", PkCst.IMAGE_DIMENSION[0]+2*PkCst.IMAGE_BORDER,
                                 PkCst.IMAGE_DIMENSION[1]+2*PkCst.IMAGE_BORDER)
    self.select(PkCst.IMAGE_BORDER, PkCst.IMAGE_BORDER, frame.width-2*PkCst.IMAGE_BORDER,
                frame.height-2*PkCst.IMAGE_BORDER, CHANNEL_OP_SUBTRACT)
    self.fillGradient(frame, PkCst.GRAD_IMAGE_BORDER, 0, 0, frame.width, frame.height)
    return frame
  
  def drawPicture(self):
    fullPath = findImageFile(Cst.PK_IMG_DIR, self.imageFile)
    pkImage = self.loadLayer(fullPath)
    self.scale(PkCst.IMAGE_DIMENSION[0], PkCst.IMAGE_DIMENSION[1], pkImage)
    pkImage.name = "Intern Layer PkImage"
    return pkImage
