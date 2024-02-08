#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Pim
extends WindowContent

@export var field_zoom := Vector2(1, 1)
var field: Field
@onready var field_viewer := %FieldViewer as SubscreenViewer
@onready var programs := $Programs as ModeGroup


func _ready() -> void:
	_setup_field()


# Virtual
func _get_field_scene() -> PackedScene:
	return null


func _setup_field() -> void:
	field = _get_field_scene().instantiate()
	field_viewer.set_subscreen(field, field_zoom)
	field.action_queue.flushed.connect(_on_field_action)


func _on_field_action() -> void:
	window.set_to_top()


func reset() -> void:
	field.reset_state()


func get_program(program_name: String) -> PimProgram:
	return programs.get_mode(program_name)
