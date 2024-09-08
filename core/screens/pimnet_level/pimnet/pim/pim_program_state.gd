#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimProgramState
extends State

var program: PimProgram:
	get:
		assert(_target != null)
		return _target
var pim: Pim:
	get:
		assert(program.pim != null)
		return program.pim
var field: Field:
	get:
		assert(pim.field != null)
		return pim.field
var effects: NavigEffectGroup:
	get:
		assert(program.effects != null)
		return program.effects
