##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Control

var _regular_background_color: Color
var _highlighted_background_color := GameGlobals.COLOR_HIGHLIGHT
@onready var _background := %Background as ColorRect
@onready var _label := %Label as Label


func _ready() -> void:
	_regular_background_color = _background.color


func set_text(text: String) -> void:
	_label.text = text


func set_highlight(set_on: bool) -> void:
	if set_on:
		_background.color = _highlighted_background_color
	else:
		_background.color = _regular_background_color
