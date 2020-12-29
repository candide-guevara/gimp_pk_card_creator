'''
Created on May 8, 2009
@summary: Common methods on images
@author: guevara
'''
import os
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
  def loadImage(imagePath):
    logger.debug("Loading image : " + imagePath)
    image = pdb.gimp_file_load(imagePath, imagePath)
    image.disable_undo()
    return image
  
  # Be carefull it is a trap !
  # There is no other f*cking way to know a pluging is run in non interactive mode
  # Calling `gimp.display_name()` in non-interactive mode will even segfault the plugin process ...
  # https://gitlab.gnome.org/GNOME/gimp/-/blob/gimp-2-10/plug-ins/pygimp/gimpmodule.c
  # https://gitlab.gnome.org/GNOME/gimp/-/blob/gimp-2-10/plug-ins/pygimp/gimpfu.py
  @staticmethod
  def isNonInteractive():
    return gimp.default_display() is None

  @staticmethod
  def displayImageOrSaveIfNonInteractive(image, imagePathNoExt):
    if ImageIO.isNonInteractive():
      ImageIO.saveImage(image, Cst.DEFAULT_IMG_FORMAT, imagePathNoExt)
    else:
      ImageIO.displayImage(image)
    return None

  @staticmethod
  def displayImage(image):
    logger.debug("Displaying image : %r", image)
    try:
      display = gimp.Display(image)
    except:
      logger.exception('Failed to open display, maybe we are in batch mode ?')
      return None  
    return display  

  # Always saves at root `Cst.OUTPUT_DIR`
  @staticmethod
  def saveImage(image, format, imagePathNoExt):
    if os.path.commonprefix([imagePathNoExt, Cst.OUTPUT_DIR]) != Cst.OUTPUT_DIR:
      imagePathNoExt = os.path.join(Cst.OUTPUT_DIR, imagePathNoExt)
    imagePathNoExt = sanitizeFileName(imagePathNoExt)
    assert os.path.isdir(os.path.dirname(imagePathNoExt))

    logger.debug("Saving image : " + imagePathNoExt)
    fullName = imagePathNoExt + "." + format
    layer = image.active_layer
    if format != "xcf":
      layer = pdb.gimp_image_merge_visible_layers(image, EXPAND_AS_NECESSARY)
    pdb.gimp_file_save(image, layer, fullName, fullName)
    return None

