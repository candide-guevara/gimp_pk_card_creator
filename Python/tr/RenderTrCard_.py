'''
Created on Dec 29, 2010
Main entry point to the python code for the render trainer card plugin.
@author: guevara
'''
import gimpfu
from util.Cst_ import *
from util.ImageIO_ import ImageIO
from tr.TrCst_ import TrCst
from tr.TrainerBackground_ import TrainerBackground
from tr.TrainerTextBkg_ import TrainerTextBkg
from tr.TrainerImage_ import TrainerImage
from tr.TrainerTitle_ import TrainerTitle
from tr.TrainerHeader_ import TrainerHeader
from tr.TrainerText_ import TrainerText
logger = logging.getLogger(__name__)

class RenderTrCard (object):

  def __init__(self, name, hitPoints, imageFile, description):
    self.name = name
    self.hitPoints = hitPoints
    self.imageFile = imageFile
    self.description = description
    return
  
  def render(self):
    logger.info("Rendering trainer card with parameters : %r", vars(self))
    
    cardImage = ImageIO.getImage(TrCst.CARD_DIMENSION[0], TrCst.CARD_DIMENSION[1])
    (TrainerBackground(cardImage, self.name)).render()
    (TrainerTextBkg(cardImage, self.name)).render()
    (TrainerImage(cardImage, self.imageFile, self.name)).render()
    (TrainerTitle(cardImage, self.name)).render()
    (TrainerHeader(cardImage, self.name, self.hitPoints, self.name)).render()
    (TrainerText(cardImage, self.description, self.name)).render()
    return cardImage
  
  def finalAction(self, image):
    logger.info("Finished, clearing selection and cleaning image")
    gimpfu.pdb.gimp_selection_none(image)
    image.clean_all()
    ImageIO.displayImage(image)

