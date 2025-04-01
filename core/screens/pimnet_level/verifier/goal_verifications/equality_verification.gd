# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name EqualityVerification
extends Verification

const PRE_CHECK_DELAY := 0.1
const POST_CHECK_DELAY := 0.8
var _number_signal: NumberSignal
var _inequality_signals: Array #[InfoSignal]
var _current_row_number: int = -1
var _current_index: int = -1


func _init(p_number_signal: NumberSignal) -> void:
	super()
	_number_signal = p_number_signal


func _start() -> void:
	assert(_number_signal != null)

	_current_row_number = _get_next_row_number()
	_check_next_row()


func _exit_tree() -> void:
	for inequality_signal in _inequality_signals:
		inequality_signal.free()
	_inequality_signals.clear()


func _check_next_row() -> void:
	var slot = verification_panel.right_slots[_current_row_number]
	ProcessMoveSignalToSlot.new(_number_signal, slot).run(pimnet, _on_move_completed)


func _on_move_completed() -> void:
	await Game.wait_for(PRE_CHECK_DELAY)

	var got_memo := IntegerMemo.new(_number_signal.number)
	var wanted_memo = verification_panel.left_slots[_current_row_number].memo
	var equal = got_memo.value == wanted_memo.value
	if equal:
		verification_panel.affirm_in_row(got_memo, _current_row_number)
		_number_signal.erase("out_merge")

		var check_slot = verification_panel.check_slots[_current_row_number]
		var overlay_position = check_slot.get_global_rect().get_center()
		var signal_position = pimnet.overlay_position_to_effect_layer(overlay_position)
		pimnet.info_signaler.affirm(signal_position + InfoSignaler.NEAR_OFFSET)
	else:
		if row_numbers.size() == 1:
			verification_panel.reject_in_row(got_memo, _current_row_number)
			_number_signal.erase("out_merge")

		var check_slot = verification_panel.check_slots[_current_row_number]
		var overlay_position = check_slot.get_global_rect().get_center()
		var signal_position = pimnet.overlay_position_to_effect_layer(overlay_position)
		var inequality_signal = pimnet.info_signaler.popup_inequality(signal_position)
		_inequality_signals.append(inequality_signal)

	await Game.wait_for(POST_CHECK_DELAY)

	if equal:
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
