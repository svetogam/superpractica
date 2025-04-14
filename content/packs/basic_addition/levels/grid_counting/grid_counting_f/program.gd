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


func _setup_vars() -> void:
	object_sum = level.level_data.program_vars.object_sum
	object_count = level.level_data.program_vars.object_count


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.add_condition(IntegerMemo.new(object_sum), object_sum_icon)
	goal_panel.add_condition(IntegerMemo.new(object_count), object_count_icon)

	$StateMachine.activate()
