#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SuperscreenObject
extends InputObject

var animator: Animator2D:
	get = _get_animator
var superscreen: Superscreen:
	get = _get_superscreen
var _drag_only := false


func _init() -> void:
	add_to_group("superscreen_objects")


func _enter_tree() -> void:
	superscreen.input_sequencer.connect_input_object(self)


func _input(event: InputEvent) -> void:
	if _drag_only:
		if event is InputEventMouseMotion:
			position = event.position


func start_grab() -> void:
	if _drag_only:
		position = get_global_mouse_position()
	super()


func _end_drag() -> void:
	super()
	if _drag_only:
		queue_free()


func _get_superscreen() -> Superscreen:
	if superscreen == null:
		superscreen = get_tree().get_nodes_in_group("superscreens")[0]
		assert(superscreen != null)
	return superscreen


func _get_animator() -> Animator2D:
	if animator == null:
		animator = Animator2D.new()
		assert(animator != null)
		add_child(animator)
	return animator
