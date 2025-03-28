# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldProgram

signal completed
signal rejected

var _start_number: int


func setup(p_start_number: int) -> void:
	assert(not is_running())

	_start_number = p_start_number


func _before_action(action: FieldAction) -> bool:
	match action.name:
		GridCounting.Actions.TOGGLE_MARK:
			if action.cell_number == _start_number:
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
		GridCounting.Actions.TOGGLE_MARK:
			var cell = field.dynamic_model.get_grid_cell(action.cell_number)
			cell.set_ring_variant("affirmation")
			field.info_signaler.affirm(cell.position)
			stop()
			completed.emit()
