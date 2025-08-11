# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends SoftLimiterProgram

var _start_number: int
var _valid_numbers: Array


func run() -> void:
	super()

	# Build program rules
	add_object_rule(GridCounting.OBJECT_UNIT, _is_unit_valid)
	add_object_rule(GridCounting.OBJECT_TWO_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_THREE_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_FOUR_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_FIVE_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_TEN_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_TWENTY_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_THIRTY_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_FORTY_BLOCK, _is_block_valid)
	add_object_rule(GridCounting.OBJECT_FIFTY_BLOCK, _is_block_valid)
	set_object_rule_results(GridCounting.OBJECT_UNIT,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_TWO_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_THREE_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_FOUR_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_FIVE_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_TEN_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_TWENTY_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_THIRTY_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_FORTY_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)
	set_object_rule_results(GridCounting.OBJECT_FIFTY_BLOCK,
			field.remove_piece_warning, field.stage_piece_warning)


func _cache() -> void:
	_start_number = _get_start_number()
	_valid_numbers = field.get_contiguous_occupied_numbers_from(_start_number + 1)


func _is_unit_valid(unit: FieldObject) -> bool:
	if unit.cell_number <= _start_number:
		return false
	return _valid_numbers.has(unit.cell_number)


func _is_block_valid(block: FieldObject) -> bool:
	if block.first_number <= _start_number:
		return false
	return _valid_numbers.has(block.first_number)


func _get_start_number() -> int:
	var cell = field.get_marked_cell()
	if cell == null:
		return 0
	else:
		return cell.number
