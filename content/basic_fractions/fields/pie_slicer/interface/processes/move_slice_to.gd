##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldProcess

var slice: FieldObject
var dest_angle: float
var duration: float


func setup(p_slice: FieldObject, p_dest_angle: float, p_duration: float) -> void:
	slice = p_slice
	dest_angle = p_dest_angle
	duration = p_duration * Game.get_animation_time_modifier()


func _ready() -> void:
	assert(slice != null)

	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(self, "_update_slice", 0.0, 1.0, duration)
	tween.tween_callback(self, "complete")


func _update_slice(weight: float) -> void:
	var current_angle = lerp_angle(slice.get_angle(), dest_angle, weight)
	var current_vector = field.queries.make_slice_vector_by_angle(current_angle)
	slice.set_vector(current_vector)
