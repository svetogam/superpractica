# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PimProgram
extends Mode

var pim: Pim:
	get:
		assert(_target != null)
		return _target
var field: Field:
	get:
		assert(pim.field != null)
		return pim.field
var effects: NavigEffectGroup:
	get:
		if effects == null:
			effects = NavigEffectGroup.new(field.effect_layer)
			assert(effects != null)
		return effects
