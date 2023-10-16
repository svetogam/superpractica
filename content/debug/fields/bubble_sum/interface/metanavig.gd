##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldMetanavigComponent

#####################################################################
# State Building
#####################################################################

const MemStateClass := preload("mem_state.gd")


func build() -> Object:
	var unit_data = _get_unit_data_list()
	var bubble_data = _get_bubble_data_list()
	return MemStateClass.new(unit_data, bubble_data)


func _get_unit_data_list() -> Array:
	var unit_data_list = []
	for unit in _field.queries.get_unit_list():
		var unit_data = _get_unit_data(unit)
		unit_data_list.append(unit_data)
	return unit_data_list


func _get_bubble_data_list() -> Array:
	var bubble_data_list = []
	for bubble in _field.queries.get_bubble_list():
		var bubble_data = _get_bubble_data(bubble)
		bubble_data_list.append(bubble_data)
	return bubble_data_list


func _get_unit_data(unit: FieldObject) -> Dictionary:
	return {"position": unit.position}


func _get_bubble_data(bubble: FieldObject) -> Dictionary:
	return {"position": bubble.position, "radius": bubble.radius}


#####################################################################
# State Loading
#####################################################################

func load_state(state: MemState) -> void:
	_field.actions.set_empty()
	_create_units_by_data_list(state.unit_data_list)
	_create_bubbles_by_data_list(state.bubble_data_list)


func _create_units_by_data_list(unit_data_list: Array) -> void:
	for unit_data in unit_data_list:
		_create_unit_by_data(unit_data)


func _create_unit_by_data(unit_data: Dictionary) -> FieldObject:
	var point = unit_data.position
	return _field.actions.create_unit(point)


func _create_bubbles_by_data_list(bubble_data_list: Array) -> void:
	for bubble_data in bubble_data_list:
		_create_bubble_by_data(bubble_data)


func _create_bubble_by_data(bubble_data: Dictionary) -> FieldObject:
	var point = bubble_data.position
	var radius = bubble_data.radius
	return _field.actions.create_bubble(point, radius)
