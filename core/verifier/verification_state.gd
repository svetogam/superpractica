#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name VerificationState
extends State

var verification: Verification:
	set = _do_not_set,
	get = _get_verification
var verifier: Node:
	set = _do_not_set,
	get = _get_verifier
var screen_verifier: ScreenVerifier:
	set = _do_not_set,
	get = _get_screen_verifier


func verify() -> void:
	verification.verify()


func reject() -> void:
	verification.reject()


func _get_verification() -> Verification:
	assert(_target != null)
	return _target


func _get_verifier() -> Node:
	assert(_target.verifier != null)
	return _target.verifier


func _get_screen_verifier() -> ScreenVerifier:
	assert(_target.screen_verifier != null)
	return _target.screen_verifier


static func _do_not_set(_value: Variant) -> void:
	assert(false)
