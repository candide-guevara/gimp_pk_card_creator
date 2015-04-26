'''
Created on Dec 27, 2010
Simple api to access the pokemon card database, the card information will be returned as an xml node.
@author: guevara
'''

from pk.PkCst_ import PkCst
from util.Cst_ import *
import xml.dom.minidom
from xml.dom import Node

class PkDataBase (object):

    def __init__(self):
      self.db = xml.dom.minidom.parse(Cst.DB_XML_FILE)
      self.dbRoot = self.db.getElementsByTagName('cards').item(0)
      self.pkList = self.dbRoot.getElementsByTagName('pokemons').item(0).childNodes
      self.trList = self.dbRoot.getElementsByTagName('trainers').item(0).childNodes
      self.eList = self.dbRoot.getElementsByTagName('energies').item(0).childNodes
      self.indexById()
    
    def indexById(self):
      self.idIndex = {}
      for node in self.pkList:
        if node.nodeType == Node.ELEMENT_NODE:
          self.idIndex[node.getAttribute('id')] = node
      for node in self.trList:
        if node.nodeType == Node.ELEMENT_NODE:
          self.idIndex[node.getAttribute('id')] = node
      for node in self.eList:
        if node.nodeType == Node.ELEMENT_NODE:
          self.idIndex[node.getAttribute('id')] = node
      
    def getNodeById(self, id, dieIfNotFound=False):      
      node = self.idIndex.get(id)
      assert node or not dieIfNotFound, "Did not find id %r in db" % id
      return node
    
    def getCardName(self, id):
      name = None
      node = self.getNodeById(id)
      if node:
        name = node.getAttribute('name')
      return name  
    
    def stringToType(self, typeName):
      '''
      @summary: String to action and element types
      '''
      if typeName.lower() == "attack":     return PkCst.OPT_ATTACK
      elif typeName.lower() == "pkpower":  return PkCst.OPT_PK_POWER
      elif typeName.lower() == "none":     return PkCst.OPT_NONE
      elif typeName.lower() == "nothing":  return PkCst.OPT_NOTHING
      elif typeName.lower() == "electric": return PkCst.OPT_ELECTRIC
      elif typeName.lower() == "fire":     return PkCst.OPT_FIRE
      elif typeName.lower() == "leaf":     return PkCst.OPT_LEAF
      elif typeName.lower() == "psy":      return PkCst.OPT_PSY
      elif typeName.lower() == "punch":    return PkCst.OPT_PUNCH
      elif typeName.lower() == "water":    return PkCst.OPT_WATER
      elif typeName.lower() == "white":    return PkCst.OPT_WHITE
      return None
        
