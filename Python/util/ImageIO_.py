'''
Created on May 8, 2009
@summary: Common methods on images
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
logger = logging.getLogger(__name__)

class ImageIO (object):
  
  @staticmethod
  def getImage(width=100, height=100):
    logger.debug("Creating new image : %r x %r", width, height)
    image = gimp.Image(width, height, RGB)
    image.disable_undo()
    return image
  
  @staticmethod
  def loadImage(imageName):
    logger.debug("Loading image : " + imageName)
    image = pdb.gimp_file_load(imageName, imageName)
    image.disable_undo()
    return image
  
  @staticmethod
  def displayImage(image):
    logger.debug("Displaying image : %r", image)
    try:
      display = gimp.Display(image)
    except:
      logger.exception('Failed to open display, maybe we are in batch mode ?')
      return None  
    return display  

  @staticmethod
  def saveImage(image, format, imageName):
    logger.debug("Saving image : " + imageName)
    fullName = imageName + "." + format
    layer = image.active_layer
    if format != "xcf":
      layer = pdb.gimp_image_merge_visible_layers(image, EXPAND_AS_NECESSARY)
    pdb.gimp_file_save(image, layer, fullName, fullName)
    return None

