#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PanelContainer

var _current_goal_check := Callable()
@onready var enabler := $ButtonEnabler as Node


func _ready() -> void:
	enabler.add_button("check", %CheckGoalButton)


func activate_check_button() -> void:
	%CheckGoalButton.visible = true


func deactivate_check_button() -> void:
	%CheckGoalButton.visible = false


func connect_goal_check(callable: Callable) -> void:
	%CheckGoalButton.pressed.connect(callable)
	_current_goal_check = callable


func disconnect_goal_check() -> void:
	%CheckGoalButton.pressed.disconnect(_current_goal_check)
	_current_goal_check = Callable()


func add_check_condition(condition: Callable, sought := true) -> void:
	enabler.connect_button("check", condition, sought)


func remove_check_condition(condition: Callable) -> void:
	enabler.disconnect_button("check", condition)
