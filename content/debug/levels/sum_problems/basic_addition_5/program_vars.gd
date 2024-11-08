#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SumProblemsProgramVarsB
extends LevelProgramVars

@export var min_start_number: int = 0
@export var max_start_number: int = -1
@export var min_addend: int = 0
@export var max_addend: int = -1


func new_start_number() -> int:
	return _calc_min_max(min_start_number, max_start_number)


func new_addend() -> int:
	return _calc_min_max(min_addend, max_addend)
