##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends WindowDialog

export(Vector2) var default_size := Vector2(320, 200)
onready var _stay_button := $"%StayButton"
onready var _level_select_button := $"%LevelSelectButton"
onready var _next_level_button := $"%NextLevelButton"


func appear() -> void:
	popup_centered(default_size)


func _on_StayButton_pressed() -> void:
	hide()


func _on_LevelSelectButton_pressed() -> void:
	Game.enter_level_select()


func _on_NextLevelButton_pressed() -> void:
	pass
