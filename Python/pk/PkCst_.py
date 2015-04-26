'''
Created on May 8, 2009
@summary: PkCst_ defining how a card will be rendered
@author: guevara
'''


########################### GENERAL PARAMETERS #####################################
class PkCst:
  
  CARD_DIMENSION = [480, 640]
  CARD_BORDER = 12
  GRAD_CARD_BORDER = "Yellow Orange" 
  
  FIRE_E =        "fire.png"
  SMALL_FIRE_E =    "fire_small.png"
  MINI_FIRE_E =    "fire_mini.png"
  WATER_E =        "water.png"
  SMALL_WATER_E =    "water_small.png"
  MINI_WATER_E =    "water_mini.png"
  LEAF_E =        "leaf.png"
  SMALL_LEAF_E =    "leaf_small.png"
  MINI_LEAF_E =    "leaf_mini.png"
  ELECTRIC_E =      "electric.png"
  SMALL_ELECTRIC_E =  "electric_small.png"
  MINI_ELECTRIC_E =  "electric_mini.png"
  PSY_E =        "psy.png"
  SMALL_PSY_E =    "psy_small.png"
  MINI_PSY_E =      "psy_mini.png"
  PUNCH_E =        "punch.png"
  SMALL_PUNCH_E =    "punch_small.png"
  MINI_PUNCH_E =    "punch_mini.png"
  WHITE_E =        "white.png"
  SMALL_WHITE_E =    "white_small.png"
  MINI_WHITE_E =    "white_mini.png"
  
  BACKGROUND_COLOR = (255, 255, 255)
  FIRE_COLOR = (225, 0, 0)
  WATER_COLOR = (90, 0, 255)
  LEAF_COLOR = (0, 225, 0)
  ELECTRIC_COLOR = (245, 245, 0)
  PSY_COLOR = (210, 0, 210)
  PUNCH_COLOR = (184, 54, 0)
  WHITE_COLOR = (205, 205, 205)
  
############################### PK CARD SCRIPT PARAMETERS ####################################
  
  IMAGE_DIMENSION = [353, 248]
  IMAGE_CORNER = [60, 70]
  IMAGE_BORDER = 8
  
  DESCRIPTION_DIMENSION = [395, 30]
  DESCRIPTION_CORNER = [36, 582]
  DESCRIPTION_BORDER = 4
  DESCRIPTION_FONT = "Sans Bold"
  DESCRIPTION_FONT_SIZE = 11
  DESCRIPTION_FONT_COLOR = (0, 0, 0)
  DESC_FRAME_OFFSET = [3, 2]
  
  SEPARATOR_DIMENSION = [420, 2]
  SEPARATOR_X = 30
  SEPARATOR_LAST_Y = 532
  SEPARATOR_COLOR = (0, 0, 0)
  
  ACTION_Y_START = IMAGE_DIMENSION[1] + IMAGE_CORNER[1] + IMAGE_BORDER
  ACTION_Y_SPACE = SEPARATOR_LAST_Y - ACTION_Y_START
  
  EVOLUTION_CORNER = [53, 20]
  EVOLUTION_FONT = "Sans"
  EVOLUTION_FONT_SIZE = 12
  EVOLUTION_FONT_COLOR = (0, 0, 0)
  
  NAME_CORNER = [53, 30]
  NAME_FONT = "Sans Bold"
  NAME_FONT_SIZE = 25
  NAME_FONT_COLOR = (0, 0, 0)
  
  HP_FONT = "Sans Bold"
  HP_FONT_SIZE = 24
  HP_FONT_COLOR = (170, 0, 0)
  
  TYPE_CORNER = [398, 25]
  
  PW_DESCRIPTION_Y_OFFSET = 3
  AT_DESCRIPTION_Y_OFFSET = PW_DESCRIPTION_Y_OFFSET
  
  E_COST_START = 35
  ATTACK_START = 110
  ATTACK_END = 385
  PW_START = 60
  PW_END = 405
  DAMAGE_START = 400
  
  AT_NAME_FONT = "Sans Bold"
  AT_NAME_FONT_SIZE = 16
  AT_NAME_FONT_COLOR = (0, 0, 0)
  
  AT_DESCRIPTION_FONT = "Sans"
  AT_DESCRIPTION_FONT_SIZE = 12
  AT_DESCRIPTION_FONT_COLOR = (0, 0, 0)
  
  PW_NAME_FONT = "Sans Bold"
  PW_NAME_FONT_SIZE = 16
  PW_NAME_FONT_COLOR = (255, 0, 0)
  
  PW_DESCRIPTION_FONT = "Sans"
  PW_DESCRIPTION_FONT_SIZE = 12
  PW_DESCRIPTION_FONT_COLOR = (0, 0, 0)
  
  DAMAGE_FONT = "Sans Bold"
  DAMAGE_FONT_SIZE = 24
  DAMAGE_FONT_COLOR = (0, 0, 0)
  
  WEAKNESS_NAME = "weakness"
  WEAKNESS_CORNER = [52, 535]
  WEAKNESS_ECORNER = [68, 549]
  WEAKNESS_FONT = "Sans Bold"
  WEAKNESS_FONT_SIZE = 12
  WEAKNESS_FONT_COLOR = (0, 0, 0)
  
  RESISTANCE_NAME = "resistance"
  RESISTANCE_CORNER = [202, 535]
  RESISTANCE_ECORNER = [225, 549]
  RESISTANCE_FONT = "Sans Bold"
  RESISTANCE_FONT_SIZE = 12
  RESISTANCE_FONT_COLOR = (0, 0, 0)
  
  RETREAT_NAME = "retreat"
  RETREAT_CORNER = [356, 535]
  RETREAT_ECORNER = [380, 549]
  RETREAT_ESPACE = 2
  RETREAT_FONT = "Sans Bold"
  RETREAT_FONT_SIZE = 12
  RETREAT_FONT_COLOR = (0, 0, 0)
  
################################# SCRIPT CONSTATNTS ####################################
  
  OPT_ATTACK = "attack"
  OPT_PK_POWER = "pk_power"
  OPT_NOTHING = "nothing"
  OPT_FIRE = "fire"
  OPT_WATER = "water"
  OPT_LEAF = "leaf"
  OPT_ELECTRIC = "electric"
  OPT_PSY = "psy"
  OPT_PUNCH = "punch"
  OPT_WHITE = "white"
  OPT_NONE = "none"
  
################################### MARKUP CONSTANTS ####################################
  
  MARKUP_FIRE =    "<fire/>"
  MARKUP_WATER =    "<water/>"
  MARKUP_LEAF =    "<leaf/>"
  MARKUP_ELECTRIC =  "<electric/>"
  MARKUP_PSY =    "<psy/>"
  MARKUP_PUNCH =    "<punch/>"
  MARKUP_WHITE =    "<white/>"
  
################################ LAYER NAMES #################################
  
  LY_BACK =       "Background"
  LY_HEADER =     "Header"
  LY_FOOTER =     "Footer"
  LY_ACTION1 =    "First Action"
  LY_ACTION2 =    "Second Action"
  
################################# GRAPHIC PARAMETERS ################################
  
  GRAD_IMAGE_BORDER = "Golden"
  GRAD_DESCRIPTION_BORDER = "Golden"
  
  FOG_RUNS = 3                # How many times the plugin will be applied
  FOG_PARAMETERS = [2.0, 45] # turbulence and transparency
  
################################ PYTHON SCRIPT CSTS #################################

  SMALL_E_SIZE = 1
  SMALL_E_DIMENSION = [30,30]
  MINI_E_SIZE = 0
  MINI_E_DIMENSION = [15,15]
  
