# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GoalVerifier
extends Node

const POST_EQUALITY_CHECK_DELAY := 0.8
const EqualityVerification := preload("equality_verification.gd")
const EqualityEffect = preload(
		"res://core/systems/effect_system/effects/navig/effects/equality_effect.tscn")

@export var verifier: Verifier
var goal_effects: MathEffectGroup
var pimnet: Pimnet:
	get:
		assert(verifier.pimnet != null)
		return verifier.pimnet
var verification_panel: PanelContainer:
	get:
		assert(pimnet.overlay.verification_panel != null)
		return pimnet.overlay.verification_panel


func _enter_tree() -> void:
	goal_effects = MathEffectGroup.new(verifier.effect_layer)


func verify_equality(number_effect: NumberEffect, row_numbers: Array,
		verified_callback: Callable, rejected_callback := Callable()
) -> Verification:
	return (EqualityVerification.new(number_effect)
			.run(self, row_numbers, verified_callback, rejected_callback))


func animate_equality_setup(number_effect: NumberEffect, row_number: int,
		callback := Callable()
) -> void:
	var slot = verification_panel.right_slots[row_number]
	var overlay_destination = slot.get_global_rect().get_center()
	var destination = pimnet.overlay_position_to_effect_layer(overlay_destination)
	number_effect.animator.move_to_position(destination)

	if not callback.is_null():
		number_effect.animator.move_completed.connect(callback, CONNECT_ONE_SHOT)


func animate_equality_check(equal: bool, row_number: int, callback := Callable()
) -> void:
	_popup_comparator(equal, row_number)

	await Game.wait_for(POST_EQUALITY_CHECK_DELAY)

	if not callback.is_null():
		callback.call()


func _popup_comparator(equal: bool, row_number: int) -> void:
	var check_slot = verification_panel.check_slots[row_number]
	var overlay_position = check_slot.get_global_rect().get_center()
	var effect_position = pimnet.overlay_position_to_effect_layer(overlay_position)

	if equal:
		_popup_equality(effect_position)
	else:
		_popup_inequality(effect_position)


func _popup_equality(position: Vector2) -> void:
	var effect := goal_effects.create_effect(EqualityEffect, position)
	effect.set_type("equality")
	effect.animate("rise")


func _popup_inequality(position: Vector2) -> void:
	var effect := goal_effects.create_effect(EqualityEffect, position)
	effect.set_type("inequality")
	effect.animate("shake")
