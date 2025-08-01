# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

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

	%SoftCountProgram.field = field
	%SoftCountProgram.run()

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
