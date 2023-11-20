##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends PanelContainer

signal undo_pressed
signal redo_pressed
signal reset_pressed

@onready var enabler := $ButtonEnabler as Node
@onready var _button_map := {
	"undo": %UndoButton as Button,
	"redo": %RedoButton as Button,
	"reset": %ResetButton as Button,
}


func _ready() -> void:
	_button_map["undo"].pressed.connect(_on_undo_button_pressed)
	_button_map["redo"].pressed.connect(_on_redo_button_pressed)
	_button_map["reset"].pressed.connect(_on_reset_button_pressed)

	enabler.set_button_map(_button_map)


func _on_undo_button_pressed() -> void:
	undo_pressed.emit()


func _on_redo_button_pressed() -> void:
	redo_pressed.emit()


func _on_reset_button_pressed() -> void:
	reset_pressed.emit()
