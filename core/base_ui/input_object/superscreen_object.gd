##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SuperscreenObject
extends InputObject

var animator = Animator2D.new()
var superscreen: Control
var _drag_only := false


func _init() -> void:
	add_to_group("superscreen_objects")


func _enter_tree() -> void:
	add_child(animator)

	if superscreen == null:
		_find_superscreen()


func _find_superscreen() -> void:
	superscreen = get_tree().get_nodes_in_group("superscreens")[0]
	assert(superscreen != null)

	superscreen.input_sequencer.connect_input_object(self)


func start_grab() -> void:
	if _drag_only:
		position = get_global_mouse_position()
	.start_grab()


#Virtual default
func _on_drag(point: Vector2, _change: Vector2) -> void:
	if _drag_only:
		position = point


func _end_drag() -> void:
	._end_drag()
	if _drag_only:
		queue_free()
