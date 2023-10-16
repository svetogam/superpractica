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

var _warninger: Reference


func _start() -> void:
	_warninger = Warninger.new(field.effect_layer)
	field.connect("updated", self, "_update")


func _update() -> void:
	var warning_positions = _give_warnings()
	_warninger.set_at(warning_positions)
	if not warning_positions.empty():
		emit_signal("warned")


#Virtual
#Return a list of positions that warnings will go
func _give_warnings() -> Array:
	return []


#Virtual
func is_valid() -> bool:
	return true


func _end() -> void:
	_warninger.clear()
	field.disconnect("updated", self, "_update")
