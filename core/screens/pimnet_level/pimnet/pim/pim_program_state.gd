# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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
var effects: ScreenEffectGroup:
	get:
		assert(program.effects != null)
		return program.effects
