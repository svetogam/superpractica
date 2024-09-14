#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Panel

signal topics_pressed
signal exit_pressed


func _ready() -> void:
	if OS.get_name() == "Web":
		%QuitButton.hide()


func _on_topics_button_pressed() -> void:
	topics_pressed.emit()


func _on_about_button_pressed() -> void:
	%AboutPopup.show()


func _on_quit_button_pressed() -> void:
	exit_pressed.emit()
