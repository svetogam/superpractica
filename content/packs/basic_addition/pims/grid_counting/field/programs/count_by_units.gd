# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldProgram

signal completed
signal affirmed
signal rejected

var _start_number: int
var _count: int
var _next_number: int
var _last_number: int


func setup(p_start_number: int, p_count: int = -1) -> void:
	assert(not is_running())

	_start_number = p_start_number
	if p_count != -1:
		_count = p_count


func _start() -> void:
	_next_number = _start_number + 1

	if _count != -1:
		_last_number = _start_number + _count
	else:
		_last_number = -1


func _before_action(action: FieldAction) -> bool:
	match action.name:
		GridCounting.Actions.CREATE_UNIT:
			if action.cell_number == _next_number:
				return true
			else:
				var cell = field.dynamic_model.get_grid_cell(action.cell_number)
				field.info_signaler.reject(cell.position)
				rejected.emit()
				return false
		_:
			return true


func _after_action(action: FieldAction) -> void:
	match action.name:
		GridCounting.Actions.CREATE_UNIT:
			var cell = field.dynamic_model.get_grid_cell(action.cell_number)
			field.info_signaler.affirm(cell.position)
			affirmed.emit()
			_next_number += 1
			cell.unit.set_variant("affirmation")

			if _last_number != -1 and action.cell_number == _last_number:
				completed.emit()
				stop()
