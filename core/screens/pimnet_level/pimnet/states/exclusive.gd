#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends State

const SYSTEM_PANEL_Y_DEST := -300
const SYSTEM_PANEL_SLIDE_DURATION := 0.1


func _enter(_last_state: String) -> void:
	get_tree().paused = true
	%ModalBarrier.show()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(%SystemPanel, "position:y", 0, SYSTEM_PANEL_SLIDE_DURATION)


func _on_continue_button_pressed() -> void:
	_transition_to_normal()


func _on_modal_barrier_gui_input(event: InputEvent) -> void:
	if event.is_action("primary_mouse"):
		_transition_to_normal()


func _transition_to_normal() -> void:
	get_tree().paused = false
	%ModalBarrier.hide()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(
			%SystemPanel, "position:y", SYSTEM_PANEL_Y_DEST, SYSTEM_PANEL_SLIDE_DURATION)
	tween.tween_callback(_change_state.bind("Normal"))
