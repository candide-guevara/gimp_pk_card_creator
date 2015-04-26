#!/usr/bin/env python
'''
Created on May 8, 2009
@summary: Trainer cards render constants
@author: guevara
'''

from pk.PkCst_ import PkCst
from gimpfu import HARDLIGHT_MODE

class TrCst:
  
########################### GENERAL PARAMETERS #####################################
  
  CARD_DIMENSION = PkCst.CARD_DIMENSION
  CARD_BORDER = PkCst.CARD_BORDER
  GRAD_CARD_BORDER = PkCst.GRAD_CARD_BORDER

############################### TR CARD SCRIPT PARAMETERS ####################################

  CARD_PATTERN = "Paper"
  
  IMAGE_DIMENSION = [420, 235]
  IMAGE_CORNER = [30, 125]
  IMAGE_SH = [8, 8, 15, (0, 0, 0), 80]
  
  DESCRIPTION_DIMENSION = [420, 240]
  DESCRIPTION_CORNER = [30, 375]
  DESCRIPTION_SH = [8, 8, 15, (0, 0, 0), 80]
  DESCRIPTION_GRAD = "Brushed Aluminium"
  DESCRIPTION_GRAD_VERT_OFFSET = 295
  DESCRIPTION_GRAD_TYPE = HARDLIGHT_MODE
  
  DESCRIPTION_FONT_COLOR = (50, 0, 0)
  DESCRIPTION_FONT = "Sans"
  DESCRIPTION_FONT_SIZE = 22
  DESCRIPTION_SMALL_FONT_SIZE = 18
  DESCRIPTION_MARGIN = 10
  
  NAME_FONT_COLOR = (0, 0, 0)
  NAME_FONT = "Sans"
  NAME_FONT_SIZE = 29
  
  HP_FONT_COLOR = (200, 0, 0)
  HP_FONT = "Sans Bold"
  HP_FONT_SIZE = 29
  
  TRAINER_DIMENSION = [420, 60]
  TRAINER_CORNER = [30, 25]
  TRAINER_GRAD = "Metallic Something"
  TRAINER_GRAD_VERT_OFFSET = 8
  TRAINER_GRAD_TYPE = HARDLIGHT_MODE
  
  TRAINER_FONT_COLOR = (0, 0, 100)
  TRAINER_FONT = "Sans Bold"
  TRAINER_FONT_SIZE = 35
  TRAINER_FONT_LETTER_SPACE = 5
  
  TRAINER_TITLE = "TRAINER"
  
############################## LAYER NAMES ###########################################
  
  LY_BACKGROUND =       "Background"
  LY_BORDER =           "Border"
  LY_DESCRIPTION_BKG =  "DescriptionBkg"
  LY_DESCRIPTION_SH =   "DescriptionShadow"
  LY_DESCRIPTION =      "Description"
  LY_IMAGE =            "Image"
  LY_NAME =             "Name"
  LY_DAMAGE =           "Damage"
  LY_TITLE_BKG =        "TitleBkg"
  LY_TITLE =            "Title"
  LY_HP =               "HpOrDamage"
