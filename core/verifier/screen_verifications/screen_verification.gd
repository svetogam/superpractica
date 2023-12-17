#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name ScreenVerification
extends Verification

var animator: Node:
	set = _do_not_set,
	get = _get_animator
var effect_group: MathEffectGroup:
	set = _do_not_set,
	get = _get_effect_group


func _get_animator() -> Node:
	assert(screen_verifier.animator != null)
	return screen_verifier.animator


func _get_effect_group() -> MathEffectGroup:
	assert(screen_verifier.effect_group != null)
	return screen_verifier.effect_group


static func _do_not_set(_value: Variant) -> void:
	assert(false)
