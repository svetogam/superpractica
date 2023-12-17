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

var _number: NumberEffect
var _digit_place: int


func _init(p_number: NumberEffect, p_digit_place: int) -> void:
	super()
	_number = p_number
	_digit_place = p_digit_place


func _ready() -> void:
	assert(_number != null)
	assert(screen_verifier.digit_reference != null)

	var digit_number := effect_group.new_number_from_digit_of_original(
			screen_verifier.digit_reference, _digit_place)
	(ScreenVerifier.VerifNumbersAreEqual.new(digit_number, _number)
			.run(screen_verifier, verify, reject))
