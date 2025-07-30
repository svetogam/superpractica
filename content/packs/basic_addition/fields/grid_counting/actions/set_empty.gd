# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionSetEmpty
extends FieldAction


static func get_name() -> int:
	return GridCounting.Actions.SET_EMPTY


func do() -> void:
	for unit in field.dynamic_model.get_units():
		unit.free()
	for block in field.dynamic_model.get_blocks():
		block.free()

	var cell = field.get_marked_cell()
	if cell != null:
		cell.toggle_mark()

	field.info_signaler.clear()
	field.count_signaler.reset_count()
