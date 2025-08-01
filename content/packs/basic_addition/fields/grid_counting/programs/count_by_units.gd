# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldProgram

signal completed
signal affirmed
signal rejected

@export var start_number: int = -1
@export var count: int = -1
var _next_number: int
var _last_number: int


func run() -> void:
	assert(field != null)
	assert(start_number != -1)

	_next_number = start_number + 1
	if count != -1:
		_last_number = start_number + count
	else:
		_last_number = -1

	field.add_action_condition(GridCounting.ACTION_CREATE_UNIT, _create_unit_condition)
	field.action_done.connect(_on_action_done)


func _create_unit_condition(action: GridCountingActionCreateUnit) -> bool:
	if action.cell_number == _next_number:
		return true
	else:
		var cell = field.dynamic_model.get_grid_cell(action.cell_number)
		field.info_signaler.reject(cell.position)
		rejected.emit()
		return false


func _on_action_done(action: FieldAction) -> void:
	match action.name:
		GridCounting.ACTION_CREATE_UNIT:
			var cell = field.dynamic_model.get_grid_cell(action.cell_number)
			field.info_signaler.affirm(cell.position)
			affirmed.emit()
			_next_number += 1
			cell.unit.set_variant("affirmation")

			if _last_number != -1 and action.cell_number == _last_number:
				completed.emit()
				queue_free()
