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


func _press(_point: Vector2) -> void:
	field.request_drag_object(object)


func _drop(point: Vector2) -> void:
	field.push_action(field.move_unit.bind(object, point))
	get_viewport().set_input_as_handled()
