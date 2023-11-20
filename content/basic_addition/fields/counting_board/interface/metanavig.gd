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


func build() -> MemState:
	var data_list = _get_number_squares_data_list()
	return MemStateClass.new(data_list)


func _get_number_squares_data_list() -> Array:
	var data_list = []
	for square in _field.queries.get_number_square_list():
		var square_data = _get_square_data(square)
		data_list.append(square_data)
	return data_list


func _get_square_data(square: NumberSquare) -> Dictionary:
	return {"number": square.number, "circled": square.circled,
			"highlighted": square.highlighted, "has_counter": square.has_counter()}


#####################################################################
# State Loading
#####################################################################

func load_state(state: MemState) -> void:
	_field.actions.set_empty()
	_set_squares_by_data_list(state.number_squares_data_list)


func _set_squares_by_data_list(number_squares_data_list: Array) -> void:
	for square_data in number_squares_data_list:
		var number_square = _field.queries.get_number_square(square_data.number)
		if square_data.circled:
			_field.actions.toggle_circle(number_square)
		if square_data.highlighted:
			_field.actions.toggle_highlight(number_square)
		if square_data.has_counter:
			_field.actions.create_counter(number_square)
