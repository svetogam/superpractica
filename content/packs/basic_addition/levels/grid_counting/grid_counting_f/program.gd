# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var object_sum_icon := preload("uid://bkor8qo5sy7xa")
var object_count_icon := preload("uid://caqvd811whwr2")
var object_sum: int
var object_count: int
var pim: Pim
var field: Field
var field_program: FieldProgram


func _setup_vars() -> void:
	object_sum = level.level_data.program_vars.object_sum
	object_count = level.level_data.program_vars.object_count


func _ready() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.add_condition(IntegerMemo.new(object_sum), object_sum_icon)
	goal_panel.add_condition(IntegerMemo.new(object_count), object_count_icon)


func _on_playing_state_entered() -> void:
	field.set_tool(GridCounting.Tools.PIECE_DRAGGER)
	overlay.pim_objects.exclude_all("GridCounting")

	if level.level_data.program_vars.allow_unit:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)
	if level.level_data.program_vars.allow_two_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.TWO_BLOCK)
	if level.level_data.program_vars.allow_three_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.THREE_BLOCK)
	if level.level_data.program_vars.allow_four_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FOUR_BLOCK)
	if level.level_data.program_vars.allow_five_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FIVE_BLOCK)
	if level.level_data.program_vars.allow_ten_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.TEN_BLOCK)
	if level.level_data.program_vars.allow_twenty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.TWENTY_BLOCK)
	if level.level_data.program_vars.allow_thirty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.THIRTY_BLOCK)
	if level.level_data.program_vars.allow_forty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FORTY_BLOCK)
	if level.level_data.program_vars.allow_fifty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FIFTY_BLOCK)

	field_program = field.get_program("SoftCount")
	field_program.run()

	field.warning_signaler.warned.connect(
		goal_panel.verify_button.set.bind("disabled", true)
	)
	field.warning_signaler.unwarned.connect(
		goal_panel.verify_button.set.bind("disabled", false)
	)
	goal_panel.verification_requested.connect(_on_verification_requested)


func _on_verification_requested() -> void:
	BasicAdditionProcesses.VerifGridCountingSumPieces.instantiate().setup(pim).run(
		level.verifier, [0], _on_first_verification_completed
	)


func _on_first_verification_completed() -> void:
	BasicAdditionProcesses.VerifGridCountingCountPieces.instantiate().setup(pim).run(
		level.verifier, [1], _on_verified
	)


func _on_verified() -> void:
	complete_task()
	$StateChart.send_event("done")


func _on_playing_state_exited() -> void:
	field.warning_signaler.warned.disconnect(goal_panel.verify_button.set)
	field.warning_signaler.unwarned.disconnect(goal_panel.verify_button.set)
	goal_panel.verification_requested.disconnect(_on_verification_requested)
