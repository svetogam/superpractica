#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PopupPanel


func _on_stay_button_pressed() -> void:
	hide()


func _on_select_level_button_pressed() -> void:
	Game.call_deferred("enter_level_select")


func _on_next_level_button_pressed() -> void:
	pass
