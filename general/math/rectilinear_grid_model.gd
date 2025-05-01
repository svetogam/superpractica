# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name RectilinearGridModel
extends RefCounted

## Model of a numbered grid of rectangles.
##
## Numbers increase first along a row across columns, and then across rows.
## Cell numbers start with 1.
## Row and column numbers start with 1.

var rows: int
var columns: int
var cells: int:
	get:
		return rows * columns


func _init(p_rows: int, p_columns: int) -> void:
	assert(p_rows >= 1)
	assert(p_columns >= 1)

	rows = p_rows
	columns = p_columns


func get_first_cell_in_row(row: int) -> int:
	assert(row > 0 and row <= rows)

	return get_last_cell_in_row(row) - (columns - 1)


func get_last_cell_in_row(row: int) -> int:
	assert(row > 0 and row <= rows)

	return row * columns


#func get_first_cell_in_column(column: int) -> int:
	#return 0


#func get_last_cell_in_column(column: int) -> int:
	#return 0


func get_cells_in_row(row: int) -> Array:
	assert(row > 0 and row <= rows)

	var first_cell := get_first_cell_in_row(row)
	var last_cell := get_last_cell_in_row(row)
	return range(first_cell, last_cell + 1)


#func get_cells_in_column(column: int) -> Array:
	#return []


func get_cell(row: int, column: int) -> int:
	assert(row > 0 and row <= rows)
	assert(column > 0 and column <= columns)

	return get_cells_in_row(row)[column - 1]


func get_row_of_cell(cell: int) -> int:
	assert(cell > 0 and cell <= cells)

	var rows_filled := float(cell) / float(columns)
	return ceili(rows_filled)


func get_column_of_cell(cell: int) -> int:
	assert(cell > 0 and cell <= cells)

	var x = cell % columns
	if x == 0:
		return columns
	return x


# Untested
#func get_cells_in_skip_count(start_cell: int, step: int) -> Array:
	#if step > 0:
		#return range(start_cell, cells + 1, step)
	#else:
		#assert(step != 0)
		#return range(start_cell, 0, step)


# Untested
# Returns start_cell and all cells in the direction up to the end of the grid.
#func get_cells_in_direction(start_cell: int, direction: Utils.Direction) -> Array:
	#const direction_to_step: Dictionary = {
		#Utils.Direction.LEFT: -1,
		#Utils.Direction.RIGHT: 1,
		#Utils.Direction.UP: -10,
		#Utils.Direction.DOWN: 10,
	#}
	#return get_cells_in_skip_count(start_cell, direction_to_step[direction])


#func get_cells_between(start_cell: int, end_cell: int) -> Array:
	#return []
