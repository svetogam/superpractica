# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control

const DEFAULT_SLIDE_DURATION := 0.2
@onready var back_button := %BackButton as BaseButton
@onready var system_button := %SystemButton as BaseButton


func _ready() -> void:
	%OverlayStateMachine.activate()


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
