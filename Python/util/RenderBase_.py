'''
Created on May 8, 2009
@summary: Common methods for render classes.
@author: guevara
'''
from util.Cst_ import *
from pk.PkCst_ import PkCst
from util.TextUtil_ import TextUtil

class RenderBase(TextUtil):
  
  def __init__(self, image):
    TextUtil.__init__(self, image);
      
  def loadELayer(self, type, size):
    elayer = None
    if type != PkCst.OPT_NONE:
      fullPath = findImageFile(Cst.E_IMG_DIR, self.getEName(type, size))
      elayer = self.loadLayer(fullPath)
    return elayer
  
  def getEName(self, type, size):
    name = ""
    
    if type != PkCst.OPT_NONE:  
      if size == PkCst.SMALL_E_SIZE:
        if type == PkCst.OPT_FIRE: name = PkCst.SMALL_FIRE_E
        elif type == PkCst.OPT_LEAF: name = PkCst.SMALL_LEAF_E
        elif type == PkCst.OPT_PSY: name = PkCst.SMALL_PSY_E
        elif type == PkCst.OPT_ELECTRIC: name = PkCst.SMALL_ELECTRIC_E
        elif type == PkCst.OPT_PUNCH: name = PkCst.SMALL_PUNCH_E
        elif type == PkCst.OPT_WATER: name = PkCst.SMALL_WATER_E
        elif type == PkCst.OPT_WHITE: name = PkCst.SMALL_WHITE_E
        
        elif type == PkCst.MARKUP_FIRE: name = PkCst.SMALL_FIRE_E
        elif type == PkCst.MARKUP_LEAF: name = PkCst.SMALL_LEAF_E
        elif type == PkCst.MARKUP_PSY: name = PkCst.SMALL_PSY_E
        elif type == PkCst.MARKUP_ELECTRIC: name = PkCst.SMALL_ELECTRIC_E
        elif type == PkCst.MARKUP_PUNCH: name = PkCst.SMALL_PUNCH_E
        elif type == PkCst.MARKUP_WATER: name = PkCst.SMALL_WATER_E
        elif type == PkCst.MARKUP_WHITE: name = PkCst.SMALL_WHITE_E
        
      else:
        if type == PkCst.OPT_FIRE: name = PkCst.MINI_FIRE_E
        elif type == PkCst.OPT_LEAF: name = PkCst.MINI_LEAF_E
        elif type == PkCst.OPT_PSY: name = PkCst.MINI_PSY_E
        elif type == PkCst.OPT_ELECTRIC: name = PkCst.MINI_ELECTRIC_E
        elif type == PkCst.OPT_PUNCH: name = PkCst.MINI_PUNCH_E
        elif type == PkCst.OPT_WATER: name = PkCst.MINI_WATER_E
        elif type == PkCst.OPT_WHITE: name = PkCst.MINI_WHITE_E
        
        elif type == PkCst.MARKUP_FIRE: name = PkCst.MINI_FIRE_E
        elif type == PkCst.MARKUP_LEAF: name = PkCst.MINI_LEAF_E
        elif type == PkCst.MARKUP_PSY: name = PkCst.MINI_PSY_E
        elif type == PkCst.MARKUP_ELECTRIC: name = PkCst.MINI_ELECTRIC_E
        elif type == PkCst.MARKUP_PUNCH: name = PkCst.MINI_PUNCH_E
        elif type == PkCst.MARKUP_WATER: name = PkCst.MINI_WATER_E
        elif type == PkCst.MARKUP_WHITE: name = PkCst.MINI_WHITE_E
    return name 
  
  def getEColor(self, type):
    color = None
    if type == PkCst.OPT_FIRE: color = PkCst.FIRE_COLOR
    elif type == PkCst.OPT_LEAF: color = PkCst.LEAF_COLOR
    elif type == PkCst.OPT_PSY: color = PkCst.PSY_COLOR
    elif type == PkCst.OPT_ELECTRIC: color = PkCst.ELECTRIC_COLOR
    elif type == PkCst.OPT_PUNCH: color = PkCst.PUNCH_COLOR
    elif type == PkCst.OPT_WATER: color = PkCst.WATER_COLOR
    elif type == PkCst.OPT_WHITE: color = PkCst.WHITE_COLOR
    return color
  
  def removeNone(self, list):
    i = 0
    newList = list[:]
    while i < len(newList):
      if not newList[i]: newList = newList[:i] + newList[i+1:]
      else: i += 1
    return newList

