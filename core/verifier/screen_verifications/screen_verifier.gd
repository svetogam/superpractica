##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name ScreenVerifier
extends VerificationPack

const START_DELAY := 0.8
var effect_group: MathEffectGroup
var digit_reference: NumberEffect
@onready var animator := $ScreenAnimator as Node


func _enter_tree() -> void:
	super()
	effect_group = MathEffectGroup.new(verifier.effect_layer)
	assert(effect_group != null)


func set_digit_reference(number: NumberEffect,
			callback_object: Object =null, callback_method:="") -> void:
	digit_reference = number
	animator.animate_number_to_digit_reference(number, callback_object, callback_method)


func clear_digit_reference() -> void:
	if digit_reference != null:
		digit_reference.queue_free()
		digit_reference = null
