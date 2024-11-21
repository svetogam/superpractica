#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionDeleteBlock
extends FieldAction

var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.DELETE_BLOCK


func _init(p_field: Field, p_block: FieldObject) -> void:
	super(p_field)
	block = p_block


func is_valid() -> bool:
	if block == null:
		return false
	return true


func do() -> void:
	block.free()
