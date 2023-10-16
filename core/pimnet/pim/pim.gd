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

export(Resource) var _setup_data: Resource
var field: Subscreen
var menu_control: Object = preload("menu_control.tscn").instance()
onready var field_viewer := $"%FieldViewer"
onready var programs := $Programs
onready var spawner_factory := $SpawnerFactory


func _ready() -> void:
	_setup_field()
	window.connect("ready", self, "_setup_side_menu")


func _setup_field() -> void:
	field = _setup_data.get_field_scene().instance()
	field_viewer.set_subscreen(field, _setup_data.field_zoom)
	field.action_queue.connect("flushed", self, "_on_field_action")
	field.set_tool(_setup_data.get_initial_tool())


func _setup_side_menu() -> void:
	menu_control.setup(self)
	window.add_content(menu_control, true)
	menu_control.build(_setup_data.get_menu_setup_data())


func _on_field_action() -> void:
	window.set_to_top()


func reset() -> void:
	field.reset_state()


func get_program(program_name: String) -> Mode:
	return programs.get_mode(program_name)


func get_memo_output():
	if menu_control.memo_output_slot != null:
		if menu_control.memo_output_slot.memo != null:
			return menu_control.memo_output_slot.memo
	return null
