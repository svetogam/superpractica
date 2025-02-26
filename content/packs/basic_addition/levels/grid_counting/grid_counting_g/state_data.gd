#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends StateData

const DATA := {
	"initial": "Play",
	"transitions": {
		"Play": {
			"done": State.NULL_STATE,
		},
	}
}


func _get_data() -> Dictionary:
	return DATA
