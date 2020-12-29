'''
Created on May 16, 2009
@summary: Projet global constants and util methods.
@author: guevara
'''
import os, logging, sys, re

# Finds the higher version gimp plugin folder
# Runs **before** logging is configured
def findPluginDir():
  version_rx = re.compile('(\d+)\.(\d+)$')
  prjDir = ''
  candidates = [ os.path.join(os.environ['HOME'], p) 
                 for p in next(os.walk(os.environ['HOME']))[1]
                 if os.path.basename(p).startswith('.gimp') ]
  paths = [
    os.path.join(os.environ['HOME'], '.config', 'GIMP'),
    os.path.join(os.environ.get('XDG_CONFIG_HOME', ''), 'GIMP'),
  ]
  for path in paths:
    if os.path.isdir(path):
      candidates.extend(os.path.join(path, p) for p in next(os.walk(path))[1])

  def sort_key(p):
    m = version_rx.search(p)
    return int(m.group(1)) * 100 + int(m.group(2))

  prjDir = os.path.realpath(os.path.join(
    sorted(candidates, key=sort_key)[-1],
    'plug-ins'
  ))
  if not os.path.isdir(prjDir):
    raise Exception("PRJ_DIR='%s' is not a directory" % prjDir)
  return prjDir

class Cst:
  PRJ_DIR = findPluginDir()
  LOG_FILE = os.path.realpath('./poke_plugins.log')
  OUTPUT_DIR = os.path.realpath('.')
  
  PK_IMG_DIR = PRJ_DIR + "/SourceImages/Pokemons"
  TR_IMG_DIR = PRJ_DIR + "/SourceImages/Trainers"
  E_IMG_DIR = PRJ_DIR + "/SourceImages/Energies"
  E_TEMPLATE_DIR = PRJ_DIR + "/SourceImages/GimpWork/Energy"
  
  DB_XML_FILE = PRJ_DIR + "/Batches/PkCardsClassicSet.xml"
  
  PLUGIN_FOLDER = "<Toolbox>/PkRender"
  DEFAULT_IMG_FORMAT = 'png'

### END Cst  

def mkdirAtPath(path, name):
  assert os.path.isdir(path)
  fullPath = os.path.realpath(os.path.join(path, name))
  if not os.path.isdir(fullPath):
    os.mkdir(fullPath)
  return fullPath  

name_rx = re.compile('[^\w]+')
def sanitizeFileName(filename):
  dirname, leafname = os.path.split(filename)
  leafname = name_rx.sub('_', leafname).lower() 
  return os.path.join(dirname, leafname)

def findImageFile(dirname, name):
  if os.path.isfile(name):
    return os.path.realpath(name)
  fullPath = os.path.realpath(dirname + '/' + name)  
  assert os.path.isfile(fullPath)
  return fullPath

def checkPluginsInstalled():
  check_paths = [ Cst.PK_IMG_DIR, Cst.TR_IMG_DIR, Cst.E_IMG_DIR, Cst.E_TEMPLATE_DIR, ]
  if not all( os.path.isdir(p) for p in check_paths ):
    raise Exception('At least 1 of %r is missing' % check_paths)

def initLog ():
  format = '[%(levelname)s] %(name)s::%(funcName)s  %(message)s'
  logging.basicConfig(level=logging.DEBUG, format=format, filename=Cst.LOG_FILE, filemode='a')

initLog()
checkPluginsInstalled()

