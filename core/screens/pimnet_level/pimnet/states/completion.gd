# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const SLIDE_DURATION := 0.5
const TARGET_Y := 150.0
const INITIAL_BACKGROUND_COLOR := Color(1.0, 1.0, 1.0, 0.0)
const TARGET_BACKGROUND_COLOR := Color(1.0, 1.0, 1.0, 0.5)


func _enter(_last_state: String) -> void:
	_target.level_data_unloaded.connect(_change_state.bind("Normal"))

	%ModalBarrier.color = INITIAL_BACKGROUND_COLOR
	%ModalBarrier.show()

	%CompletionNextButton.disabled = not _target.level_data.has_next_suggested_level()
	%CompletionPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CompletionPanel, "position:y", TARGET_Y, SLIDE_DURATION)
	tween.parallel().tween_property(
			%ModalBarrier, "color", TARGET_BACKGROUND_COLOR, SLIDE_DURATION)

	Game.request_load_level_select.emit()


func _exit(_next_state: String) -> void:
	%ModalBarrier.hide()
	%CompletionPanel.hide()
	%CompletionPanel.position.y = -%CompletionPanel.size.y

	_target.level_data_unloaded.disconnect(_change_state)
