'''
Created on May 8, 2009
@summary: Holds action rendering information and can output an Attack layer.
@author: guevara
'''

import re
from util.RenderBase_ import RenderBase
from pk.PkCst_ import PkCst

class Attack(RenderBase):

  def __init__(self, number, cardImage, whiteEcost, colorEcost, etype, name, text, dmg):
    RenderBase.__init__(self, cardImage)
    self.number = number
    self.cardImage = cardImage
    self.whiteECost = whiteEcost
    self.colorECost = colorEcost
    self.etype = etype
    self.name = name
    self.text = text
    self.dmg = dmg
    self.actionLayer = None
    self.ly = []
    self.subStr = "```"
    self.offsetChar = "@"
    
  def getLayer(self):
    self.ly += self.drawDmgAndName() + self.drawDescription()
    self.ly += [self.drawECost()]
    layerHeight = self.calculateHeight()
    
    if self.ly[0]:
      y = (int)((layerHeight-self.ly[0].height)/2)
      self.ly[0].set_offsets(PkCst.DAMAGE_START, y)
    if self.ly[2]:
      y = (int)((layerHeight-self.ly[2].height)/2) 
      self.ly[1].set_offsets(PkCst.ATTACK_START, y)
      y += PkCst.AT_DESCRIPTION_Y_OFFSET
      self.ly[2].set_offsets(PkCst.ATTACK_START, y)
      if self.ly[3]: self.addOffset(self.ly[3], PkCst.ATTACK_START, y)
    else:
      y = (int)((layerHeight-self.ly[1].height)/2)
      x = (int)((PkCst.ATTACK_END+PkCst.ATTACK_START-self.ly[1].width)/2)
      self.ly[1].set_offsets(x, y) 
    if self.ly[4]:
      y = (int)((layerHeight-self.ly[4].height)/2)
      self.ly[4].set_offsets(PkCst.E_COST_START, y) 
    
    self.ly = self.removeNone(self.ly)      
    self.actionLayer = self.mergeLayer(self.ly)  
    if self.number == 1:
      self.actionLayer.name = PkCst.LY_ACTION1
    else: self.actionLayer.name = PkCst.LY_ACTION2
    return self.actionLayer
  
  def calculateHeight(self):
    heights = []
    if self.ly[2]: heights += [self.ly[2].height]
    if self.ly[4]: heights += [self.ly[4].height]
    if self.ly[1]: heights += [self.ly[1].height]
    if self.ly[0]: heights  += [self.ly[0].height]
    heights.sort()
    return heights[-1]
  
  def drawDescription(self):
    textLayer = None
    eLayer = None
    
    if self.text:
      offsetDescription = self.titleOffset(self.name, PkCst.AT_NAME_FONT, PkCst.AT_NAME_FONT_SIZE, 
                                           PkCst.AT_DESCRIPTION_FONT, PkCst.AT_DESCRIPTION_FONT_SIZE) + self.text
      record = self.replaceAndWrap(PkCst.ATTACK_END-PkCst.ATTACK_START, offsetDescription, 
                                   PkCst.AT_DESCRIPTION_FONT, PkCst.AT_DESCRIPTION_FONT_SIZE)
                                           
      if record[1]:      
        offsets = self.getEOffsets(record[2], record[3], PkCst.AT_DESCRIPTION_FONT, PkCst.AT_DESCRIPTION_FONT_SIZE)
        eLayer = self.addELayers(record[1], offsets)
        eLayer.name = "Intern Layer MiniE" + `self.number`
      
      toBePrinted = self.subSameWidth(record[0], PkCst.AT_DESCRIPTION_FONT, PkCst.AT_DESCRIPTION_FONT_SIZE)
      toBePrinted = re.sub(self.subStr, " "*len(self.subStr), toBePrinted)
      textLayer = self.renderTextLayer(toBePrinted, PkCst.AT_DESCRIPTION_FONT,
                                       PkCst.AT_DESCRIPTION_FONT_COLOR, PkCst.AT_DESCRIPTION_FONT_SIZE) 
      
      textLayer.name = "Intern Layer AttackDescription" + `self.number`
      #self.justify(textLayer)
    return [textLayer, eLayer]
  
  def drawECost(self):
    elayers = []
    layer = None
    for i in range(self.whiteECost):
      elayers += [self.loadELayer(PkCst.OPT_WHITE, PkCst.SMALL_E_SIZE)]
    for i in range(self.colorECost):
      elayers += [self.loadELayer(self.etype, PkCst.SMALL_E_SIZE)]
    
    if len(elayers) == 0: return None    
    elif len(elayers) == 1:
      layer = elayers[0]
    else:
      elayers[1].set_offsets(PkCst.SMALL_E_DIMENSION[0]+2, 0)
      if len(elayers) == 3:
        elayers[2].set_offsets((int)(PkCst.SMALL_E_DIMENSION[0]/2)+1, PkCst.SMALL_E_DIMENSION[1])
      elif len(elayers) == 4:
        elayers[2].set_offsets(0, PkCst.SMALL_E_DIMENSION[1]+2)
        elayers[3].set_offsets(PkCst.SMALL_E_DIMENSION[0]+2, PkCst.SMALL_E_DIMENSION[1]+2)
      layer = self.mergeLayer(elayers)
      
    layer.name = "Intern Layer ECost" + `self.number`
    return layer
  
  def drawDmgAndName(self):
    layers = []
    if self.dmg:
      layers += [self.renderTextLayer(self.dmg, PkCst.DAMAGE_FONT, PkCst.DAMAGE_FONT_COLOR,
                                      PkCst.DAMAGE_FONT_SIZE)]
      layers[0].name = "Intern Layer Damage" + `self.number`
    else: layers += [None]
    
    layers += [self.renderTextLayer(self.name, PkCst.AT_NAME_FONT, PkCst.AT_NAME_FONT_COLOR,
                                    PkCst.AT_NAME_FONT_SIZE)]
    layers[1].name = "Intern Layer AtName" + `self.number`
    return layers
  
  def titleOffset(self, title, titleFont, titleFontSize, font, fontSize):
    titleWidth = self.extends(title, titleFont, titleFontSize)[0]
    spaceWidth = self.extends(self.offsetChar, font, fontSize)[0]
    offsetStr = self.offsetChar * (int)(1 + titleWidth / spaceWidth) + " "
    return offsetStr
  
  def replaceAndWrap(self, width, str, font, font_size):
    elements = re.findall('(<\w*\/>)', str, re.IGNORECASE)
    replaced = re.sub('(<\w*\/>)', self.subStr, str)
    replaced = self.lineWrapper(replaced, width, font, font_size)
    
    strBits = []
    lineBits = []
    if elements:
      tempStrs = re.split(self.subStr, replaced)
      for i in range(1,len(tempStrs)):
        strBits += [""] 
        lineBits += [""]
        for j in range(i): strBits[i-1] += tempStrs[j] + self.subStr
        strBits[i-1] = re.sub(self.subStr+'$', '', strBits[i-1])
        lineBits[i-1] = re.findall('\n?([^\n]*)$', strBits[i-1])[0]
      
    return (replaced, elements, strBits, lineBits)
  
  def getEOffsets(self, strBits, lineBits, font, font_size):
    offsets = []
    lineHeight = self.extends("|", font, font_size)[1]
    for i in range(len(strBits)):
      offsets += [[None, None]]
      offsets[i][0] = self.extends(lineBits[i], font, font_size)[0]
      offsets[i][1] = lineHeight * len(re.findall("\n", strBits[i]))
    return offsets
  
  def addELayers(self, elements, offsets):
    layers = []
    for i in range(len(elements)):
      layers += [self.loadELayer(elements[i], PkCst.MINI_E_SIZE)]
      layers[i].set_offsets(offsets[i][0], offsets[i][1])
    layer = self.mergeLayer(layers)
    return layer
  
  def subSameWidth(self, str, font, font_size):
    offset = re.findall(self.offsetChar+"+", str)[0]
    width = self.extends(offset, font, font_size)[0]
    spaceWidth = self.extends(" ", font, font_size)[0]
    newOffset = " " * (1 + (int)(width/spaceWidth))
    return re.sub(self.offsetChar+"+", newOffset, str)
