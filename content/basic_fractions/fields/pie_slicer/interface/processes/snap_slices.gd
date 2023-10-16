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

const AFFIRMATION_POSITION := Vector2(150, 150)
var affirm: bool
var _setup_completed := false
var _effects: NavigEffectGroup


func setup(p_affirm: bool) -> void:
	_setup_completed = true
	affirm = p_affirm


func _ready() -> void:
	assert(_setup_completed)
	_effects = NavigEffectGroup.new(field.effect_layer)

	_move_slices_to_equal_spacing(3.0)
	_remove_guides()

	yield(Game.wait_for(1.0), Game.DONE)

	if affirm:
		_effects.affirm(AFFIRMATION_POSITION)

	complete()


func _move_slices_to_equal_spacing(duration: float) -> void:
	var slice_list = field.queries.get_nonphantom_slice_list()
	var number_slices = slice_list.size()
	var equal_angles = field.queries.get_equally_spaced_angles_list(number_slices)
	var slice_destination_pair_list =  field.queries.pair_slices_with_nearest_angles(equal_angles)

	for pair in slice_destination_pair_list:
		var slice = pair[0]
		var destination_angle = pair[1]
		field.run_process("move_slice_to", [slice, destination_angle, duration])


#This could be animated
func _remove_guides() -> void:
	field.actions.remove_slice_phantoms()


func _exit_tree() -> void:
	field.update_pie_regions()
