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

enum PimnetPanels {
	INVENTORY,
	TOOLS,
	CREATION,
	TRANSLATION,
	GOAL,
	PLAN,
}
enum GoalPanels {
	ARBITRARY_CHECK = 0,
	HINTED_MEMO_SLOT,
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
	set = _do_not_set,
	get = _get_maximum_active_panels
var goal_type: GoalPanels:
	set = _set_goal_type
var goal_panel: Control:
	set = _do_not_set,
	get = _get_goal_panel
@onready var reversion_menu := %ReversionMenu as Control
@onready var plan_panel := %PlanPanel as Control
@onready var tool_panel := %ToolPanel as Control
@onready var creation_panel := %CreationPanel as Control


func _ready() -> void:
	# Connect panel-buttons
	for panel_type in PANEL_TYPE_LIST:
		var button := _get_button(panel_type)
		button.toggled.connect(_on_panel_button_toggled.bind(panel_type))

	# Set level title
	if Game.current_level != null:
		var topic_title := Game.current_level.topic.title
		var level_title := Game.current_level.title
		set_level_title_text(topic_title + " > " + level_title)


func _on_main_menu_button_pressed() -> void:
	%MainMenuPopup.visible = true


func _on_continue_button_pressed() -> void:
	%MainMenuPopup.visible = false


func _on_settings_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	exit_pressed.emit()


func _on_stay_button_pressed() -> void:
	%CompletionPopup.hide()


func _on_select_level_button_pressed() -> void:
	exit_pressed.emit()


func _on_next_level_button_pressed() -> void:
	pass


func _on_panel_button_toggled(toggled_on: bool, panel_type: PimnetPanels) -> void:
	var panel := _get_panel(panel_type)
	panel.visible = toggled_on

	#Deactivate overflowing panels
	if _get_number_active_panels() > maximum_active_panels:
		for other_panel_type in PANEL_TYPE_LIST:
			if other_panel_type != panel_type:
				var other_panel := _get_panel(other_panel_type)
				if other_panel.visible:
					deactivate_panel(other_panel_type)
					break

	assert(_get_number_active_panels() <= maximum_active_panels)


func setup_panel(panel_type: PimnetPanels, enable: bool, start_active: bool) -> void:
	var button := _get_button(panel_type)
	if not enable:
		button.visible = false
	if start_active:
		activate_panel(panel_type)


func activate_reversion() -> void:
	reversion_menu.visible = true


func deactivate_reversion() -> void:
	reversion_menu.visible = false


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


func enable_scroll_buttons(enable := true) -> void:
	if enable:
		%LeftButton.show()
		%RightButton.show()
	else:
		%LeftButton.hide()
		%RightButton.hide()


func show_completion_popup() -> void:
	%CompletionPopup.visible = true


func set_level_title_text(text: String) -> void:
	%LevelTitle.text = text


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
	var should_activate = goal_panel.visible
	if should_activate:
		deactivate_panel(PimnetPanels.GOAL)

	goal_type = p_goal_type

	if should_activate:
		match goal_type:
			GoalPanels.ARBITRARY_CHECK:
				%ArbitraryCheckPanel.show()
			GoalPanels.HINTED_MEMO_SLOT:
				%HintedMemoSlotPanel.show()


func _get_goal_panel() -> Control:
	match goal_type:
		GoalPanels.ARBITRARY_CHECK:
			return %ArbitraryCheckPanel
		GoalPanels.HINTED_MEMO_SLOT:
			return %HintedMemoSlotPanel
		_:
			assert(false)
			return null


func _get_number_active_panels() -> int:
	var count := 0
	for panel_type in PANEL_TYPE_LIST:
		var panel := _get_panel(panel_type)
		if panel.visible:
			count += 1
	return count


func _get_maximum_active_panels() -> int:
	const PANEL_WIDTH := 300.0
	return floori(get_viewport_rect().size.x / PANEL_WIDTH)


static func _do_not_set(_value: Variant) -> void:
	assert(false)
