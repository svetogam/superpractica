##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Warninger
extends Reference

var _effects: NavigEffectGroup
var _warnings := []


func _init(effect_layer: CanvasLayer) -> void:
	_effects = NavigEffectGroup.new(effect_layer)


func add_at(position: Vector2) -> void:
	if not _is_warning_at_position(position):
		var warning_effect = _effects.warn(position)
		_warnings.append(warning_effect)


func remove_at(position: Vector2) -> void:
	var warning = _get_warning_at_position(position)
	if warning != null:
		_remove(warning)


func _remove(warning: ScreenEffect) -> void:
	warning.queue_free()
	_warnings.erase(warning)


func set_at(positions: Array) -> void:
	_add_new_warnings(positions)
	_remove_old_warnings(positions)


func _add_new_warnings(positions: Array) -> void:
	for position in positions:
		if not _is_warning_at_position(position):
			add_at(position)


func _remove_old_warnings(positions: Array) -> void:
	var to_remove = []
	for warning in _warnings:
		var warning_position = _get_warning_position(warning)
		if not Utils.is_vector_represented(warning_position, positions):
			to_remove.append(warning)
	for warning in to_remove:
		_remove(warning)


func clear() -> void:
	for warning in _warnings:
		warning.queue_free()
	_warnings.clear()


func _get_warning_at_position(position: Vector2) -> ScreenEffect:
	for warning in _warnings:
		var warning_position = _get_warning_position(warning)
		if position.is_equal_approx(warning_position):
			return warning
	return null


func _is_warning_at_position(position: Vector2) -> bool:
	return _get_warning_at_position(position) != null


func _get_warning_position(warning: ScreenEffect) -> Vector2:
	return warning.position - _effects.NEAR_OFFSET
