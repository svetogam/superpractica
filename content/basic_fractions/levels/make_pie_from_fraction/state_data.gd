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
	"initial": "Setup",
	"transitions": {
		"Setup": {
			"done": "CutSlices",
		},
		"CutSlices": {
			"done": "SnapSlices",
		},
		"SnapSlices": {
			"done": "SelectRegions",
		},
		"SelectRegions": {
			"done": "VerifySelection",
		},
		"VerifySelection": {
			"verified": State.NULL_STATE,
			"rejected": "SelectRegions",
		},
	}
}


func _get_data() -> Dictionary:
	return DATA
