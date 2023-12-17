#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Node2D

signal handle_pressed(direction)

@onready var _handles_map := {
	"DL": %HandleDL as FieldObject,
	"L": %HandleL as FieldObject,
	"UL": %HandleUL as FieldObject,
	"U": %HandleU as FieldObject,
	"UR": %HandleUR as FieldObject,
	"R": %HandleR as FieldObject,
	"DR": %HandleDR as FieldObject,
	"D": %HandleD as FieldObject
}


func setup(bubble: FieldObject) -> void:
	for direction in _handles_map.keys():
		_handles_map[direction].setup(bubble, direction)
	if bubble.is_mode_active("resize"):
		show_handles()


func show_handles() -> void:
	update_handle_positions()
	for handle in _handles_map.values():
		handle.show()


func hide_handles() -> void:
	for handle in _handles_map.values():
		handle.hide()


func update_handle_positions() -> void:
	for handle in _handles_map.values():
		handle.update_position()


func get_handles() -> Array:
	return _handles_map.values()
