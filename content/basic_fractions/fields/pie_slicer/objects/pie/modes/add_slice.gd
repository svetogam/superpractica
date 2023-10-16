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


func _on_hover(point: Vector2, _initial: bool, _grabbed_object: Node2D) -> void:
	var relative_point = point - object.global_position
	var prefig_vector = field.queries.make_slice_vector_by_point(relative_point)
	object.slice_prefig.set_vector(prefig_vector)
	object.slice_prefig.show()


func _on_unhover() -> void:
	object.slice_prefig.hide()


func _on_press(point: Vector2) -> void:
	var relative_point = point - object.global_position
	field.push_action("add_slice", [relative_point])
	object.stop_active_input()
