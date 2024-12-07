#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name InterfieldObject
extends Node2D

var object_data: FieldObjectData
var graphic: Node2D
var _pimnet: Pimnet:
	get:
		if _pimnet == null:
			_pimnet = CSLocator.with(self).find(Game.SERVICE_PIMNET)
			assert(_pimnet != null)
		return _pimnet


func _ready() -> void:
	position = get_global_mouse_position()


func setup(p_object_data: FieldObjectData) -> void:
	object_data = p_object_data
	graphic = object_data.new_sprite()
	add_child(graphic)


func _input(event: InputEvent) -> void:
	# Drag
	if event is InputEventMouseMotion:
		position = event.position
		_pimnet.process_interfield_drag(object_data)

	# Drop
	elif event.is_action_released("primary_mouse"):
		_pimnet.process_interfield_drop(object_data)
		# Workaround to avoid a bug that breaks the script in release builds.
		# See https://github.com/godotengine/godot/issues/73036
		call("free")
