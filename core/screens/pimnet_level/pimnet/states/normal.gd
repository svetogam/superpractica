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


func _on_system_button_pressed() -> void:
	_change_state("System")


func _on_plan_button_pressed() -> void:
	_change_state("Plan")


func _on_edit_panels_button_pressed() -> void:
	_change_state("EditPanels")
