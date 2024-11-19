#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldAction

var block: FieldObject


static func get_name() -> String:
	return "delete_block"


func setup(p_block: FieldObject) -> FieldAction:
	block = p_block
	return self


func is_valid() -> bool:
	if block == null:
		return false
	return true


func do() -> void:
	block.free()
