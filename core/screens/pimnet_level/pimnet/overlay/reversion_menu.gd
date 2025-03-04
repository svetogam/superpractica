#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Control

signal undo_pressed
signal redo_pressed
signal reset_pressed

@onready var enabler := $ButtonEnabler as Node


func _ready() -> void:
	enabler.add_button("undo", %UndoButton)
	enabler.add_button("redo", %RedoButton)
	enabler.add_button("reset", %ResetButton)


func _on_undo_button_pressed() -> void:
	undo_pressed.emit()


func _on_redo_button_pressed() -> void:
	redo_pressed.emit()


func _on_reset_button_pressed() -> void:
	reset_pressed.emit()
