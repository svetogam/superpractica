# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObject

var first_number: int
var numbers: Array:
	get:
		return [first_number, first_number + 1]
var cells: Array:
	get:
		return [
			field.dynamic_model.get_grid_cell(first_number),
			field.dynamic_model.get_grid_cell(first_number + 1),
		]
var drop_action: FieldAction


static func _get_object_type() -> String:
	return GridCounting.OBJECT_TWO_BLOCK


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
		GridCountingActionDeleteTwoBlock.new(field, first_number).push()
		get_viewport().set_input_as_handled()

	if $StateChart/States/ActiveModes/Drag/On.active:
		grab(true)


func _dragged(_external: bool, point: Vector2, _change: Vector2) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		var dest_cells = field.get_h_adjacent_grid_cells_at_point(point)
		if not dest_cells.is_empty():
			drop_action = GridCountingActionMoveTwoBlock.new(
					field, first_number, dest_cells[0].number)
			drop_action.prefigure()
		elif drop_action != null:
			drop_action.unprefigure()


func _dropped(_external: bool, _point: Vector2) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		assert(drop_action != null)
		drop_action.push()


func _dropped_out(_receiver: Field) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		GridCountingActionDeleteTwoBlock.new(field, first_number).push()


# p_first_number is the first cell the block occupies
func put_on_grid(p_first_number: int) -> void:
	assert(p_first_number % 10 != 0)

	first_number = p_first_number
	position = Vector2(
		cells[0].position.x + (cells[1].position.x - cells[0].position.x) / 2,
		cells[0].position.y
	)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant
