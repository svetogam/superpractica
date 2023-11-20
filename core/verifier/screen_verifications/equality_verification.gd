##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends ScreenVerification

const PRE_CHECK_DELAY := 0.1
var _numbers: Array


func setup(number_1: NumberEffect, number_2: NumberEffect) -> void:
	_numbers = [number_1, number_2]


func _ready() -> void:
	assert(not _numbers.is_empty())

	_numbers[0] = effect_group.duplicate_effect(_numbers[0])
	_numbers[1] = effect_group.duplicate_effect(_numbers[1])
	_numbers.sort_custom(Callable(Utils, "sort_node2d_by_x_position"))

	animator.animate_equality_setup(_numbers[0], _numbers[1], self, "_on_move_completed")


func _on_move_completed() -> void:
	await Game.wait_for(PRE_CHECK_DELAY)

	var equal = _is_equal()
	animator.animate_equality_check(equal, self, "_after_check")


func _after_check() -> void:
	effect_group.clear()

	var equal = _is_equal()
	verify_or_else_reject(equal)


func _is_equal() -> bool:
	return _numbers[0].is_equal_to(_numbers[1])
