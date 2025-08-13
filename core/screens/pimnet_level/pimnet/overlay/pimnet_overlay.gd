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

const SYSTEM_MODAL_SLIDE_DURATION := 0.3
const PLAYTYPE_MODAL_SLIDE_DURATION := 0.3
const PLAN_MODAL_SLIDE_DURATION := 0.3
const LAYOUT_MODAL_SLIDE_DURATION := 0.3
const COMPLETION_MODAL_SLIDE_DURATION := 0.5
const REGULAR_MODAL_BACKGROUND_COLOR := Color(0.25, 0.25, 0.25, 0.5)
var level_type: LevelResource.LevelTypes:
	get:
		if level_data != null:
			return level_data.level_type
		return LevelResource.LevelTypes.NONE
var playtype_panel: Control:
	get:
		match level_type:
			LevelResource.LevelTypes.EXAMPLE_PRACTICE:
				return %PlaytypeExamplePanel
			LevelResource.LevelTypes.TRIAL_PRACTICE:
				return %PlaytypeTrialPanel
			_:
				return null
var goal_type: LevelResource.GoalTypes = LevelResource.GoalTypes.NONE:
	set = _set_goal_type
var goal_panel: GoalPanel:
	get = _get_goal_panel
var level_data: LevelResource
@onready var plan_panel := %PlanPanel as Control
@onready var pim_tools := %PimToolsPanel as Control
@onready var pim_objects := %PimObjectsPanel as Control
@onready var verification_panel := %SolutionVerificationPanel as Control


func _enter_tree() -> void:
	CSLocator.with(self).connect_service_changed(
		Game.SERVICE_LEVEL_DATA, _on_level_data_changed
	)


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
	%PimToolsButton.toggled.connect(_on_panel_button_toggled.bind(PimnetPanels.PIM_TOOLS))
	%PimObjectsButton.toggled.connect(
		_on_panel_button_toggled.bind(PimnetPanels.PIM_OBJECTS)
	)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)
	%CompletionSelectButton.pressed.connect(_on_completion_select_button_pressed)
	%CompletionNextButton.pressed.connect(_on_completion_next_button_pressed)
	%ModalBarrier.gui_input.connect(_on_modal_barrier_gui_input)
	level_data_unloaded.connect(_on_level_data_unloaded)


func _on_panel_button_toggled(toggled_on: bool, panel_type: PimnetPanels) -> void:
	var panel := _get_panel(panel_type)
	panel.visible = toggled_on


func _on_level_data_unloaded() -> void:
	$StateChart.send_event("close")


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


func _get_goal_panel() -> GoalPanel:
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


func _on_system_button_pressed() -> void:
	$StateChart.send_event("open_system_modal")


func _on_playtype_button_pressed() -> void:
	$StateChart.send_event("open_playtype_modal")


func _on_plan_button_pressed() -> void:
	$StateChart.send_event("open_plan_modal")


func _on_edit_panels_button_pressed() -> void:
	$StateChart.send_event("open_layout_modal")


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


func _on_modal_barrier_gui_input(event: InputEvent) -> void:
	if (
		event.is_action("primary_mouse")
		and not $StateChart/States/Modal/Completion.active
	):
		$StateChart.send_event("close")


func _on_gui_normal_state_entered() -> void:
	%SystemButton.pressed.connect(_on_system_button_pressed)
	%PlaytypeExampleButton.pressed.connect(_on_playtype_button_pressed)
	%PlaytypeTrialButton.pressed.connect(_on_playtype_button_pressed)
	%PlanButton.pressed.connect(_on_plan_button_pressed)
	%EditPanelsButton.pressed.connect(_on_edit_panels_button_pressed)

	%SystemPanel.hide()
	%PlanPanel.hide()
	%PanelLayoutButtons.hide()
	%CompletionPanel.hide()


func _on_gui_normal_state_exited() -> void:
	%SystemButton.pressed.disconnect(_on_system_button_pressed)
	%PlaytypeExampleButton.pressed.disconnect(_on_playtype_button_pressed)
	%PlaytypeTrialButton.pressed.disconnect(_on_playtype_button_pressed)
	%PlanButton.pressed.disconnect(_on_plan_button_pressed)
	%EditPanelsButton.pressed.disconnect(_on_edit_panels_button_pressed)


func _on_gui_opening_state_entered() -> void:
	%ModalBarrier.show()


func _on_gui_modal_state_entered() -> void:
	if $StateChart/States/Modal/System.active:
		Game.request_load_level_select.emit()
	elif $StateChart/States/Modal/Completion.active:
		Game.request_load_level_select.emit()


func _on_gui_closing_state_entered() -> void:
	%ModalBarrier.hide()


