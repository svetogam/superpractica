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

onready var _color_rect := $"%ColorRect"


func _on_field_ready() -> void:
	position = field.get_center()
	input_shape.set_rect(field.get_rect().size)
	_color_rect.rect_position = -field.get_rect().size/2
	_color_rect.rect_size = field.get_rect().size
