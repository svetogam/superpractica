# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const SLIDE_DURATION := 0.3
const BACKGROUND_COLOR := Color(0.25, 0.25, 0.25, 0.5)


func _enter(_last_state: String) -> void:
	_target.level_data_unloaded.connect(_transition_to_normal)

	%ModalBarrier.color = BACKGROUND_COLOR
	%ModalBarrier.show()
	%ModalBarrier.gui_input.connect(_on_modal_barrier_gui_input)

	%PanelLayoutButtons.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%PanelLayoutButtons,
		"position:y",
		Game.get_screen_rect().end.y - %PanelLayoutButtons.size.y,
		SLIDE_DURATION
	)
	tween.parallel().tween_property(
		%BottomPanels,
		"position:y",
		Game.get_screen_rect().end.y - %PanelLayoutButtons.size.y - %BottomPanels.size.y,
		SLIDE_DURATION
	)


func _on_modal_barrier_gui_input(event: InputEvent) -> void:
	if event.is_action("primary_mouse"):
		_transition_to_normal()


func _transition_to_normal() -> void:
	%ModalBarrier.hide()
	%ModalBarrier.gui_input.disconnect(_on_modal_barrier_gui_input)

	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		%PanelLayoutButtons,
		"position:y",
		Game.get_screen_rect().end.y,
		SLIDE_DURATION
	)
	tween.parallel().tween_property(
		%BottomPanels,
		"position:y",
		Game.get_screen_rect().end.y - %BottomPanels.size.y,
		SLIDE_DURATION
	)
	tween.tween_callback(_change_state.bind("Normal"))


func _exit(_next_state: String) -> void:
	%PanelLayoutButtons.hide()

	_target.level_data_unloaded.disconnect(_transition_to_normal)
