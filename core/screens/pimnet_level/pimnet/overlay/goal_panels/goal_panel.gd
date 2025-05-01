# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GoalPanel
extends PanelContainer

@onready var verification_panel := %SolutionVerificationPanel as PanelContainer


func start_verification() -> void:
	pass


func stop_verification() -> void:
	pass


func reset() -> void:
	pass


func succeed() -> void:
	pass


func fail() -> void:
	pass
