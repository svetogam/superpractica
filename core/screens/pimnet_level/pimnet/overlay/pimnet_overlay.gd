#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimnetOverlay
extends Control

signal exit_pressed
signal next_level_requested()

enum PimnetPanels {
	NONE = 0,
	TOOLS,
	CREATION,
	TRANSLATION,
}

var goal_type: LevelResource.GoalTypes = LevelResource.GoalTypes.NONE:
	set = _set_goal_type
var goal_panel: Control:
	get = _get_goal_panel
@onready var reversion_menu := %ReversionMenu as Control
@onready var plan_panel := %PlanPanel as Control
@onready var tool_panel := %ToolPanel as Control
@onready var creation_panel := %CreationPanel as Control
@onready var verification_panel := %SolutionVerificationPanel as Control


func _ready() -> void:
	# Connect panel-buttons
	%ToolsButton.toggled.connect(_on_panel_button_toggled.bind(PimnetPanels.TOOLS))
	%CreationButton.toggled.connect(_on_panel_button_toggled.bind(PimnetPanels.CREATION))
	%TranslationButton.toggled.connect(
			_on_panel_button_toggled.bind(PimnetPanels.TRANSLATION))

	goal_type = Game.current_level.goal_type
	%LevelTitle.text = Game.get_current_level_title()
	%OverlayStateMachine.activate()


func _on_settings_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	exit_pressed.emit()


func _on_completion_popup_visibility_changed() -> void:
	%NextLevelButton.disabled = not Game.is_level_suggested_after_current()


func _on_stay_button_pressed() -> void:
	%CompletionPopup.hide()


func _on_select_level_button_pressed() -> void:
	exit_pressed.emit()


func _on_next_level_button_pressed() -> void:
	next_level_requested.emit()


func _on_panel_button_toggled(toggled_on: bool, panel_type: PimnetPanels) -> void:
	var panel := _get_panel(panel_type)
	panel.visible = toggled_on


func setup_panel(panel_type: PimnetPanels, enable: bool, start_active: bool) -> void:
	var button := _get_button(panel_type)
	if not enable:
		button.visible = false
	if start_active:
		activate_panel(panel_type)


func enable_panel(panel_type: PimnetPanels) -> void:
	var button := _get_button(panel_type)
	button.visible = true


func disable_panel(panel_type: PimnetPanels) -> void:
	var button := _get_button(panel_type)
	button.button_pressed = false
	button.visible = false


func activate_panel(panel_type: PimnetPanels) -> void:
	var button := _get_button(panel_type)
	assert(button.visible)
	button.button_pressed = true

	var panel := _get_panel(panel_type)
	assert(panel.visible)


func deactivate_panel(panel_type: PimnetPanels) -> void:
	var button := _get_button(panel_type)
	if button.visible:
		button.button_pressed = false

	var panel := _get_panel(panel_type)
	assert(not panel.visible)


func show_completion_popup() -> void:
	%CompletionPopup.visible = true


func _get_panel(panel_type: PimnetPanels) -> PanelContainer:
	match panel_type:
		PimnetPanels.TOOLS:
			return %ToolPanel
		PimnetPanels.CREATION:
			return %CreationPanel
		_:
			assert(false)
			return null


func _get_button(panel_type: PimnetPanels) -> Button:
	match panel_type:
		PimnetPanels.TOOLS:
			return %ToolsButton
		PimnetPanels.CREATION:
			return %CreationButton
		PimnetPanels.TRANSLATION:
			return %TranslationButton
		_:
			assert(false)
			return null


func _set_goal_type(p_goal_type: LevelResource.GoalTypes) -> void:
	if p_goal_type == goal_type:
		return

	goal_type = p_goal_type
	match goal_type:
		LevelResource.GoalTypes.NONE:
			%HintedMemoSlotPanel.hide()
			%SolutionMemoSlotsPanel.hide()
			%ConstructConditionsPanel.hide()
		LevelResource.GoalTypes.HINTED_MEMO_SLOT:
			%SolutionMemoSlotsPanel.hide()
			%ConstructConditionsPanel.hide()
			%HintedMemoSlotPanel.show()
		LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS:
			%HintedMemoSlotPanel.hide()
			%ConstructConditionsPanel.hide()
			%SolutionMemoSlotsPanel.show()
		LevelResource.GoalTypes.CONSTRUCT_CONDITIONS:
			%HintedMemoSlotPanel.hide()
			%SolutionMemoSlotsPanel.hide()
			%ConstructConditionsPanel.show()


func _get_goal_panel() -> Control:
	match goal_type:
		LevelResource.GoalTypes.NONE:
			return null
		LevelResource.GoalTypes.HINTED_MEMO_SLOT:
			return %HintedMemoSlotPanel
		LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS:
			return %SolutionMemoSlotsPanel
		LevelResource.GoalTypes.CONSTRUCT_CONDITIONS:
			return %ConstructConditionsPanel
		_:
			assert(false)
			return null
