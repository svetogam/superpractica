#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingDynamicModel
extends RefCounted

var cells: Dictionary #[int, [String, FieldObject]]
var rows: Dictionary #[int, [String, FieldObject]]


func _init() -> void:
	for cell_number in range(1, 101):
		cells[cell_number] = {
			"grid_cell": null,
			"unit": null,
			"two_block": null,
		}
	for row_number in range(1, 11):
		rows[row_number] = {
			"ten_block": null
		}


func set_grid_cell(cell_number: int, grid_cell: GridCell) -> void:
	cells[cell_number].grid_cell = grid_cell


func set_unit(cell_number: int, unit: FieldObject) -> void:
	cells[cell_number].unit = unit


func unset_unit(cell_number: int, unit: FieldObject) -> void:
	cells[cell_number].unit = null


func set_two_block(cell_number: int, two_block: FieldObject) -> void:
	cells[cell_number].two_block = two_block


func unset_two_block(cell_number: int, two_block: FieldObject) -> void:
	cells[cell_number].two_block = null


func set_ten_block(row_number: int, ten_block: FieldObject) -> void:
	rows[row_number].ten_block = ten_block


func unset_ten_block(row_number: int, ten_block: FieldObject) -> void:
	rows[row_number].ten_block = null


func get_grid_cell(cell_number: int) -> GridCell:
	return cells[cell_number].grid_cell


func get_grid_cells() -> Array:
	var grid_cells: Array = []
	for cell_number in cells:
		var grid_cell = get_grid_cell(cell_number)
		if grid_cell != null:
			grid_cells.append(grid_cell)
	return grid_cells


func get_unit(cell_number: int) -> FieldObject:
	return cells[cell_number].unit


func get_units() -> Array:
	var units: Array = []
	for cell_number in cells:
		var unit = get_unit(cell_number)
		if unit != null:
			units.append(unit)
	return units


func get_two_block(cell_number: int) -> FieldObject:
	return cells[cell_number].two_block


func get_two_blocks() -> Array:
	var two_blocks: Array = []
	for cell_number in cells:
		var two_block = get_two_block(cell_number)
		if two_block != null:
			two_blocks.append(two_block)
	return two_blocks


func get_ten_block(row_number: int) -> FieldObject:
	return rows[row_number].ten_block


func get_ten_blocks() -> Array:
	var ten_blocks: Array = []
	for row_number in rows:
		var ten_block = get_ten_block(row_number)
		if ten_block != null:
			ten_blocks.append(ten_block)
	return ten_blocks
