;	Pokemon Card Parameters
;
;	Constant-prefix : PK1	
;
;	Esteban Guevara
;	2008

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GENERAL PARAMETERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define CARD_DIMENSION '(480 640))
(define CARD_BORDER 15)
(define GRAD_CARD_BORDER "Yellow Orange")

(define DIR_ROOT		"/home/guevara/Pictures/Poke/")
(define IMAGE_DIR		"/home/guevara/Pictures/Poke/Pictures/")
(define CARD_DIR		"/home/guevara/Pictures/Poke/Cards/")
(define ENERGY_DIR	"/home/guevara/Pictures/Poke/Energy/")
(define TRAINER_DIR	"/home/guevara/Pictures/Poke/Trainers/")

(define FIRE_E						"fire.png")
(define SMALL_FIRE_E			"fire_small.png")
(define MINI_FIRE_E				"fire_mini.png")
(define WATER_E					"water.png")
(define SMALL_WATER_E		"water_small.png")
(define MINI_WATER_E			"water_mini.png")
(define LEAF_E						"leaf.png")
(define SMALL_LEAF_E			"leaf_small.png")
(define MINI_LEAF_E				"leaf_mini.png")
(define ELECTRIC_E				"electric.png")
(define SMALL_ELECTRIC_E	"electric_small.png")
(define MINI_ELECTRIC_E		"electric_mini.png")
(define PSY_E							"psy.png")
(define SMALL_PSY_E			"psy_small.png")
(define MINI_PSY_E				"psy_mini.png")
(define PUNCH_E					"punch.png")
(define SMALL_PUNCH_E		"punch_small.png")
(define MINI_PUNCH_E			"punch_mini.png")
(define WHITE_E						"white.png")
(define SMALL_WHITE_E		"white_small.png")
(define MINI_WHITE_E			"white_mini.png")