func _on_modal_system_state_entered() -> void:
	get_tree().paused = true
	%ModalBarrier.color = REGULAR_MODAL_BACKGROUND_COLOR
	%SystemPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", 0, SYSTEM_MODAL_SLIDE_DURATION)

	$StateChart.set_expression_property("slide_duration", SYSTEM_MODAL_SLIDE_DURATION)
	$StateChart.send_event("open")


func _on_modal_system_state_exited() -> void:
	get_tree().paused = false
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%SystemPanel, "position:y", -%SystemPanel.size.y, SYSTEM_MODAL_SLIDE_DURATION
	)

	$StateChart.set_expression_property("slide_duration", SYSTEM_MODAL_SLIDE_DURATION)


func _on_modal_playtype_state_entered() -> void:
	get_tree().paused = true
	%ModalBarrier.color = REGULAR_MODAL_BACKGROUND_COLOR
	playtype_panel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(playtype_panel, "position:y", 0, PLAYTYPE_MODAL_SLIDE_DURATION)

	$StateChart.set_expression_property("slide_duration", PLAYTYPE_MODAL_SLIDE_DURATION)
	$StateChart.send_event("open")


func _on_modal_playtype_state_exited() -> void:
	get_tree().paused = false
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		playtype_panel,
		"position:y",
		-playtype_panel.size.y,
		PLAYTYPE_MODAL_SLIDE_DURATION
	)

	$StateChart.set_expression_property("slide_duration", PLAYTYPE_MODAL_SLIDE_DURATION)


func _on_modal_plan_state_entered() -> void:
	get_tree().paused = true
	%ModalBarrier.color = REGULAR_MODAL_BACKGROUND_COLOR
	%PlanPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%PlanPanel, "position:x", 0, PLAN_MODAL_SLIDE_DURATION)

	$StateChart.set_expression_property("slide_duration", PLAN_MODAL_SLIDE_DURATION)
	$StateChart.send_event("open")


func _on_modal_plan_state_exited() -> void:
	get_tree().paused = false
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%PlanPanel, "position:x", -%PlanPanel.size.x, PLAN_MODAL_SLIDE_DURATION
	)

	$StateChart.set_expression_property("slide_duration", PLAN_MODAL_SLIDE_DURATION)


func _on_modal_layout_state_entered() -> void:
	get_tree().paused = true
	%ModalBarrier.color = REGULAR_MODAL_BACKGROUND_COLOR
	%PanelLayoutButtons.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%PanelLayoutButtons,
		"position:y",
		Game.get_screen_rect().end.y - %PanelLayoutButtons.size.y,
		LAYOUT_MODAL_SLIDE_DURATION
	)
	tween.parallel().tween_property(
		%BottomPanels,
		"position:y",
		Game.get_screen_rect().end.y - %PanelLayoutButtons.size.y - %BottomPanels.size.y,
		LAYOUT_MODAL_SLIDE_DURATION
	)

	$StateChart.set_expression_property("slide_duration", LAYOUT_MODAL_SLIDE_DURATION)
	$StateChart.send_event("open")


func _on_modal_layout_state_exited() -> void:
	get_tree().paused = false
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%PanelLayoutButtons,
		"position:y",
		Game.get_screen_rect().end.y,
		LAYOUT_MODAL_SLIDE_DURATION
	)
	tween.parallel().tween_property(
		%BottomPanels,
		"position:y",
		Game.get_screen_rect().end.y - %BottomPanels.size.y,
		LAYOUT_MODAL_SLIDE_DURATION
	)

	$StateChart.set_expression_property("slide_duration", LAYOUT_MODAL_SLIDE_DURATION)


func _on_modal_completion_state_entered() -> void:
	const target_y := 150.0
	const initial_background_color := Color(1.0, 1.0, 1.0, 0.0)
	const target_background_color := Color(1.0, 1.0, 1.0, 0.5)
	%ModalBarrier.color = initial_background_color
	%CompletionNextButton.disabled = not level_data.has_next_suggested_level()
	%CompletionPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%CompletionPanel, "position:y", target_y, COMPLETION_MODAL_SLIDE_DURATION
	)
	tween.parallel().tween_property(
		%ModalBarrier, "color", target_background_color, COMPLETION_MODAL_SLIDE_DURATION
	)

	$StateChart.set_expression_property("slide_duration", COMPLETION_MODAL_SLIDE_DURATION)
	$StateChart.send_event("open")


func _on_modal_completion_state_exited() -> void:
	%CompletionPanel.position.y = -%CompletionPanel.size.y
	$StateChart.set_expression_property("slide_duration", 0.0)
