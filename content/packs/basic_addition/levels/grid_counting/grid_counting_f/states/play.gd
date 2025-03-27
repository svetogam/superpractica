# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgramState

var _field_program: FieldProgram


func _enter(_last_state: String) -> void:
	program.field.set_tool(GridCounting.Tools.PIECE_DRAGGER)
	overlay.pim_objects.exclude_all("GridCounting")

	if Game.current_level.program_vars.allow_unit:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)
	if Game.current_level.program_vars.allow_two_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.TWO_BLOCK)
	if Game.current_level.program_vars.allow_three_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.THREE_BLOCK)
	if Game.current_level.program_vars.allow_four_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FOUR_BLOCK)
	if Game.current_level.program_vars.allow_five_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FIVE_BLOCK)
	if Game.current_level.program_vars.allow_ten_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.TEN_BLOCK)
	if Game.current_level.program_vars.allow_twenty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.TWENTY_BLOCK)
	if Game.current_level.program_vars.allow_thirty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.THIRTY_BLOCK)
	if Game.current_level.program_vars.allow_forty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FORTY_BLOCK)
	if Game.current_level.program_vars.allow_fifty_block:
		overlay.pim_objects.include("GridCounting", GridCounting.Objects.FIFTY_BLOCK)

	_field_program = program.field.get_program("SoftCount")
	_field_program.run()

	program.field.warning_signaler.warned.connect(
			goal_panel.verify_button.set.bind("disabled", true))
	program.field.warning_signaler.unwarned.connect(
			goal_panel.verify_button.set.bind("disabled", false))
	goal_panel.verification_requested.connect(_on_verification_requested)


func _on_verification_requested() -> void:
	(BasicAdditionProcesses.VerifGridCountingSumPieces.instantiate()
			.setup(program.pim)
			.run(verifier, [0], _on_first_verification_completed))


func _on_first_verification_completed() -> void:
	(BasicAdditionProcesses.VerifGridCountingCountPieces.instantiate()
			.setup(program.pim)
			.run(verifier, [1], complete))


func _exit(_next_state: String) -> void:
	program.field.warning_signaler.warned.disconnect(goal_panel.verify_button.set)
	program.field.warning_signaler.unwarned.disconnect(goal_panel.verify_button.set)
	goal_panel.verification_requested.disconnect(_on_verification_requested)
