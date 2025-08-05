# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

const SUM_ROW: int = 0
const OBJECT_COUNT_ROW: int = 1
const SumIcon := preload("uid://bkor8qo5sy7xa")
const ObjectCountIcon := preload("uid://caqvd811whwr2")
var sum: int
var object_count: int
var allowed_objects: Array #[String]
var pim: Pim
var field: Field


func _setup_vars(level_vars: Dictionary) -> void:
	sum = level_vars["sum"]
	object_count = level_vars["object_count"]
	allowed_objects = level_vars["allowed_objects"]


func _ready() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.add_condition(IntegerMemo.new(sum), SumIcon)
	goal_panel.add_condition(IntegerMemo.new(object_count), ObjectCountIcon)
	%SoftCountProgram.field = field
	%SoftCountProgram.run()
	$StateChart.set_expression_property("start_verifying_delay", START_VERIFYING_DELAY)

	field.warning_signaler.warned.connect(
		goal_panel.verify_button.set.bind("disabled", true)
	)
	field.warning_signaler.unwarned.connect(
		goal_panel.verify_button.set.bind("disabled", false)
	)
	goal_panel.verification_requested.connect(_on_verification_requested)


func _on_playing_state_entered() -> void:
	field.set_tool(GridCounting.TOOL_PIECE_DRAGGER)
	overlay.pim_objects.exclude_all("GridCounting")

	if allowed_objects.has("unit"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_UNIT)
	if allowed_objects.has("two_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_TWO_BLOCK)
	if allowed_objects.has("three_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_THREE_BLOCK)
	if allowed_objects.has("four_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_FOUR_BLOCK)
	if allowed_objects.has("five_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_FIVE_BLOCK)
	if allowed_objects.has("ten_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_TEN_BLOCK)
	if allowed_objects.has("twenty_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_TWENTY_BLOCK)
	if allowed_objects.has("thirty_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_THIRTY_BLOCK)
	if allowed_objects.has("forty_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_FORTY_BLOCK)
	if allowed_objects.has("fifty_block"):
		overlay.pim_objects.include("GridCounting", GridCounting.OBJECT_FIFTY_BLOCK)


func _on_verification_requested() -> void:
	start_verifying()
	$StateChart.send_event("verify")


func _on_sum_pieces_state_entered() -> void:
	field.count_signaler.reset_count()

	$SumPiecesProgram.field = field
	$SumPiecesProgram.items = field.dynamic_model.get_pieces()
	$SumPiecesProgram.run()


func _on_sum_pieces_program_completed(last_count_object: NumberSignal) -> void:
	EqualityVerification.new(last_count_object).run(
		self,
		[SUM_ROW],
		$StateChart.send_event.bind("succeed"),
		$StateChart.send_event.bind("fail")
	)


func _on_count_pieces_state_entered() -> void:
	field.count_signaler.reset_count()

	$CountPiecesProgram.field = field
	$CountPiecesProgram.items = field.dynamic_model.get_pieces()
	$CountPiecesProgram.run()


func _on_count_pieces_program_completed(last_count_object: NumberSignal) -> void:
	EqualityVerification.new(last_count_object).run(
		self,
		[OBJECT_COUNT_ROW],
		$StateChart.send_event.bind("succeed"),
		$StateChart.send_event.bind("fail")
	)


func _on_verifying_state_exited() -> void:
	stop_verifying()


func _on_completed_state_entered() -> void:
	complete_task()
