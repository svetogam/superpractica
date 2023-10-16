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

const SLICE_SELECTION_RADIUS := 10
export(PieSlicerGlobals.SliceVariants) var variant
var vector: Vector2
onready var _graphic: ProceduralGraphic = $"%Graphic"


func _ready() -> void:
	_graphic.set_properties({"variant": variant})


func has_point(point: Vector2) -> bool:
	var pie_point = field.pie.convert_field_point_to_pie_point(point)
	var nearest_slice = field.queries.get_slice_nearest_to_point(pie_point, SLICE_SELECTION_RADIUS)
	return nearest_slice == self


func set_vector(p_vector: Vector2) -> void:
	vector = p_vector
	_graphic.set_properties({"vector": vector})


func set_variant(p_variant: int) -> void:
	variant = p_variant
	_graphic.set_properties({"variant": variant})


func get_angle() -> float:
	return field.queries.get_angle_of_point(vector)


func is_phantom() -> bool:
	if variant == PieSlicerGlobals.SliceVariants.NORMAL\
			or variant == PieSlicerGlobals.SliceVariants.WARNING:
		return false
	elif variant == PieSlicerGlobals.SliceVariants.GUIDE\
			or variant == PieSlicerGlobals.SliceVariants.PREFIG:
		return true
	else:
		assert(false)
		return false
