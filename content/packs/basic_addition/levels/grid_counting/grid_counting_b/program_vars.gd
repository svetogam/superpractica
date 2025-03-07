# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingProgramVarsB
extends LevelProgramVars

@export var min_count: int = 0
@export var max_count: int = -1


func new_count() -> int:
	return _calc_min_max(min_count, max_count)
