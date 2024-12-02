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

var start_number: int
var valid_numbers: Array


func _cache() -> void:
	start_number = _get_start_number()
	valid_numbers = field.get_contiguous_occupied_numbers_from(start_number + 1)


func _ready() -> void:
	# Build program rules
	add_object_rule(GridCounting.Objects.UNIT, _is_unit_valid)
	add_object_rule(GridCounting.Objects.TWO_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.Objects.THREE_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.Objects.FOUR_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.Objects.FIVE_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.Objects.TEN_BLOCK, _is_block_valid)
	set_object_rule_results(GridCounting.Objects.UNIT,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.Objects.TWO_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.Objects.THREE_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.Objects.FOUR_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.Objects.FIVE_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.Objects.TEN_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)


func _is_unit_valid(unit: FieldObject) -> bool:
	if unit.cell_number <= start_number:
		return false
	return valid_numbers.has(unit.cell_number)


func _is_block_valid(block: FieldObject) -> bool:
	if block.first_number <= start_number:
		return false
	return valid_numbers.has(block.first_number)


func _get_start_number() -> int:
	var cell = field.get_marked_cell()
	if cell == null:
		return 0
	else:
		return cell.number
