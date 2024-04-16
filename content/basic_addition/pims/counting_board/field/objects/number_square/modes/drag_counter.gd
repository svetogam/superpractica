#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObjectMode


func _take_drop(_dropped_object: FieldObject, _point: Vector2) -> void:
	if not object.has_counter():
		field.push_action(field.create_counter.bind(object))
	get_viewport().set_input_as_handled()
