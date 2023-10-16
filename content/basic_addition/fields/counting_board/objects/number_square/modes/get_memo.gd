##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldObjectMode


func _start() -> void:
	var counter = object.get_counter()
	if counter != null:
		counter.set_transparent(true)


func _end() -> void:
	var counter = object.get_counter()
	if counter != null:
		counter.set_transparent(false)


func _on_press(_field_point: Vector2) -> void:
	var memo = object.get_memo()
	field.request_drag_memo(memo)
	object.stop_active_input()
