'''
Created on Dec 28, 2010
Main entry point to the python code for the render pokemon card plugin.
@author: guevara
'''
from gimpfu import *
from util.Cst_ import *
from util.ImageIO_ import ImageIO
from pk.PkCst_ import PkCst
from pk.Attack_ import Attack
from pk.PkPower_ import PkPower
from pk.Assembler_ import Assembler
from pk.Background_ import Background
from pk.Footer_ import Footer
from pk.Header_ import Header
logger = logging.getLogger(__name__)

class ActionParameterContainer():
  
  def __init__(self, action, whiteEcost, colorEcost, etype, actionName, actionText, actionDmg):
    self.type = action
    self.whiteECost = whiteEcost
    self.colorECost = colorEcost
    self.eType = etype
    self.name = actionName
    self.text = actionText
    self.dmg = actionDmg
    return
  
  def __repr__(self):
    parameters = [str(self.type), str(self.whiteECost), str(self.colorECost), str(self.eType),
                  str(self.name), self.text[0:20]+"...", str(self.dmg)]
    stringy = "Action Parameters : " + ", ".join(parameters)
    return stringy
  
class HeaderParameterContainer():
  
  def __init__(self, evolution, name, hitPoints, type, imageFile):
    self.evolution = evolution
    self.name = name
    self.hitPoints = hitPoints
    self.type = type
    self.imageFile = imageFile
    return
  
  def __repr__(self):
    parameters = [str(self.evolution), str(self.name), str(self.hitPoints),
                  str(self.type), str(self.imageFile)]
    stringy = "Header Parameters : " + ", ".join(parameters)
    return stringy
  
class FooterParameterContainer():
  
  def __init__(self, weakness, resistance, retreat, pkDescription):
    self.weakness = weakness
    self.resistance = resistance
    self.retreat = retreat
    self.pkDescription = pkDescription
    return
  
  def __repr__(self):
    parameters = [str(self.weakness), str(self.resistance), str(self.retreat),
                  self.pkDescription[0:20] + "..."]
    stringy = "Footer Parameters : " + ", ".join(parameters)
    return stringy


class RenderPkCard():

  def __init__(self, evolution, name, hitPoints, type, imageFile,
                 fstAction, whiteEcost1, colorEcost1, etype1, fstActionName, fstActionText, fstActionDmg,
                 scdAction, whiteEcost2, colorEcost2, etype2, scdActionName, scdActionText, scdActionDmg,
                 weakness, resistance, retreat, pkDescription):
    self.header = HeaderParameterContainer(evolution, name, hitPoints, type, imageFile)
    self.actions = [ActionParameterContainer(fstAction, whiteEcost1, colorEcost1, etype1, 
                                             fstActionName, fstActionText, fstActionDmg),
                    ActionParameterContainer(scdAction, whiteEcost2, colorEcost2, etype2, 
                                             scdActionName, scdActionText, scdActionDmg)]
    self.footer = FooterParameterContainer(weakness, resistance, retreat, pkDescription)
    return
  
  def render(self):
    logger.info("Launching rendering of pokemon card with parameters: %r", vars(self))
    
    cardImage = ImageIO.getImage(PkCst.CARD_DIMENSION[0], PkCst.CARD_DIMENSION[1])
    backg = Background(cardImage, self.header.type, self.header.imageFile)
    header = Header(cardImage, self.header.evolution, self.header.name, 
                    self.header.hitPoints, self.header.type)
    footer = Footer(cardImage, self.footer.weakness, self.footer.resistance, 
                    self.footer.retreat, self.footer.pkDescription)
    action1 = self.createAction(cardImage, 1, self.actions[0])
    action2 = self.createAction(cardImage, 2, self.actions[1])
    
    assembler = Assembler(cardImage, header, footer, backg, action1, action2)
    
    assembler.assemble()    
    return cardImage
  
  def createAction(self, cardImage, number, action):
    if action.type == PkCst.OPT_PK_POWER:
      return PkPower(number, cardImage, action.name, action.text)
    elif action.type == PkCst.OPT_ATTACK:
      return Attack(number, cardImage, action.whiteECost, action.colorECost, 
                    action.eType, action.name, action.text, action.dmg)
    return None
  
  def finalAction(self, image):
    logger.info("Finished, clearing selection and cleaning image")
    pdb.gimp_selection_none(image)
    image.clean_all()
    ImageIO.displayImage(image)
  
