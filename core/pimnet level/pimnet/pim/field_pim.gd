#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldPim
extends Pim

var field: Field


func _ready() -> void:
	for child in %FieldViewport.get_children():
		if child is Field:
			field = child
			break
	assert(field != null)

	field.updated.connect(focus_entered.emit)


func _on_focus() -> void:
	field._on_selected()


func reset() -> void:
	field.reset_state()


func field_has_point(external_point: Vector2) -> bool:
	return %SubViewportContainer.get_global_rect().has_point(external_point)


func convert_external_to_internal_point(external_point: Vector2) -> Vector2:
	var local_point := _convert_external_to_local_point(external_point)
	return _convert_local_to_internal_point(local_point)


func convert_internal_to_external_point(internal_point: Vector2) -> Vector2:
	var local_point := _convert_internal_to_local_point(internal_point)
	return _convert_local_to_external_point(local_point)


func _convert_external_to_local_point(external_point: Vector2) -> Vector2:
	return external_point - %SubViewportContainer.global_position


func _convert_local_to_external_point(local_point: Vector2) -> Vector2:
	return local_point + %SubViewportContainer.global_position


func _convert_local_to_internal_point(local_point: Vector2) -> Vector2:
	#return local_point / camera.zoom + camera.offset
	return local_point


func _convert_internal_to_local_point(internal_point: Vector2) -> Vector2:
	#return (internal_point - camera.offset) * camera.zoom
	return internal_point


func convert_external_to_internal_vector(external_vector: Vector2) -> Vector2:
	#return external_vector / camera.zoom
	return external_vector


func convert_internal_to_external_vector(internal_vector: Vector2) -> Vector2:
	#return internal_vector * camera.zoom
	return internal_vector
