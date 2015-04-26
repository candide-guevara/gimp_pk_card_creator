'''
Created on May 8, 2009
@summary: Orders the card layer to get the final image.
@author: guevara
'''
from gimpfu import *
from util.RenderBase_ import RenderBase
from pk.PkCst_ import PkCst

class Assembler(RenderBase):

  def __init__(self, cardImage, header, footer, background, action1, action2):
    RenderBase.__init__(self, cardImage)
    self.cardImage = cardImage
    self.header = header
    self.footer = footer
    self.background = background
    self.action1 = action1
    self.action2 = action2
    self.ly = []
    
  def assemble(self):
    self.ly += [self.offsetLayer(self.background, 0, 0, True)]
    self.ly += [self.offsetLayer(self.header, 0, 0, True)]
    self.ly += [self.offsetLayer(self.footer, 0, 0, True)]
    self.ly += self.assembleActions()
    
    if self.ly[2] and self.ly[5]:
      self.ly[2] = self.mergeLayer([self.ly[2], self.ly[5]])
      self.setLayerPostion(self.ly[2], "top")
      self.ly[2].name = PkCst.LY_FOOTER
    return None
  
  def offsetLayer(self, render, x, y, add=False):
    layer = None
    if render:
      layer = render.getLayer()
      if add: self.addOffset(layer, x, y)
      else: layer.set_offsets(x, y)
    return layer
  
  def assembleActions(self):
    lineLayer = action1 = action2 = None
    if self.action1:
      action1 = self.action1.getLayer()
    if self.action2:
      action2 = self.action2.getLayer()
      
    if action1 and action2:
      lineLayer = self.assemble2Actions(action1, action2)
    elif action1 or action2:
      lineLayer = self.assemble1Action(action1 or action2)
    return [action1, action2, lineLayer]
  
  def assemble2Actions(self, action1, action2):
    interSpace = (int)((PkCst.ACTION_Y_SPACE - (action1.height + action2.height)) / 4)
    self.addOffset(action1, 0, PkCst.ACTION_Y_START + interSpace)
    self.addOffset(action2, 0, PkCst.ACTION_Y_START + interSpace*3 + action1.height)
    yHigh = action1.offsets[1] + action1.height + interSpace    
    return self.drawLines(yHigh)
  
  def assemble1Action(self, action):
    interSpace = (int)((PkCst.ACTION_Y_SPACE - action.height) / 2)
    self.addOffset(action, 0, PkCst.ACTION_Y_START + interSpace)
    return self.drawLines()
  
  def drawLines(self, yHigh=0):
    layer = self.renderNewLayer("Intern Layer Separators", PkCst.CARD_DIMENSION[0], PkCst.CARD_DIMENSION[1])
    self.select(PkCst.SEPARATOR_X, PkCst.SEPARATOR_LAST_Y, PkCst.SEPARATOR_DIMENSION[0],
                PkCst.SEPARATOR_DIMENSION[1])
    self.fill(layer, PkCst.SEPARATOR_COLOR)
    if yHigh:
      self.select(PkCst.SEPARATOR_X, yHigh, PkCst.SEPARATOR_DIMENSION[0],
                PkCst.SEPARATOR_DIMENSION[1])
      self.fill(layer, PkCst.SEPARATOR_COLOR)
    return layer
