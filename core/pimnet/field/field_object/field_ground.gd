##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name FieldGround
extends FieldObject

@onready var _color_rect := %ColorRect as ColorRect


func _on_field_ready() -> void:
	position = field.get_center()
	input_shape.set_rect(field.get_rect().size)
	_color_rect.position = -field.get_rect().size/2
	_color_rect.size = field.get_rect().size
