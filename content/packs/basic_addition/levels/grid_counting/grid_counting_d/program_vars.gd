# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingProgramVarsD
extends LevelProgramVars

@export var min_number: int = 0
@export var max_number: int = -1


func new_number() -> int:
	return _calc_min_max(min_number, max_number)
