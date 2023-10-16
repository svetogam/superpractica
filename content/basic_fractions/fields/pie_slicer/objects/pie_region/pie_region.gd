##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldObject

var bounding_slices := []
var selected := false
var _pie: FieldObject
onready var _graphic: ProceduralGraphic = $"%Graphic"


func setup(slice_1: FieldObject, slice_2: FieldObject) -> void:
	_pie = field.pie
	bounding_slices = [slice_1, slice_2]

	var bounding_angles = [slice_1.get_angle(), slice_2.get_angle()]
	_graphic.set_properties({"radius": field.pie_radius,
							 "bounds": bounding_angles})


func has_point(point: Vector2) -> bool:
	var pie_has_point = _pie.has_point(point)
	var pie_point = _pie.convert_field_point_to_pie_point(point)
	var point_is_between_slices = field.queries.is_point_between_slices(
							pie_point, bounding_slices[0], bounding_slices[1])
	return pie_has_point and point_is_between_slices


func toggle_select() -> void:
	set_selected(not selected)


func set_selected(value: bool) -> void:
	selected = value
	_graphic.set_properties({"selected": value})
