##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends WindowContent

export(String, MULTILINE) var initial_text := "Instructions go here."
onready var _label := $"%Label"


func _ready() -> void:
	_label.text = initial_text


func clear() -> void:
	_label.text = ""


func set_text(new_text: String) -> void:
	_label.text = new_text
