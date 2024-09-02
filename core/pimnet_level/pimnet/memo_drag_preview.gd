#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends ColorRect

@onready var label := %Label as Label


func _ready() -> void:
	global_position = get_global_mouse_position()


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	if not get_viewport().gui_is_dragging():
		queue_free()
