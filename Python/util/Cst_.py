'''
Created on May 16, 2009
@summary: Projet global constants and util methods.
@author: guevara
'''
import os, logging, sys, re

class Cst:
  PRJ_DIR = os.path.expanduser("~/.gimp-2.8/plug-ins")
  LOG_FILE = PRJ_DIR + '/poke_plugins.log'
  
  PK_IMG_DIR = PRJ_DIR + "/SourceImages/Pokemons"
  TR_IMG_DIR = PRJ_DIR + "/SourceImages/Trainers"
  E_IMG_DIR = PRJ_DIR + "/SourceImages/Energies"
  E_TEMPLATE_DIR = PRJ_DIR + "/SourceImages/GimpWork/Energy"
  
  BATCHJOBS_DIR = "Batches"
  DB_XML_FILE = PRJ_DIR + "/Batches/PkCardsClassicSet.xml"
  
  PLUGIN_FOLDER = "<Toolbox>/PkRender"

### END Cst  

def buildBatchJobPath(path, name):
  fullPath = os.path.realpath(path + '/' + name)
  if not os.path.isdir(fullPath):
    os.mkdir(fullPath)
  return fullPath  

def findImageFile(dirname, name):
  if os.path.isfile(name):
    return os.path.realpath(name)
  fullPath = os.path.realpath(dirname + '/' + name)  
  assert os.path.isfile(fullPath)
  return fullPath

def initLog ():
  blueFnt = '\033[94m'
  resetFnt = '\033[0m'
  format = '%s%%(levelname)s-%%(name)s::%%(funcName)s-> %s%%(message)s' % (blueFnt, resetFnt)
  logging.basicConfig(level=logging.DEBUG, format=format, filename=Cst.LOG_FILE, filemode='a')

initLog()

