# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObjectMode


func _pressed(_point: Vector2) -> void:
	GridCountingActionDeleteFiftyBlock.new(field, object.first_row_number).push()
	get_viewport().set_input_as_handled()
