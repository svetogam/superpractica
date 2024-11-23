#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObject

signal number_changed(old_number, new_number) # -1 for no number

var cell: GridCell = null


static func _get_object_type() -> int:
	return GridCounting.Objects.UNIT


func _enter_tree() -> void:
	CSConnector.with(self).register("unit")


func _exit_tree() -> void:
	var old_number: int = -1
	if cell != null:
		old_number = get_number()
	number_changed.emit(old_number, -1)


func put_on_cell(p_cell: GridCell) -> void:
	var old_number: int = -1
	if cell != null:
		old_number = get_number()

	cell = p_cell
	position = cell.position
	number_changed.emit(old_number, cell.number)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant


func get_number() -> int:
	assert(cell != null)
	return cell.number
