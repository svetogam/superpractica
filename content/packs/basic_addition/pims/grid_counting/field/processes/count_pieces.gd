#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingProcessCountPieces
extends CountInField

var _zero_position: Vector2


func _init(p_objects_to_count: Array, p_zero_position: Vector2) -> void:
	super(p_objects_to_count)
	_zero_position = p_zero_position


func _count(object: FieldObject) -> NumberEffect:
	return field.count_piece(object)


func _count_zero() -> NumberEffect:
	return field.math_effects.give_number(0, _zero_position)
