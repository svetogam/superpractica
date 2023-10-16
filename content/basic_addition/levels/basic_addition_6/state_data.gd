##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends StateData

const DATA := {
	"initial": "SelectStart",
	"transitions": {
		"SelectStart": {
			"done": "VerifyStart",
		},
		"VerifyStart": {
			"verified": "AddByCircles",
			"rejected": "SelectStart",
		},
		"AddByCircles": {
			"done": "VerifyAddition",
		},
		"VerifyAddition": {
			"verified": "DragResult",
			"rejected": "AddByCircles",
		},
		"DragResult": {
			"done": "VerifyResult",
		},
		"VerifyResult": {
			"verified": State.NULL_STATE,
			"rejected": "DragResult",
		},
	}
}


func _get_data() -> Dictionary:
	return DATA
