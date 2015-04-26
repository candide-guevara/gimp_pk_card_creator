'''
Created on May 11, 2009
@summary: Renders an pokemon power layer
@author: guevara
'''

from pk.PkCst_ import PkCst
from pk.Attack_ import Attack
import re

class PkPower(Attack):

  def __init__(self, number, cardImage, name, text):
    Attack.__init__(self, number, cardImage, None, None, None, name, text, None)
    
  def getLayer(self):
    self.ly += self.drawDescription()
    self.ly += [self.drawName()]
    
    if self.ly[0]:
      self.ly[0].set_offsets(PkCst.PW_START, PkCst.PW_DESCRIPTION_Y_OFFSET)
      if self.ly[1]:
        self.addOffset(self.ly[1], PkCst.PW_START, PkCst.PW_DESCRIPTION_Y_OFFSET)
      if self.ly[2]: 
        self.ly[2].set_offsets(PkCst.PW_START, 0)
    elif self.ly[2]:
      x = (int)((PkCst.PW_END+PkCst.PW_START-self.ly[2].width)/2)
      self.ly[2].set_offsets(x, 0) 
    
    self.ly = self.removeNone(self.ly)      
    self.actionLayer = self.mergeLayer(self.ly)  
    if self.number == 1:
      self.actionLayer.name = PkCst.LY_ACTION1
    else: self.actionLayer.name = PkCst.LY_ACTION2
    return self.actionLayer
  
  def drawDescription(self):
    textLayer = None
    eLayer = None
    
    if self.text:
      offsetDescription = self.titleOffset(self.name, PkCst.PW_NAME_FONT, PkCst.PW_NAME_FONT_SIZE, 
                                           PkCst.PW_DESCRIPTION_FONT, PkCst.PW_DESCRIPTION_FONT_SIZE) + self.text
      record = self.replaceAndWrap(PkCst.PW_END-PkCst.PW_START, offsetDescription, 
                                   PkCst.PW_DESCRIPTION_FONT, PkCst.PW_DESCRIPTION_FONT_SIZE)
                                           
      if record[1]:      
        offsets = self.getEOffsets(record[2], record[3], PkCst.PW_DESCRIPTION_FONT, PkCst.PW_DESCRIPTION_FONT_SIZE)
        eLayer = self.addELayers(record[1], offsets)
        eLayer.name = "Intern Layer MiniE" + `self.number`
      
      toBePrinted = self.subSameWidth(record[0], PkCst.PW_DESCRIPTION_FONT, PkCst.PW_DESCRIPTION_FONT_SIZE)
      toBePrinted = re.sub(self.subStr, " "*len(self.subStr), toBePrinted)
      textLayer = self.renderTextLayer(toBePrinted, PkCst.PW_DESCRIPTION_FONT,
                                       PkCst.PW_DESCRIPTION_FONT_COLOR, PkCst.PW_DESCRIPTION_FONT_SIZE) 
      
      textLayer.name = "Intern Layer PowerDescription" + `self.number`
      #self.justify(textLayer)      
    return [textLayer, eLayer]
  
  def drawName(self):
    layer = self.renderTextLayer(self.name, PkCst.PW_NAME_FONT, PkCst.PW_NAME_FONT_COLOR,
                                  PkCst.PW_NAME_FONT_SIZE)
    layer.name = "Intern Layer PwName" + `self.number`
    return layer
