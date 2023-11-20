##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Pim
extends WindowContent

@export var _setup_data: PimSetupResource
var field: Field
var menu_control := preload("menu_control.tscn").instantiate() as WindowContent
@onready var field_viewer := %FieldViewer as SubscreenViewer
@onready var programs := $Programs as ModeGroup
@onready var spawner_factory := $SpawnerFactory as NodeFactory


func _ready() -> void:
	_setup_field()
	window.ready.connect(_setup_side_menu)


func _setup_field() -> void:
	field = _setup_data.get_field_scene().instantiate()
	field_viewer.set_subscreen(field, _setup_data.field_zoom)
	field.action_queue.flushed.connect(_on_field_action)
	field.set_tool(_setup_data.get_initial_tool())


func _setup_side_menu() -> void:
	menu_control.setup(self)
	window.add_content(menu_control, true)
	menu_control.build(_setup_data.get_menu_setup_data())


func _on_field_action() -> void:
	window.set_to_top()


func reset() -> void:
	field.reset_state()


func get_program(program_name: String) -> PimProgram:
	return programs.get_mode(program_name)


func get_memo_output():
	if menu_control.memo_output_slot != null:
		if menu_control.memo_output_slot.memo != null:
			return menu_control.memo_output_slot.memo
	return null
