##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name PimProgramState
extends State

var program: Node
var pim: WindowContent
var field: Subscreen
var action_queue: Object
var effects: NavigEffectGroup


func _on_setup() -> void:
	_setup_shortcuts()


func _setup_shortcuts() -> void:
	program = _target
	assert(program != null)
	pim = program.pim
	assert(pim != null)
	field = pim.field
	assert(field != null)
	action_queue = field.action_queue
	assert(action_queue != null)
	effects = program.effects
	assert(effects != null)
