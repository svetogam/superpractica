# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldProgram

signal completed
signal rejected

@export var start_number: int = -1


func run() -> void:
	assert(field != null)
	assert(start_number != -1)

	field.add_action_condition(GridCounting.ACTION_TOGGLE_MARK, _toggle_mark_condition)
	field.action_done.connect(_on_action_done)


func _toggle_mark_condition(action: GridCountingActionToggleMark) -> bool:
	if action.cell_number == start_number:
		return true
	else:
		var cell = field.dynamic_model.get_grid_cell(action.cell_number)
		field.info_signaler.reject(cell.position)
		rejected.emit()
		return false


func _on_action_done(action: FieldAction) -> void:
	match action.name:
		GridCounting.ACTION_TOGGLE_MARK:
			var cell = field.dynamic_model.get_grid_cell(action.cell_number)
			cell.set_ring_variant("affirmation")
			field.info_signaler.affirm(cell.position)
			completed.emit()
			queue_free()
