# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PimProgram
extends Node

@export var pim: Pim
var field: Field:
	get:
		assert(pim.field != null)
		return pim.field


# Virtual
func run() -> void:
	pass
