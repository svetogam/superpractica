#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name ScreenVerifier
extends Node

const VerifNumbersAreEqual := preload("equality_verification.gd")
const VerifEvalutatesToNumber := preload("evaluation_verification.gd")
const VerifNumberIsEqualToDigit := preload("digit_equality_verification.gd")

const START_DELAY := 0.8
var verifier: Node
var effect_group: MathEffectGroup
var digit_reference: NumberEffect
@onready var animator := $ScreenAnimator as Node


func _enter_tree() -> void:
	verifier = get_parent()
	assert(verifier != null)
	effect_group = MathEffectGroup.new(verifier.effect_layer)
	assert(effect_group != null)


func set_digit_reference(number: NumberEffect, callback := Callable()) -> void:
	digit_reference = number
	animator.animate_number_to_digit_reference(number, callback)


func clear_digit_reference() -> void:
	if digit_reference != null:
		digit_reference.queue_free()
		digit_reference = null
