'''
Created on May 16, 2009
@summary: Reads a batch file and uses the pokemon card database to get the rendering parameters
@author: guevara
'''

import re
import xml.dom.minidom
from PkDataBase_ import PkDataBase
from pk.PkCst_ import PkCst
from util.Cst_ import *

class BatchReader(PkDataBase):

  def __init__(self, batchFile):
    PkDataBase.__init__(self);
    self.batchFile = batchFile
    self.batch = xml.dom.minidom.parse(batchFile)
    self.batchRoot = (self.batch.getElementsByTagName('batch')).item(0)
    self.batchPk = (self.batchRoot.getElementsByTagName('pokemons')).item(0)
    self.batchTr = (self.batchRoot.getElementsByTagName('trainers')).item(0)
    self.batchE = (self.batchRoot.getElementsByTagName('energies')).item(0)
    self.parseBatchParams(self.batchRoot)
    
  def parseBatchParams(self, batchElt):
    self.group = []
    if self.batchRoot.getAttribute('group'):
      self.group += [int(re.sub('(\d+)\*\d+', '\\1', self.batchRoot.getAttribute('group')))]
      self.group += [int(re.sub('\d+\*(\d+)', '\\1', self.batchRoot.getAttribute('group')))]
    
    self.resize = []
    if self.batchRoot.getAttribute('resize'):
      self.resize += [int(re.sub('(\d+)\*\d+', '\\1', self.batchRoot.getAttribute('resize')))]
      self.resize += [int(re.sub('\d+\*(\d+)', '\\1', self.batchRoot.getAttribute('resize')))]
    
  def getBatchOutDir(self):
    assert self.batchRoot.getAttribute('outfolder'), "Malformed batch xml at %s" % self.batchFile
    return self.batchRoot.getAttribute('outfolder')  

  def getBatchAttr(self, node):
    '''
    @summary: Returns : (id, occurrence, format, image)
    '''
    id = node.getAttribute("id")
    occurrence = node.getAttribute("occurrence") or "1"
    format = node.getAttribute("format") or "png"
    image = node.getAttribute("image")
    return (id, occurrence, format, image)
  
  def getPkParameters(self, node):
    (id, occurrence, format, image) = self.getBatchAttr(node)    
    pkNode = self.getNodeById(id, True)
    
    script_args = [pkNode.getElementsByTagName('headerinfo').item(0).getAttribute('evolution'), #0
                   pkNode.getElementsByTagName('headerinfo').item(0).getAttribute('name'), #1
                   pkNode.getElementsByTagName('headerinfo').item(0).getAttribute('hp'), #2
                   self.stringToType(pkNode.getElementsByTagName('headerinfo').item(0).getAttribute('type')), #3
                   image #4
                   ]
    
    if pkNode.getElementsByTagName('action1').length > 0:
      actionNode = pkNode.getElementsByTagName('action1').item(0)
      actionNodeText = None
      if actionNode.firstChild: actionNodeText = actionNode.firstChild.nodeValue
      script_args += [self.stringToType(actionNode.getAttribute('type')), #4
                      int(actionNode.getAttribute('wecost') or 0), #5
                      int(actionNode.getAttribute('colecost') or 0), #6
                      self.stringToType(actionNode.getAttribute('coletype')) or PkCst.OPT_WHITE, #7
                      actionNode.getAttribute('name'), #8
                      actionNodeText or '', #9
                      actionNode.getAttribute('damage') or "" #10
                      ]
    else: script_args += [PkCst.OPT_NONE, 0, 0, 0, PkCst.OPT_NONE, "", ""]
    
    if pkNode.getElementsByTagName('action2').length > 0:
      actionNode = pkNode.getElementsByTagName('action2').item(0)
      actionNodeText = None
      if actionNode.firstChild: actionNodeText = actionNode.firstChild.nodeValue
      script_args += [self.stringToType(actionNode.getAttribute('type')), #11
                      int(actionNode.getAttribute('wecost') or 0), #12
                      int(actionNode.getAttribute('colecost') or 0), #13
                      self.stringToType(actionNode.getAttribute('coletype')) or PkCst.OPT_WHITE, #14
                      actionNode.getAttribute('name'), #15
                      actionNodeText or '', #16
                      actionNode.getAttribute('damage') or "" #17
                      ]
    else: script_args += [PkCst.OPT_NONE, 0, 0, 0, PkCst.OPT_NONE, "", ""]            
    
    footerNodeText = None
    if pkNode.getElementsByTagName('description').item(0).firstChild:
      footerNodeText = pkNode.getElementsByTagName('description').item(0).firstChild.nodeValue
    script_args += [self.stringToType(pkNode.getElementsByTagName ('footerinfo').item(0).getAttribute('weakness')) or PkCst.OPT_NONE, #18
                    self.stringToType(pkNode.getElementsByTagName ('footerinfo').item(0).getAttribute('resistance')) or PkCst.OPT_NONE, #19
                    int(pkNode.getElementsByTagName('footerinfo').item(0).getAttribute('retreatcost') or 0), #20
                    footerNodeText or '' #21
                    ]
    
    return (id, occurrence, format, script_args)
  
  def getTrParameters(self, node):
    (id, occurrence, format, image) = self.getBatchAttr(node)    
    trNode = self.getNodeById(id, True)
    
    script_args = [trNode.getAttribute('name'),
                   trNode.getElementsByTagName('headerinfo').item(0).getAttribute('hp'),
                   image]
    
    if trNode.getElementsByTagName('description').item(0).firstChild:
      trDescription = trNode.getElementsByTagName('description').item(0).firstChild.nodeValue
    script_args += [trDescription]
    return (id, occurrence, format, script_args)
  
  def getEParameters(self, node):
    (id, occurrence, format, image) = self.getBatchAttr(node)    
    eNode = self.getNodeById(id, True)
    script_args = [eNode.getElementsByTagName('headerinfo').item(0).getAttribute('type')]
    return (id, occurrence, format, script_args)
  
