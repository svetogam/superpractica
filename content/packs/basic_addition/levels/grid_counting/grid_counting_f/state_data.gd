# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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
