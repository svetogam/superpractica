# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const SLIDE_DURATION := 0.2


func _enter(_last_state: String) -> void:
	get_tree().paused = true
	%ModalBarrier.show()
	%ModalBarrier.gui_input.connect(_on_modal_barrier_gui_input)

	%SystemPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", 0, SLIDE_DURATION)


func _on_modal_barrier_gui_input(event: InputEvent) -> void:
	if event.is_action("primary_mouse"):
		_transition_to_normal()


func _transition_to_normal() -> void:
	get_tree().paused = false
	%ModalBarrier.hide()
	%ModalBarrier.gui_input.disconnect(_on_modal_barrier_gui_input)

	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", -%SystemPanel.size.y, SLIDE_DURATION)
	tween.tween_callback(_change_state.bind("Normal"))


func _exit(_next_state: String) -> void:
	%SystemPanel.hide()
