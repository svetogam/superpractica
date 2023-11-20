##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SoftLimiterProgram
extends FieldProgram

signal warned

var _warninger: Warninger


func _start() -> void:
	_warninger = Warninger.new(field.effect_layer)
	field.updated.connect(_update)


func _update() -> void:
	var warning_positions = _give_warnings()
	_warninger.set_at(warning_positions)
	if not warning_positions.is_empty():
		warned.emit()


#Virtual
#Return a list of positions that warnings will go
func _give_warnings() -> Array:
	return []


#Virtual
func is_valid() -> bool:
	return true


func _end() -> void:
	_warninger.clear()
	field.updated.disconnect(_update)
