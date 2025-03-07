# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingProgramVarsG
extends LevelProgramVars

@export var min_addend_1: int = 0
@export var max_addend_1: int = -1
@export var min_addend_2: int = 0
@export var max_addend_2: int = -1


func new_addend_1() -> int:
	return _calc_min_max(min_addend_1, max_addend_1)


func new_addend_2() -> int:
	return _calc_min_max(min_addend_2, max_addend_2)
