##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Process

var _pim: Pim
var _number_effect: NumberEffect
var _start_square: NumberSquare


func setup(p_pim: Pim, p_number_effect: NumberEffect) -> void:
	_pim = p_pim
	_number_effect = p_number_effect


func _ready() -> void:
	_start_square = _pim.field.queries.get_number_square(_number_effect.number)
	_number_effect.animator.move_completed.connect(_on_move_completed)
	var dest = _pim.field_viewer.convert_internal_to_external_point(_start_square.position)
	_number_effect.animator.move_to_position(dest)


func _on_move_completed() -> void:
	await Game.wait_for(0.2)

	_pim.field.actions.toggle_highlight(_start_square)
	_number_effect.queue_free()

	complete()
