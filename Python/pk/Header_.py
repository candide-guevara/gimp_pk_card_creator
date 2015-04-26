'''
Created on May 8, 2009
@summary: Holds header rendering info and can output a header layer.
@author: guevara
'''

from pk.PkCst_ import PkCst
from util.RenderBase_ import RenderBase

class Header(RenderBase):
 
  def __init__(self, cardImage, evolution, name, hp, type):
    RenderBase.__init__(self, cardImage)
    self.cardImage = cardImage
    self.evolution = evolution
    self.name = name
    self.hp = hp
    self.type = type
    self.headerLayer = None
    self.ly = None
    
  def getLayer(self):
    self.ly = [self.drawEvolution(), self.drawName(), self.drawType(), self.drawHP()]
    
    self.ly[0].set_offsets(PkCst.EVOLUTION_CORNER[0], PkCst.EVOLUTION_CORNER[1])
    self.ly[1].set_offsets(PkCst.NAME_CORNER[0], PkCst.NAME_CORNER[1])
    self.ly[2].set_offsets(PkCst.TYPE_CORNER[0], PkCst.TYPE_CORNER[1])
    self.ly[3].set_offsets(PkCst.TYPE_CORNER[0] - self.ly[3].width, PkCst.TYPE_CORNER[1])
    
    self.headerLayer = self.mergeLayer(self.ly)
    self.headerLayer.name = PkCst.LY_HEADER
    return self.headerLayer
  
  def drawEvolution(self):
    evolution = self.renderTextLayer(self.evolution, PkCst.EVOLUTION_FONT, 
                                     PkCst.EVOLUTION_FONT_COLOR, PkCst.EVOLUTION_FONT_SIZE)
    evolution.name = "Intern Layer Evolution"
    return evolution
  
  def drawName(self):
    name = self.renderTextLayer(self.name, PkCst.NAME_FONT, PkCst.NAME_FONT_COLOR, PkCst.NAME_FONT_SIZE)
    name.name = "Intern Layer PkName"
    return name
  
  def drawHP(self):
    hp = self.renderTextLayer(self.hp + "HP ", PkCst.HP_FONT, PkCst.HP_FONT_COLOR, PkCst.HP_FONT_SIZE)
    hp.name = "Intern Layer HP"
    return hp
  
  def drawType(self):
    type = self.loadELayer(self.type, PkCst.SMALL_E_SIZE)
    type.name = "Intern Layer PkType"
    return type
  
  