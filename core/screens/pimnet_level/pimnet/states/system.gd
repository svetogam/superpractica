# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const SLIDE_DURATION := 0.3
const BACKGROUND_COLOR := Color(0.25, 0.25, 0.25, 0.5)


func _enter(_last_state: String) -> void:
	_target.level_data_unloaded.connect(_transition_to_normal)

	get_tree().paused = true
	%ModalBarrier.color = BACKGROUND_COLOR
	%ModalBarrier.show()
	%ModalBarrier.gui_input.connect(_on_modal_barrier_gui_input)

	%SystemPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", 0, SLIDE_DURATION)
	tween.tween_callback(_on_panel_opened)


func _on_panel_opened() -> void:
	Game.request_load_level_select.emit()

	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_settings_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	Game.request_enter_level_select.emit()


func _on_modal_barrier_gui_input(event: InputEvent) -> void:
	if event.is_action("primary_mouse"):
		_transition_to_normal()


func _transition_to_normal() -> void:
	get_tree().paused = false
	%ModalBarrier.hide()
	%ModalBarrier.gui_input.disconnect(_on_modal_barrier_gui_input)
	%SettingsButton.pressed.disconnect(_on_settings_button_pressed)
	%QuitButton.pressed.disconnect(_on_quit_button_pressed)

	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", -%SystemPanel.size.y, SLIDE_DURATION)
	tween.tween_callback(_change_state.bind("Normal"))


func _exit(_next_state: String) -> void:
	%SystemPanel.hide()

	_target.level_data_unloaded.disconnect(_transition_to_normal)
