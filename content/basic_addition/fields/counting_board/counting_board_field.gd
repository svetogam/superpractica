##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Field


func get_globals() -> GDScript:
	return CountingBoardGlobals


func _on_update(_update_type: int) -> void:
	pass


func reset_state() -> void:
	push_action("set_empty")


func on_internal_drop(object: SubscreenObject, point: Vector2) -> void:
	var square = queries.get_number_square_at_point(point)
	if square != null and not square.has_counter():
		push_action("move_counter", [object, square])
	elif square == null:
		push_action("delete_counter", [object])


func on_incoming_drop(_object: InterfieldObject, point: Vector2, _source: Field) -> void:
	var square = queries.get_number_square_at_point(point)
	if square != null and not square.has_counter():
		push_action("create_counter", [square])


func on_outgoing_drop(object: SubscreenObject) -> void:
	push_action("delete_counter", [object])
