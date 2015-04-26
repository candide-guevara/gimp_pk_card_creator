'''
Created on May 8, 2009
@summary: Holds footer rendering info and can output a footer layer.
@author: guevara
'''

from gimpfu import CHANNEL_OP_SUBTRACT
from pk.PkCst_ import PkCst
from util.RenderBase_ import RenderBase

class Footer(RenderBase):

  def __init__(self, cardImage, weakness, resistance, retreat, pkDescription):
    RenderBase.__init__(self, cardImage)
    self.cardImage = cardImage
    self.weakness = weakness
    self.resistance = resistance
    self.retreat = retreat
    self.pkDescription = pkDescription
    self.ly = []
    self.footerLayer = None

  def getLayer(self):
    self.ly += self.drawText() # weakness, resistance, retreat
    self.ly += [self.drawFrame(), self.drawDescription(), 
                self.loadELayer(self.weakness, PkCst.SMALL_E_SIZE), #weakness index = 2, may be None
                self.loadELayer(self.resistance, PkCst.SMALL_E_SIZE), #resistance index = 3, may be None  
                self.drawRetreat()]
    
    self.ly[0].set_offsets(PkCst.WEAKNESS_CORNER[0], PkCst.WEAKNESS_CORNER[1])
    self.ly[1].set_offsets(PkCst.RESISTANCE_CORNER[0], PkCst.RESISTANCE_CORNER[1])
    self.ly[2].set_offsets(PkCst.RETREAT_CORNER[0], PkCst.RETREAT_CORNER[1])
    self.ly[3].set_offsets(PkCst.DESCRIPTION_CORNER[0], PkCst.DESCRIPTION_CORNER[1])
    self.ly[4].set_offsets(PkCst.DESCRIPTION_CORNER[0]+PkCst.DESCRIPTION_BORDER+PkCst.DESC_FRAME_OFFSET[0],
                           PkCst.DESCRIPTION_CORNER[1]+PkCst.DESCRIPTION_BORDER+PkCst.DESC_FRAME_OFFSET[1])
    
    if self.ly[5] != None: 
      self.ly[5].set_offsets(PkCst.WEAKNESS_ECORNER[0], PkCst.WEAKNESS_ECORNER[1])
    if self.ly[6] != None: 
      self.ly[6].set_offsets(PkCst.RESISTANCE_ECORNER[0], PkCst.RESISTANCE_ECORNER[1])
    if self.ly[7] != None:
      self.ly[7].set_offsets(PkCst.RETREAT_ECORNER[0]-self.ly[7].width/2, PkCst.RETREAT_ECORNER[1])
      
    self.ly = self.removeNone(self.ly)      
    self.footerLayer = self.mergeLayer(self.ly)  
    self.footerLayer.name = PkCst.LY_FOOTER
    return self.footerLayer
  
  def drawRetreat(self):
    if not self.retreat: return None
    layers = []
    for i in range(self.retreat):
      layers += [self.loadELayer(PkCst.OPT_WHITE, PkCst.SMALL_E_SIZE)]
      layers[i].set_offsets(i*layers[i].width + i*PkCst.RETREAT_ESPACE, 0)
      
    retreat = self.mergeLayer(layers)
    retreat.name = "Intern Layer Retreat"
    return retreat
  
  def drawFrame(self):
    frame = self.renderNewLayer("Intern Layer DescriptionFrame",
                                PkCst.DESCRIPTION_DIMENSION[0]+2*(PkCst.DESCRIPTION_BORDER+PkCst.DESC_FRAME_OFFSET[0]),
                                PkCst.DESCRIPTION_DIMENSION[1]+2*(PkCst.DESCRIPTION_BORDER))
    self.select(PkCst.DESCRIPTION_BORDER, PkCst.DESCRIPTION_BORDER, 
                frame.width-2*PkCst.DESCRIPTION_BORDER, frame.height-2*PkCst.DESCRIPTION_BORDER,
                CHANNEL_OP_SUBTRACT)
    self.fillGradient(frame, PkCst.GRAD_DESCRIPTION_BORDER, 0, 0, frame.width, frame.height)
    return frame
  
  def drawDescription(self):
    toBePrinted = self.lineWrapper(self.pkDescription, PkCst.DESCRIPTION_DIMENSION[0],
                                   PkCst.DESCRIPTION_FONT, PkCst.DESCRIPTION_FONT_SIZE)
    pkDescription = self.renderTextLayer(toBePrinted, PkCst.DESCRIPTION_FONT, 
                                         PkCst.DESCRIPTION_FONT_COLOR, PkCst.DESCRIPTION_FONT_SIZE)
    pkDescription.name = "Intern Layer PkDescription"
    self.justify(pkDescription)    
    return pkDescription
  
  def drawText(self):
    layers = []
    layers += [self.renderTextLayer(PkCst.WEAKNESS_NAME, PkCst.WEAKNESS_FONT, PkCst.WEAKNESS_FONT_COLOR,
                                    PkCst.WEAKNESS_FONT_SIZE)]
    layers[0].name = "Intern Layer WeaknessText"
    layers += [self.renderTextLayer(PkCst.RESISTANCE_NAME, PkCst.RESISTANCE_FONT, PkCst.RESISTANCE_FONT_COLOR,
                                    PkCst.RESISTANCE_FONT_SIZE)]
    layers[1].name = "Intern Layer ResistanceText"
    layers += [self.renderTextLayer(PkCst.RETREAT_NAME, PkCst.RETREAT_FONT, PkCst.RETREAT_FONT_COLOR, 
                                    PkCst.RETREAT_FONT_SIZE)]
    layers[2].name = "Intern Layer RetreatText"
    return layers
