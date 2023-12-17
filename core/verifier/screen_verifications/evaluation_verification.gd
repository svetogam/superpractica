#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends ScreenVerification

const EVALUATION_DELAY := 0.2
const PRE_CHECK_DELAY := 0.8
var _checked: NumberEffect
var _operator: ScreenEffect
var _inputs: Array


func _init(p_checked: NumberEffect, p_operator: ScreenEffect, p_inputs: Array) -> void:
	super()
	_checked = p_checked
	_operator = p_operator
	_inputs = p_inputs


func _ready() -> void:
	assert(_checked != null)
	assert(_operator != null)
	assert(not _inputs.is_empty())

	_checked = effect_group.duplicate_effect(_checked)
	_operator = effect_group.duplicate_effect(_operator)
	_inputs[0] = effect_group.duplicate_effect(_inputs[0])
	_inputs[1] = effect_group.duplicate_effect(_inputs[1])
	_inputs.sort_custom(Utils.sort_node2d_by_x_position)

	animator.animate_evaluation_setup(_inputs[0], _inputs[1], _operator)
	animator.animate_number_to_equality(_checked, "right", _on_first_move_completed)


func _on_first_move_completed() -> void:
	await Game.wait_for(EVALUATION_DELAY)

	var result := _compute_result()
	animator.popup_evaluation_result(result)

	await Game.wait_for(PRE_CHECK_DELAY)

	var equal := _is_equal()
	animator.animate_equality_check(equal, _after_check)


func _after_check() -> void:
	effect_group.clear()

	if _is_equal():
		verify()
	else:
		reject()


func _compute_result() -> int:
	return _inputs[0].number + _inputs[1].number


func _is_equal() -> bool:
	return _compute_result() == _checked.number
