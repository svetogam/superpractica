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
