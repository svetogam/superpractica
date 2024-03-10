#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimnetScreenGui
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

const PANEL_TYPE_LIST := [
	PimnetPanels.INVENTORY,
	PimnetPanels.TOOLS,
	PimnetPanels.CREATION,
	PimnetPanels.TRANSLATION,
	PimnetPanels.GOAL,
	PimnetPanels.PLAN,
]

@export var setup_resource: PimnetScreenSetup
var maximum_active_panels: int:
	set = _do_not_set,
	get = _get_maximum_active_panels
@onready var reversion_menu := %ReversionMenu as Control
@onready var goal_panel := %GoalPanel as Control
@onready var plan_panel := %PlanPanel as Control
@onready var tool_panel := %ToolPanel as Control
@onready var creation_panel := %CreationPanel as Control


func _ready() -> void:
	# Connect panel-buttons
	for panel_type in PANEL_TYPE_LIST:
		var button := _get_button(panel_type)
		button.toggled.connect(_on_panel_button_toggled.bind(panel_type))

	# Set up panels
	if setup_resource != null:
		if setup_resource.reversion_enable:
			activate_reversion()
		_setup_panel(PimnetPanels.INVENTORY, setup_resource.inventory_enable,
				setup_resource.inventory_start_active)
		_setup_panel(PimnetPanels.TOOLS, setup_resource.tools_enable,
				setup_resource.tools_start_active)
		_setup_panel(PimnetPanels.CREATION, setup_resource.creation_enable,
				setup_resource.creation_start_active)
		_setup_panel(PimnetPanels.TRANSLATION, setup_resource.translation_enable,
				setup_resource.translation_start_active)
		_setup_panel(PimnetPanels.GOAL, setup_resource.goal_enable,
				setup_resource.goal_start_active)
		_setup_panel(PimnetPanels.PLAN, setup_resource.plan_enable,
				setup_resource.plan_start_active)

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


func show_completion_popup() -> void:
	%CompletionPopup.visible = true


func set_level_title_text(text: String) -> void:
	%LevelTitle.text = text


func _setup_panel(panel_type: PimnetPanels, enable: bool, start_active: bool
) -> void:
	var button := _get_button(panel_type)
	if not enable:
		button.visible = false
	if start_active:
		activate_panel(panel_type)


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
			return %GoalPanel
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


func _get_number_active_panels() -> int:
	var count := 0
	for panel_type in PANEL_TYPE_LIST:
		var panel := _get_panel(panel_type)
		if panel.visible:
			count += 1
	return count


# Calculate the amount of panels that would fit on the screen
func _get_maximum_active_panels() -> int:
	return 4


static func _do_not_set(_value: Variant) -> void:
	assert(false)
