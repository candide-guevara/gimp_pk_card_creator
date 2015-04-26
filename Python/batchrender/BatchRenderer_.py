'''
Created on May 20, 2009
This batch renderer reads an XML file which contains all the cards you want to render at once.
@author: guevara
'''
import glob, shutil
from gimpfu import *
from util.Cst_ import *
from BatchReader_ import BatchReader
from util.ImageIO_ import ImageIO
from pk.RenderPkCard_ import RenderPkCard
from tr.RenderTrCard_ import RenderTrCard
from energy.RenderECard_ import RenderECard
logger = logging.getLogger(__name__)

class BatchRenderer(BatchReader):
  
  def __init__(self, batchFile):
    BatchReader.__init__(self, batchFile)
    self.outFolder = buildBatchJobPath(os.path.dirname(self.batchFile), self.getBatchOutDir())
    self.pkFolder = self.outFolder + "/Pokemons"
    self.trFolder = self.outFolder + "/Trainers"
    self.eFolder = self.outFolder + "/Energies"
    self.printFolder = self.outFolder + "/Print"
    self.createDirStructure(batchFile)

  def createDirStructure(self, batchFile):
    if os.path.exists(self.pkFolder): shutil.rmtree(self.pkFolder)
    os.mkdir(self.pkFolder)
    if os.path.exists(self.trFolder): shutil.rmtree(self.trFolder)
    os.mkdir(self.trFolder)
    if os.path.exists(self.eFolder): shutil.rmtree(self.eFolder)
    os.mkdir(self.eFolder)
    if os.path.exists(self.printFolder): shutil.rmtree(self.printFolder)
    os.mkdir(self.printFolder)
    return None
  
  def render(self):
    nodeList = self.batchPk.getElementsByTagName('card')
    for i in range(nodeList.length):
      record = self.getPkParameters(nodeList.item(i))
      self.renderSingleCard(record, RenderPkCard, self.pkFolder)
      
    nodeList = self.batchTr.getElementsByTagName('card')
    for i in range(nodeList.length):
      record = self.getTrParameters(nodeList.item(i))
      self.renderSingleCard(record, RenderTrCard, self.trFolder)
      
    nodeList = self.batchE.getElementsByTagName('card')  
    for i in range(nodeList.length):
      record = self.getEParameters(nodeList.item(i))
      self.renderSingleCard(record, RenderECard, self.eFolder)
  
  def renderSingleCard(self, record, renderKlass, dir):
    (id, occurrence, format, parameters) = record
    logger.info("Launching rendering of : " + id + " / " + `self.getCardName(id)`)
    name = self.getCardFileName(id, dir)
    
    renderer = renderKlass(*parameters)
    image = renderer.render()
    renderer.finalAction(image)
    
    self.saveImage(image, name, occurrence, format)
    return None
  
  def getCardFileName(self, id, dir):
    name = dir + "/" + self.getCardName(id)
    alreadyThere = glob.glob(name + "*")
    if alreadyThere: name += `len(alreadyThere)` + "-"
    return name
  
  def saveImage(self, image, name, occurrence, format):
    logger.info("Saving rendered card under : " + name + "." + format)
    for i in range(int(occurrence)):
      ImageIO.saveImage(image, format, name + "-" + `i`)
    return None
  
  def finalAction(self, image=None):
    logger.info("Finished !")
    
