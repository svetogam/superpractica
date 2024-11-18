#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldAction
extends RefCounted

var field: Field


func _init(p_field: Field) -> void:
	field = p_field


# Virtual
func is_valid() -> bool:
	return true


# Virtual
func do() -> void:
	assert(is_valid())

	pass


func push() -> void:
	assert(is_valid())

	field.action_queue.push(self)
