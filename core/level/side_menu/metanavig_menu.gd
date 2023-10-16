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

onready var enabler := $ButtonEnabler
onready var _button_map := {
	"undo": $"%UndoButton",
	"redo": $"%RedoButton",
	"reset": $"%ResetButton",
}


func _ready() -> void:
	_button_map["undo"].connect("pressed", self, "_on_undo_button_pressed")
	_button_map["redo"].connect("pressed", self, "_on_redo_button_pressed")
	_button_map["reset"].connect("pressed", self, "_on_reset_button_pressed")

	enabler.set_button_map(_button_map)


func _on_undo_button_pressed() -> void:
	emit_signal("undo_pressed")


func _on_redo_button_pressed() -> void:
	emit_signal("redo_pressed")


func _on_reset_button_pressed() -> void:
	emit_signal("reset_pressed")
