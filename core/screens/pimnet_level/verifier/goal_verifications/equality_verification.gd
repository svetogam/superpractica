# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Verification

const PRE_CHECK_DELAY := 0.1
const POST_EQUALITY_CHECK_DELAY := 0.8
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

	var got_memo := IntegerMemo.new(_number_effect.number)
	var wanted_memo = verification_panel.left_slots[_current_row_number].memo
	var equal = got_memo.value == wanted_memo.value
	if equal:
		verification_panel.affirm_in_row(got_memo, _current_row_number)

		var check_slot = verification_panel.check_slots[_current_row_number]
		var overlay_position = check_slot.get_global_rect().get_center()
		var effect_position = pimnet.overlay_position_to_effect_layer(overlay_position)
		goal_verifier.goal_effects_b.affirm(
				effect_position + NavigEffectGroup.NEAR_OFFSET, POST_EQUALITY_CHECK_DELAY)
	else:
		var last_to_check := row_numbers.size() == 1
		verification_panel.reject_in_row(got_memo, _current_row_number, last_to_check)

		var check_slot = verification_panel.check_slots[_current_row_number]
		var overlay_position = check_slot.get_global_rect().get_center()
		var effect_position = pimnet.overlay_position_to_effect_layer(overlay_position)
		goal_verifier.popup_inequality(effect_position)

	await Game.wait_for(POST_EQUALITY_CHECK_DELAY)

	if equal:
		_number_effect.free()
		verify()
	else:
		_current_row_number = _get_next_row_number()
		if _current_row_number == -1:
			reject()
		else:
			_check_next_row()


func _get_next_row_number() -> int:
	_current_index += 1
	if _current_index < row_numbers.size():
		return row_numbers[_current_index]
	else:
		return -1
