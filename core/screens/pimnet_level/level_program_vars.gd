# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelProgramVars
extends Resource


func _calc_min_max(min_value: int, max_value: int) -> int:
	if min_value > max_value:
		return min_value
	else:
		return randi_range(min_value, max_value)
