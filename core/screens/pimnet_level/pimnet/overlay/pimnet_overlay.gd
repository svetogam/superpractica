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
	INVENTORY,
	TOOLS,
	CREATION,
	TRANSLATION,
	GOAL,
	PLAN,
}
enum GoalPanels {
	NONE = 0,
	HINTED_MEMO_SLOT,
	SOLUTION_MEMO_SLOTS,
}

const PANEL_TYPE_LIST := [
	PimnetPanels.INVENTORY,
	PimnetPanels.TOOLS,
	PimnetPanels.CREATION,
	PimnetPanels.TRANSLATION,
	PimnetPanels.GOAL,
	PimnetPanels.PLAN,
]

var maximum_active_panels: int:
	get = _get_maximum_active_panels
var goal_type: GoalPanels = GoalPanels.NONE:
	set = _set_goal_type,
	get = _get_goal_type
var goal_panel: Control:
	get = _get_goal_panel
@onready var reversion_menu := %ReversionMenu as Control
@onready var plan_panel := %PlanPanel as Control
@onready var tool_panel := %ToolPanel as Control
@onready var creation_panel := %CreationPanel as Control
@onready var verification_panel := %SolutionVerificationPanel as Control


func _ready() -> void:
	# Connect panel-buttons
	for panel_type in PANEL_TYPE_LIST:
		var button := _get_button(panel_type)
		button.toggled.connect(_on_panel_button_toggled.bind(panel_type))

	%LevelTitle.text = Game.get_current_level_title()


func _on_pause_menu_button_pressed() -> void:
	%PauseMenuPopup.visible = true
	get_tree().paused = true


func _on_continue_button_pressed() -> void:
	%PauseMenuPopup.visible = false


func _on_settings_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	exit_pressed.emit()


func _on_pause_menu_popup_hide() -> void:
	get_tree().paused = false


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
	deactivate_overflowing_panels(panel_type)


func deactivate_overflowing_panels(priority_panel_type: PimnetPanels = PimnetPanels.NONE
) -> void:
	if _get_number_active_panels() > maximum_active_panels:
		for panel_type in PANEL_TYPE_LIST:
			if panel_type != priority_panel_type:
				var other_panel := _get_panel(panel_type)
				if other_panel.visible:
					deactivate_panel(panel_type)
					break

	assert(_get_number_active_panels() <= maximum_active_panels)


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


func activate_reversion() -> void:
	reversion_menu.visible = true


func deactivate_reversion() -> void:
	reversion_menu.visible = false


func enable_scroll_buttons(enable := true) -> void:
	if enable:
		%LeftButton.show()
		%RightButton.show()
	else:
		%LeftButton.hide()
		%RightButton.hide()


func show_completion_popup() -> void:
	%CompletionPopup.visible = true


func _get_panel(panel_type: PimnetPanels) -> PanelContainer:
	match panel_type:
		PimnetPanels.INVENTORY:
			return %InventoryPanel
		PimnetPanels.TOOLS:
			return %ToolPanel
		PimnetPanels.CREATION:
			return %CreationPanel
		PimnetPanels.TRANSLATION:
			return %TranslationPanel
		PimnetPanels.GOAL:
			return goal_panel
		PimnetPanels.PLAN:
			return %PlanPanel
		_:
			assert(false)
			return null


func _get_button(panel_type: PimnetPanels) -> Button:
	match panel_type:
		PimnetPanels.INVENTORY:
			return %InventoryButton
		PimnetPanels.TOOLS:
			return %ToolsButton
		PimnetPanels.CREATION:
			return %CreationButton
		PimnetPanels.TRANSLATION:
			return %TranslationButton
		PimnetPanels.GOAL:
			return %GoalButton
		PimnetPanels.PLAN:
			return %PlanButton
		_:
			assert(false)
			return null


func _set_goal_type(p_goal_type: GoalPanels) -> void:
	if p_goal_type == goal_type:
		return
	elif goal_type != GoalPanels.NONE:
		deactivate_panel(PimnetPanels.GOAL)

	goal_type = p_goal_type
	match goal_type:
		GoalPanels.NONE:
			%HintedMemoSlotPanel.hide()
			%SolutionMemoSlotsPanel.hide()
			%SolutionColumn.hide()
		GoalPanels.HINTED_MEMO_SLOT:
			%HintedMemoSlotPanel.show()
			%SolutionColumn.hide()
		GoalPanels.SOLUTION_MEMO_SLOTS:
			%SolutionMemoSlotsPanel.show()
			%SolutionColumn.show()


func _get_goal_type() -> GoalPanels:
	if %GoalButton != null and not %GoalButton.visible:
		return GoalPanels.NONE
	else:
		return goal_type


func _get_goal_panel() -> Control:
	match goal_type:
		GoalPanels.NONE:
			return null
		GoalPanels.HINTED_MEMO_SLOT:
			return %HintedMemoSlotPanel
		GoalPanels.SOLUTION_MEMO_SLOTS:
			return %SolutionMemoSlotsPanel
		_:
			assert(false)
			return null


func _get_number_active_panels() -> int:
	var count := 0
	for panel_type in PANEL_TYPE_LIST:
		var panel := _get_panel(panel_type)
		if panel != null and panel.visible:
			count += 1
	return count


func _get_maximum_active_panels() -> int:
	#const PANEL_WIDTH := 300.0
	#var screen_rect := Game.get_screen_rect()
	#return floori(screen_rect.size.x / PANEL_WIDTH)

	# Using this hack instead until panels conserve space better
	return 3
