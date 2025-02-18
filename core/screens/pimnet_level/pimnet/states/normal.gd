#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends State

func _enter(_last_state: String) -> void:
	%SystemButton.pressed.connect(_on_system_button_pressed)
	%PlanButton.pressed.connect(_on_plan_button_pressed)
	%EditPanelsButton.pressed.connect(_on_edit_panels_button_pressed)


func _on_system_button_pressed() -> void:
	_change_state("System")


func _on_plan_button_pressed() -> void:
	_change_state("Plan")


func _on_edit_panels_button_pressed() -> void:
	_change_state("EditPanels")


func _exit(_next_state: String) -> void:
	%SystemButton.pressed.disconnect(_on_system_button_pressed)
	%PlanButton.pressed.disconnect(_on_plan_button_pressed)
	%EditPanelsButton.pressed.disconnect(_on_edit_panels_button_pressed)
