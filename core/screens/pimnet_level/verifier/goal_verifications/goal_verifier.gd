# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GoalVerifier
extends Node

const POST_EQUALITY_CHECK_DELAY := 0.8
const EqualityVerification := preload("equality_verification.gd")

@export var verifier: Verifier
var info_signaler := InfoSignaler.new()
var pimnet: Pimnet:
	get:
		assert(verifier.pimnet != null)
		return verifier.pimnet
var verification_panel: PanelContainer:
	get:
		assert(pimnet.overlay.verification_panel != null)
		return pimnet.overlay.verification_panel


func _enter_tree() -> void:
	verifier.effect_layer.add_child(info_signaler)


func verify_equality(number_signal: InfoSignal, row_numbers: Array,
		verified_callback: Callable, rejected_callback := Callable()
) -> Verification:
	return (EqualityVerification.new(number_signal)
			.run(self, row_numbers, verified_callback, rejected_callback))


func animate_equality_setup(number_signal: InfoSignal, row_number: int,
		callback := Callable()
) -> void:
	var slot = verification_panel.right_slots[row_number]
	var destination = slot.get_global_rect().get_center()
	ProcessMoveSignalToOverlay.new(number_signal, destination).run(pimnet, callback)


func animate_equality_check(equal: bool, row_number: int, callback := Callable()
) -> void:
	popup_comparator(equal, row_number)

	await Game.wait_for(POST_EQUALITY_CHECK_DELAY)

	if not callback.is_null():
		callback.call()


func popup_comparator(equal: bool, row_number: int) -> InfoSignal:
	var check_slot = verification_panel.check_slots[row_number]
	var overlay_position = check_slot.get_global_rect().get_center()
	var signal_position = pimnet.overlay_position_to_effect_layer(overlay_position)
	if equal:
		return info_signaler.popup_equality(signal_position)
	else:
		return info_signaler.popup_inequality(signal_position)
