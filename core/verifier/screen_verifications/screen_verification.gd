##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name ScreenVerification
extends Verification

var animator: Node
var effect_group: MathEffectGroup


func _enter_tree() -> void:
	animator = pack.animator
	assert(animator != null)
	effect_group = pack.effect_group
	assert(effect_group != null)
