#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GameProgressResource
extends Resource

var _completed_levels: Array = []


func save_level_completion(level_id: String) -> void:
	_completed_levels.append(level_id)


func is_level_completed(level_id: String) -> bool:
	return _completed_levels.has(level_id)


func clear() -> void:
	_completed_levels.clear()
