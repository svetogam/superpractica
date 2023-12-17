#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PanelContainer

var _effects: NavigEffectGroup
var _locator := ContextualLocator.new(self)
@onready var enabler := $ButtonEnabler as Node
@onready var _container := %ButtonContainer as VBoxContainer


func _enter_tree() -> void:
	_locator.auto_callback("effect_layer", _on_effect_layer_found)


func _on_effect_layer_found(effect_layer: CanvasLayer) -> void:
	_effects = NavigEffectGroup.new(effect_layer)


func add_button(button_id: String, text: String) -> Button:
	var button := Button.new()
	button.name = button_id
	button.text = text
	button.custom_minimum_size.x = 50
	button.custom_minimum_size.y = 50

	_container.add_child(button)
	enabler.add_button(button_id, button)

	return button


func _get_buttons() -> Array:
	return _container.get_children()


func _get_button(button_id: String) -> Button:
	for button in _get_buttons():
		if button.name == button_id:
			return button
	return null


func connect_event(button_id: String, callable: Callable) -> void:
	var button := _get_button(button_id)
	button.pressed.connect(callable)


func disconnect_event(button_id: String, callable: Callable) -> void:
	var button := _get_button(button_id)
	button.pressed.disconnect(callable)


func point_at_button(button_id: String) -> void:
	assert(_effects != null)
	var button := _get_button(button_id)
	var point_offset := Vector2(button.size.x * 0.9, button.size.y * 0.5)
	var pointer_point := button.global_position + point_offset
	_effects.point_left(pointer_point)


func clear_effects() -> void:
	assert(_effects != null)
	_effects.clear()
