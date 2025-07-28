# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const DEFAULT_SLIDE_DURATION := 0.2
const SYSTEM_MODAL_SLIDE_DURATION := 0.3
const REGULAR_MODAL_BACKGROUND_COLOR := Color(0.25, 0.25, 0.25, 0.5)
@onready var back_button := %BackButton as BaseButton
@onready var system_button := %SystemButton as BaseButton


func _ready() -> void:
	%ModalBarrier.gui_input.connect(_on_modal_barrier_gui_input)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%ExitButton.pressed.connect(_on_exit_button_pressed)
	$StateChart.set_expression_property("slide_duration", SYSTEM_MODAL_SLIDE_DURATION)


func set_topic(topic_data: TopicResource) -> void:
	%TitleLabel.text = topic_data.title

	if topic_data.supertopic != null:
		back_button.show()
		back_button.text = topic_data.supertopic.title
	else:
		back_button.hide()


func slide_title_in(duration := DEFAULT_SLIDE_DURATION) -> void:
	_slide_title(0.0, duration)


func slide_title_out(duration := DEFAULT_SLIDE_DURATION) -> void:
	_slide_title(-%TitlePanel.size.y, duration)


func slide_back_button_in(duration := DEFAULT_SLIDE_DURATION) -> void:
	_slide_back_button(0.0, duration)


func slide_back_button_out(duration := DEFAULT_SLIDE_DURATION) -> void:
	_slide_back_button(-back_button.size.y, duration)


func _slide_title(dest_y: float, duration: float) -> void:
	if duration <= 0.0:
		%TitlePanel.position.y = dest_y
	else:
		var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(%TitlePanel, "position:y", dest_y, duration)


func _slide_back_button(dest_y: float, duration: float) -> void:
	if duration <= 0.0:
		back_button.position.y = dest_y
	else:
		var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(back_button, "position:y", dest_y, duration)


func _on_system_button_pressed() -> void:
	$StateChart.send_event("open_system_modal")


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	Game.request_enter_main_menu.emit()


func _on_modal_barrier_gui_input(event: InputEvent) -> void:
	if event.is_action("primary_mouse"):
		$StateChart.send_event("close")


func _on_gui_normal_state_entered() -> void:
	%SystemButton.pressed.connect(_on_system_button_pressed)
	%SystemPanel.hide()


func _on_gui_normal_state_exited() -> void:
	%SystemButton.pressed.disconnect(_on_system_button_pressed)


func _on_gui_opening_state_entered() -> void:
	%ModalBarrier.show()


func _on_gui_closing_state_entered() -> void:
	%ModalBarrier.hide()


func _on_modal_system_state_entered() -> void:
	%ModalBarrier.color = REGULAR_MODAL_BACKGROUND_COLOR
	%SystemPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", 0, SYSTEM_MODAL_SLIDE_DURATION)

	$StateChart.send_event("open")


func _on_modal_system_state_exited() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%SystemPanel, "position:y", -%SystemPanel.size.y, SYSTEM_MODAL_SLIDE_DURATION
	)
