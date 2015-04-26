'''
Created on May 10, 2009
@summary: Useful string functions.
@author: guevara
'''

from gimpfu import *
import re
from util.LayerUtil_ import LayerUtil

class TextUtil(LayerUtil):

  def __init__(self, image):
    LayerUtil.__init__(self, image)
    
  def lineWrapper(self, string, width, font, font_size):
    words = string.split()
    wrappedString = ""    
    j = 0
    
    while len(words):
      line = ""
      i = 0
      while self.extends(line, font, font_size)[0] < width:
        if i > 0: line += " "
        if i >= len(words): break
        line += words[i]
        i += 1
      if i <= 1: i = 2
      if j > 0: wrappedString += "\n"
      wrappedString += self.concatWords(words[0:i-1])
      if i >= len(words): 
        wrappedString += " " + words[-1]
        if self.extends(wrappedString, font, font_size)[0] >= width:
          wrappedString = re.sub(" ([^ ]*)$", "\n\\1", wrappedString)
        break       
      words = words[i-1:]
      j += 1
      
    return wrappedString
  
  def concatWords(self, words):
    concatStr = ""
    for j in range(len(words)):
      if j > 0: concatStr += " "
      concatStr += words[j]
    return concatStr
  
  def extends(self, string, font, font_size):
    return pdb.gimp_text_get_extents_fontname(string, font_size, PIXELS, font)
    
    