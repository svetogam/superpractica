#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimProgram
extends Mode

var pim: Pim:
	set = _do_not_set,
	get = _get_pim
var field: Field:
	set = _do_not_set,
	get = _get_field
var effects: NavigEffectGroup:
	get = _get_effects


func _get_pim() -> Pim:
	assert(_target != null)
	return _target


func _get_field() -> Field:
	assert(pim.field != null)
	return pim.field


func _get_effects() -> NavigEffectGroup:
	if effects == null:
		effects = NavigEffectGroup.new(field.effect_layer)
		assert(effects != null)
	return effects


static func _do_not_set(_value: Variant) -> void:
	assert(false)
