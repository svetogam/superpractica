# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Verification

const PRE_CHECK_DELAY := 0.1
var _number_effect: NumberEffect
var _current_row_number: int = -1
var _current_index: int = -1


func _init(p_number_effect: NumberEffect) -> void:
	super()
	_number_effect = p_number_effect


func _ready() -> void:
	assert(_number_effect != null)

	_current_row_number = _get_next_row_number()
	_check_next_row()


func _exit_tree() -> void:
	goal_verifier.goal_effects.clear()


func _check_next_row() -> void:
	goal_verifier.animate_equality_setup(
			_number_effect, _current_row_number, _on_move_completed)


func _on_move_completed() -> void:
	await Game.wait_for(PRE_CHECK_DELAY)

	var equal := _is_equal()
	if equal:
		verification_panel.affirm_in_row(
				IntegerMemo.new(_number_effect.number), _current_row_number)
	# Reject only if checking in exactly one row
	elif row_numbers.size() == 1:
		verification_panel.reject_in_row(
				IntegerMemo.new(_number_effect.number), _current_row_number)

	goal_verifier.animate_equality_check(equal, _current_row_number, _after_check)


func _after_check() -> void:
	if _is_equal():
		verify()
	else:
		_current_row_number = _get_next_row_number()
		if _current_row_number == -1:
			reject()
		else:
			_check_next_row()


func _is_equal() -> bool:
	var slot = verification_panel.left_slots[_current_row_number]
	var slot_value = slot.memo.get_value()
	return _number_effect.number == slot_value


func _get_next_row_number() -> int:
	_current_index += 1
	if _current_index < row_numbers.size():
		return row_numbers[_current_index]
	else:
		return -1