(define BACKGROUND_COLOR '(255 255 255))
(define FIRE_COLOR '(225 0 0))
(define WATER_COLOR '(0 0 255))
(define LEAF_COLOR '(0 225 0))
(define ELECTRIC_COLOR '(245 245 0))
(define PSY_COLOR '(210 0 210))
(define PUNCH_COLOR '(184 54 0))
(define WHITE_COLOR '(205 205 205))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PK CARD SCRIPT PARAMETERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define PK1_IMAGE_DIMENSION '(353 248))
(define PK1_IMAGE_CORNER '(60 70))
(define PK1_IMAGE_BORDER 9)

(define PK1_DESCRIPTION_DIMENSION '(395 30))
(define PK1_DESCRIPTION_CORNER '(43 586))
(define PK1_DESCRIPTION_BORDER 4)
(define PK1_DESCRIPTION_FONT "Sans Bold")
(define PK1_DESCRIPTION_FONT_SIZE 11)
(define PK1_DESCRIPTION_FONT_COLOR '(0 0 0))

(define PK1_SEPARATOR_DIMENSION '(420 2))
(define PK1_SEPARATOR_CORNER '(30 532))
(define PK1_SEPARATOR_COLOR '(0 0 0))

(define PK1_EVOLUTION_CORNER '(53 20))
(define PK1_EVOLUTION_FONT "Sans Bold")
(define PK1_EVOLUTION_FONT_SIZE 12)
(define PK1_EVOLUTION_FONT_COLOR '(0 0 0))

(define PK1_NAME_CORNER '(53 30))
(define PK1_NAME_FONT "Sans Bold")
(define PK1_NAME_FONT_SIZE 25)
(define PK1_NAME_FONT_COLOR '(0 0 0))

(define PK1_HP_FONT "Sans Bold")
(define PK1_HP_FONT_SIZE 24)
(define PK1_HP_FONT_COLOR '(170 0 0))

(define PK1_TYPE_CORNER '(398 25))

(define PK1_SINGLE_ECOST_START 57)
(define PK1_DOUBLE_ECOST_START 38)
(define PK1_DOUBLE_ECOST_START_2 75)

(define PK1_PW_DESCRIPTION_Y_OFFSET 3)
(define PK1_AT_DESCRIPTION_Y_OFFSET 3)

(define PK1_E_COST_START 35)
(define PK1_ATTACK_START 110)
(define PK1_ATTACK_END 385)
(define PK1_PW_START 60)
(define PK1_PW_END 405)
(define PK1_DAMAGE_START 395)

(define PK1_AT_NAME_FONT "Sans Bold")
(define PK1_AT_NAME_FONT_SIZE 16)
(define PK1_AT_NAME_FONT_COLOR '(0 0 0))

(define PK1_AT_DESCRIPTION_FONT "Sans")
(define PK1_AT_DESCRIPTION_FONT_SIZE 12)
(define PK1_AT_DESCRIPTION_FONT_COLOR '(0 0 0))

(define PK1_PW_NAME_FONT "Sans Bold")
(define PK1_PW_NAME_FONT_SIZE 16)
(define PK1_PW_NAME_FONT_COLOR '(255 0 0))

(define PK1_PW_DESCRIPTION_FONT "Sans")
(define PK1_PW_DESCRIPTION_FONT_SIZE 12)
(define PK1_PW_DESCRIPTION_FONT_COLOR '(0 0 0))

(define PK1_DAMAGE_FONT "Sans Bold")
(define PK1_DAMAGE_FONT_SIZE 24)
(define PK1_DAMAGE_FONT_COLOR '(0 0 0)) 

(define PK1_LAST_SEPARATOR_Y 532)

(define PK1_WEAKNESS_CORNER '(52 535))
(define PK1_WEAKNESS_ECORNER '(68 549))
(define PK1_WEAKNESS_FONT "Sans Bold")
(define PK1_WEAKNESS_FONT_SIZE 12)
(define PK1_WEAKNESS_FONT_COLOR '(0 0 0))

(define PK1_RESISTANCE_CORNER '(202 535))
(define PK1_RESISTANCE_ECORNER '(225 549))
(define PK1_RESISTANCE_FONT "Sans Bold")
(define PK1_RESISTANCE_FONT_SIZE 12)
(define PK1_RESISTANCE_FONT_COLOR '(0 0 0))

(define PK1_RETREAT_CORNER '(341 535))
(define PK1_RETREAT_ECORNER_1 '(365 549))
(define PK1_RETREAT_ECORNER_2 '(350 549))
(define PK1_RETREAT_ECORNER_3 '(335 549))
(define PK1_RETREAT_ECORNER_4 '(320 549))
(define PK1_RETREAT_FONT "Sans Bold")
(define PK1_RETREAT_FONT_SIZE 12)
(define PK1_RETREAT_FONT_COLOR '(0 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SCRIPT CONSTATNTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define PK1_OPT_ATTACK 0)
(define PK1_OPT_PK_POWER 1)
(define PK1_OPT_NOTHING 1)
(define PK1_OPT_FIRE 0)
(define PK1_OPT_WATER 1)
(define PK1_OPT_LEAF 2)
(define PK1_OPT_ELECTRIC 3)
(define PK1_OPT_PSY 4)
(define PK1_OPT_PUNCH 5)
(define PK1_OPT_WHITE 6)
(define PK1_OPT_NONE 6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MARKUP CONSTANTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define PK1_TOKEN #\-)
(define PK1_TOKEN_FIRE #\1)
(define PK1_TOKEN_WATER #\2)
(define PK1_TOKEN_LEAF #\3)
(define PK1_TOKEN_ELECTRIC #\4)
(define PK1_TOKEN_PSY #\5)
(define PK1_TOKEN_PUNCH #\6)
(define PK1_TOKEN_WHITE #\7)

(define PK1_MARKUP_FIRE 		"<fire/>")
(define PK1_MARKUP_WATER		"<water/>")
(define PK1_MARKUP_LEAF		 "<leaf/>")
(define PK1_MARKUP_ELECTRIC "<elect/>")
(define PK1_MARKUP_PSY 		 "<psy/>")
(define PK1_MARKUP_PUNCH 	 "<punch/>")
(define PK1_MARKUP_WHITE		 "<white/>")

(define PK1_SUBSTITUTE "--")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LAYER NAMES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define PK1_LY_BACKGROUND 				"Background")
(define PK1_LY_BORDERS 						"Borders")
(define PK1_LY_IMAGE 							"Image")
(define PK1_LY_DESCRIPTION 				"Description")
(define PK1_LY_EVOLUTION 					"Evolution")
(define PK1_LY_NAME 							"Name")
(define PK1_LY_HP 								"Hit Points")
(define PK1_LY_TYPE 								"Type")
(define PK1_LY_PK_PW_NAME 				"Pk Power Name")
(define PK1_LY_PK_PW_DESCRIPTION	"Pk Power Description")
(define PK1_LY_AT1_E							"Attack1 Energy")
(define PK1_LY_AT1_NAME 					"Attack1 Name")
(define PK1_LY_AT1_DESCRIPTION 		"Attack1 Description")
(define PK1_LY_AT1_DAMAGE 				"Attack1Damage")
(define PK1_LY_AT2_E 							"Attack2 Energy")
(define PK1_LY_AT2_NAME						"Attack2 Name")
(define PK1_LY_AT2_DESCRIPTION 		"Attack2 Description")
(define PK1_LY_AT2_DAMAGE 				"Attack2 Damage")
(define PK1_LY_WEAKNESS 					"Weakness")
(define PK1_LY_RESISTANCE					"Resistance")
(define PK1_LY_RETREAT						"Retreat Cost")
(define PK1_LY_WEAKNESS_E				"Weakness Type")
(define PK1_LY_RESISTANCE_E 				"Resistance Type")
(define PK1_LY_RETREAT_E			 			"Retreat Energy Cost")
(define PK1_LY_SEPARATOR 					"Separators")
(define PK1_LY_MINI_E		 					"Mini Energies")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GRAPHIC PARAMETERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define PK1_GRAD_IMAGE_BORDER "Golden")
(define PK1_GRAD_DESCRIPTION_BORDER "Golden")

(define PK1_FOG_PARAMETERS '(2.0 45)) ; turbulence and transparency

