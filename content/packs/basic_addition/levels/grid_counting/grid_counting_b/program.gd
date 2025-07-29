# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var count: int
var pim: Pim
var field: Field
var output_program: PimProgram
var field_program: FieldProgram
var intermediate_goal: int


func _setup_vars(level_vars: Dictionary) -> void:
	if level_vars.has("count"):
		count = level_vars["count"]
	else:
		count = randi_range(level_vars["min_count"], level_vars["max_count"])

	if IntegerMath.get_hundreds_digit(count) == 1:
		intermediate_goal = 100
	else:
		intermediate_goal = IntegerMath.get_tens_digit(count) * 10


func _ready() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field
	field_program = field.get_program("SoftCount")

	goal_panel.slot.set_memo_as_hint(IntegerMemo, count)

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()


func _get_instruction_replacements() -> Dictionary:
	return {"count": count}


func _on_put_blocks_state_entered() -> void:
	field.set_tool(GridCounting.Tools.PIECE_DRAGGER)
	overlay.pim_objects.exclude_all("GridCounting")
	overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)
	overlay.pim_objects.include("GridCounting", GridCounting.Objects.TEN_BLOCK)

	field_program.disallow_object(GridCounting.Objects.UNIT)
	field_program.run()

	output_program.output_decided.connect(_on_output_decided)
	field.warning_signaler.warned.connect(_set_output_warning.bind(true))
	field.warning_signaler.unwarned.connect(_set_output_warning.bind(false))

	if count < 10:
		complete_task()
		$StateChart.send_event("done")


func _on_output_decided(output_number: int) -> void:
	if field_program.is_valid():
		if $StateChart/States/PutBlocks.active and output_number == intermediate_goal:
			_set_output_warning(false)
			complete_task()
			$StateChart.send_event("done")
		elif $StateChart/States/PutUnits.active and output_number == count:
			_set_output_warning(false)
			complete_task()
			$StateChart.send_event("done")


func _set_output_warning(warned: bool) -> void:
	pim.slot.memo_output_enabled = not warned


func _on_put_blocks_state_exited() -> void:
	output_program.output_decided.disconnect(_on_output_decided)
	field.warning_signaler.warned.disconnect(_set_output_warning)
	field.warning_signaler.unwarned.disconnect(_set_output_warning)


func _on_put_units_state_entered() -> void:
	level.reverter.history.clear()
	set_custom_reset(_reset)

	field_program.reallow_object(GridCounting.Objects.UNIT)

	output_program.output_decided.connect(_on_output_decided)
	field.warning_signaler.warned.connect(_set_output_warning.bind(true))
	field.warning_signaler.unwarned.connect(_set_output_warning.bind(false))

	if count == intermediate_goal:
		complete_task()
		$StateChart.send_event("done")


func _reset() -> void:
	field.reset_state()
	var blocks_to_add: int = intermediate_goal / 10
	for i in range(blocks_to_add):
		var row = i + 1
		GridCountingActionCreateTenBlock.new(field, row).push()


func _on_put_units_state_exited() -> void:
	output_program.output_decided.disconnect(_on_output_decided)
	field.warning_signaler.warned.disconnect(_set_output_warning)
	field.warning_signaler.unwarned.disconnect(_set_output_warning)


func _on_drag_memo_state_entered() -> void:
	field.set_tool(Game.NO_TOOL)
	pimnet.overlay.deactivate_panel(PimnetOverlay.PimnetPanels.PIM_OBJECTS)
	level.reverter.history.clear()
	set_no_reset()

	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _on_goal_slot_filled() -> void:
	complete_task()
	$StateChart.send_event("done")
