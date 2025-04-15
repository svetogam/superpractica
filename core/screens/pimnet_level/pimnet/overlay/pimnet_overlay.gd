# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name PimnetOverlay
extends Control

signal level_data_loaded(level_data)
signal level_data_unloaded

enum PimnetPanels {
	NONE = 0,
	PIM_TOOLS,
	PIM_OBJECTS,
}

var goal_type: LevelResource.GoalTypes = LevelResource.GoalTypes.NONE:
	set = _set_goal_type
var goal_panel: Control:
	get = _get_goal_panel
var level_data: LevelResource
@onready var plan_panel := %PlanPanel as Control
@onready var pim_tools := %PimToolsPanel as Control
@onready var pim_objects := %PimObjectsPanel as Control
@onready var verification_panel := %SolutionVerificationPanel as Control


func _enter_tree() -> void:
	CSLocator.with(self).connect_service_changed(
			Game.SERVICE_LEVEL_DATA, _on_level_data_changed)


func _on_level_data_changed(p_level_data: LevelResource) -> void:
	level_data = p_level_data

	if level_data != null:
		goal_type = level_data.goal_type
		%LevelTitle.text = level_data.extended_title
		level_data_loaded.emit(level_data)
	else:
		goal_type = LevelResource.GoalTypes.NONE
		%LevelTitle.text = "Level Title"
		level_data_unloaded.emit()


func _ready() -> void:
	# Connect panel-buttons
	%PimToolsButton.toggled.connect(_on_panel_button_toggled.bind(PimnetPanels.PIM_TOOLS))
	%PimObjectsButton.toggled.connect(_on_panel_button_toggled.bind(
			PimnetPanels.PIM_OBJECTS))

	%OverlayStateMachine.activate()


func _on_settings_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	Game.request_enter_level_select.emit()


func _on_completion_select_button_pressed() -> void:
	Game.request_enter_level_select.emit()


func _on_completion_next_button_pressed() -> void:
	if level_data == null:
		return

	var next_level = level_data.get_next_suggested_level()
	if next_level != null:
		Game.request_enter_level.emit(next_level)


func _on_panel_button_toggled(toggled_on: bool, panel_type: PimnetPanels) -> void:
	var panel := _get_panel(panel_type)
	panel.visible = toggled_on


func activate_panel(panel_type: PimnetPanels) -> void:
	var button := _get_button(panel_type)
	button.button_pressed = true


func deactivate_panel(panel_type: PimnetPanels) -> void:
	var button := _get_button(panel_type)
	button.button_pressed = false


func _get_panel(panel_type: PimnetPanels) -> PanelContainer:
	match panel_type:
		PimnetPanels.PIM_TOOLS:
			return %PimToolsPanel
		PimnetPanels.PIM_OBJECTS:
			return %PimObjectsPanel
		_:
			assert(false)
			return null


func _get_button(panel_type: PimnetPanels) -> Button:
	match panel_type:
		PimnetPanels.PIM_TOOLS:
			return %PimToolsButton
		PimnetPanels.PIM_OBJECTS:
			return %PimObjectsButton
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
