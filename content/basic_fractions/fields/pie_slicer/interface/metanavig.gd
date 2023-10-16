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
	var slice_vector_list = _get_slice_vector_list()
	return MemStateClass.new(slice_vector_list)


func _get_slice_vector_list() -> Array:
	var slice_vector_list = []
	for slice in _field.queries.get_nonphantom_slice_list():
		slice_vector_list.append(slice.vector)
	return slice_vector_list


#####################################################################
# State Loading
#####################################################################

func load_state(state: MemState) -> void:
	_field.actions.set_empty_pie()
	_add_slice_objects_by_vector_list(state.slice_vector_list)


func _add_slice_objects_by_vector_list(vector_list: Array,
			variant:=PieSlicerGlobals.SliceVariants.NORMAL) -> void:
	for vector in vector_list:
		_field.actions.create_slice(vector, variant)
	_field.update_pie_regions()
