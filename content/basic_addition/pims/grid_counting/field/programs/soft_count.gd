#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SoftLimiterProgram

var _start_number: int


func setup(p_start_number: int) -> void:
	assert(not is_running())

	_start_number = p_start_number

	# Build program rules
	set_object_rule_results(GridCounting.Objects.UNIT,
			field.remove_unit_warning, field.stage_unit_warning)
	set_object_rule_results(GridCounting.Objects.TEN_BLOCK,
			field.remove_ten_block_warning, field.stage_ten_block_warning)
	add_object_rule(GridCounting.Objects.UNIT, _is_unit_valid)
	add_object_rule(GridCounting.Objects.TEN_BLOCK, _is_ten_block_valid)


func _is_ten_block_valid(ten_block: FieldObject) -> bool:
	# Ensure start number is aligned with the start of rows
	if _start_number % 10 != 0:
		return false

	# Ensure ten-blocks follow each other in an unbroken sequence
	var first_row = field.get_row_number_for_cell_number(_start_number + 1)
	var correct_rows = field.get_contiguous_rows_with_ten_blocks_from(first_row)
	return correct_rows.has(ten_block.row_number)


func _is_unit_valid(unit: FieldObject) -> bool:
	# Ensure first unit follows either the start or a valid ten-block
	if field.get_smallest_marked_number(GridCounting.CellMarks.UNIT) == unit.cell.number:
		if unit.cell.number == _start_number + 1:
			return true
		else:
			var row_number = field.get_row_number_for_cell_number(unit.cell.number - 1)
			var ten_block = field.get_ten_block(row_number)
			return ten_block != null and _is_ten_block_valid(ten_block)

	# Ensure units follow each other in an unbroken sequence
	var valid_numbers = field.get_contiguous_occupied_numbers_from(_start_number + 1)
	return valid_numbers.has(unit.cell.number)
