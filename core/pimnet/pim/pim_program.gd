##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name PimProgram
extends Mode

var pim: Pim
var field: Field
var action_queue: FieldActionQueue
var effects: NavigEffectGroup


func _pre_start() -> void:
	pim = _target
	field = pim.field
	action_queue = field.action_queue
	effects = NavigEffectGroup.new(field.effect_layer)
