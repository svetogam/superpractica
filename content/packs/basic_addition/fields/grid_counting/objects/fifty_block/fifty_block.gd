# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObject

var first_row_number: int # Row numbers start at 1
var row_numbers: Array:
	get:
		return [first_row_number, first_row_number + 1, first_row_number + 2,
				first_row_number + 3, first_row_number + 4]
var numbers: Array:
	get = _get_numbers
var first_number: int:
	get:
		return field.static_model.get_first_cell_in_row(first_row_number)
var drop_action: FieldAction


static func _get_object_type() -> String:
	return GridCounting.OBJECT_FIFTY_BLOCK


func _update_active_modes(new_tool: String) -> void:
	if new_tool == GridCounting.TOOL_PIECE_DELETER:
		$StateChart.send_event("enable_delete")
	else:
		$StateChart.send_event("disable_delete")
	if new_tool == GridCounting.TOOL_PIECE_DRAGGER:
		$StateChart.send_event("enable_drag")
	else:
		$StateChart.send_event("disable_drag")


func _pressed(_point: Vector2) -> void:
	if $StateChart/States/ActiveModes/Delete/On.active:
		GridCountingActionDeleteFiftyBlock.new(field, first_row_number).push()
		get_viewport().set_input_as_handled()

	if $StateChart/States/ActiveModes/Drag/On.active:
		grab(true)


func _dragged(_external: bool, point: Vector2, _change: Vector2) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		var dest_cell = field.get_grid_cell_at_point(point)
		if dest_cell != null:
			var dest_row = field.static_model.get_row_of_cell(dest_cell.number) - 2
			drop_action = GridCountingActionMoveFiftyBlock.new(
					field, first_row_number, dest_row)
			drop_action.prefigure()
		elif drop_action != null:
			drop_action.unprefigure()


func _dropped(_external: bool, _point: Vector2) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		assert(drop_action != null)
		drop_action.push()


func _dropped_out(_receiver: Field) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		GridCountingActionDeleteFiftyBlock.new(field, first_row_number).push()


func put_on_row(p_first_row_number: int) -> void:
	assert(p_first_row_number >= 1 and p_first_row_number <= 6)

	first_row_number = p_first_row_number
	var cells = field.get_grid_cells_by_rows(row_numbers)
	position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[20].position.y
	)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant


func _get_numbers() -> Array:
	return range(field.static_model.get_first_cell_in_row(first_row_number),
			field.static_model.get_last_cell_in_row(first_row_number + 4) + 1)
