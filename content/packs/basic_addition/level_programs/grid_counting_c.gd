# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var addend_1: int
var addend_2: int
var pim: Pim
var field: Field


func _setup_vars(level_vars: Dictionary) -> void:
	if level_vars.has("addend_1"):
		addend_1 = level_vars["addend_1"]
	else:
		addend_1 = randi_range(level_vars["min_addend_1"], level_vars["max_addend_1"])

	if level_vars.has("addend_2"):
		addend_2 = level_vars["addend_2"]
	else:
		addend_2 = randi_range(level_vars["min_addend_2"], level_vars["max_addend_2"])


func _ready() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	pim.enable_output_slot()
	goal_panel.set_problem_memo(ExpressionMemo.new(str(addend_1) + "+" + str(addend_2)))
	%SoftCountProgram.field = field
	%SoftCountProgram.run()
	$StateChart.set_expression_property("start_verifying_delay", START_VERIFYING_DELAY)

	field.warning_signaler.warned.connect(_set_output_warning.bind(true))
	field.warning_signaler.unwarned.connect(_set_output_warning.bind(false))
	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _get_instruction_replacements() -> Dictionary:
	return {"addend_1": addend_1, "addend_2": addend_2}


func _on_playing_state_entered() -> void:
	overlay.pim_tools.exclude_all("GridCounting")
	overlay.pim_tools.include("GridCounting", GridCounting.TOOL_CELL_MARKER)
	overlay.pim_tools.include("GridCounting", GridCounting.TOOL_PIECE_DRAGGER)
	field.set_tool(GridCounting.TOOL_CELL_MARKER)
	overlay.pim_objects.exclude_all("GridCounting")
	overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_UNIT)


func _set_output_warning(warned: bool) -> void:
	pim.slot.memo_output_enabled = not warned


func _on_goal_slot_filled() -> void:
	start_verifying()
	$StateChart.send_event("verify")


func _on_check_start_state_entered() -> void:
	# Make number signal at marked cell
	var board_number: NumberSignal
	var marked_cell = field.get_marked_cell()
	if marked_cell != null:
		board_number = field.popup_number_by_grid_cell(marked_cell)
	# Or make a 0 number signal at first cell if no cell is marked
	else:
		var first_cell = field.dynamic_model.get_grid_cell(1)
		board_number = field.info_signaler.popup_number(0, first_cell.position)

	await Game.wait_for(0.5)

	EqualityVerification.new(board_number).run(
		self,
		verification_panel.get_unfilled_row_numbers(),
		$StateChart.send_event.bind("succeed"),
		$StateChart.send_event.bind("fail")
	)


func _on_check_start_state_exited() -> void:
	if field != null:
		field.info_signaler.clear()


func _on_check_pieces_state_entered() -> void:
	%SumPiecesProgram.field = field
	%SumPiecesProgram.items = field.dynamic_model.get_pieces()
	var marked_cell = field.get_marked_cell()
	if marked_cell != null:
		%SumPiecesProgram.zero_cell_number = marked_cell.number + 1
	%SumPiecesProgram.run()


func _on_sum_pieces_program_completed(last_count_object: NumberSignal) -> void:
	EqualityVerification.new(last_count_object).run(
		self,
		verification_panel.get_unfilled_row_numbers(),
		$StateChart.send_event.bind("succeed"),
		$StateChart.send_event.bind("fail")
	)


func _on_check_pieces_state_exited() -> void:
	if field != null:
		field.count_signaler.reset_count()
		field.info_signaler.clear()


func _on_verifying_state_exited() -> void:
	stop_verifying()


func _on_completed_state_entered() -> void:
	complete_task()
