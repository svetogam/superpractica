##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SubscreenInputEvent
extends SpInputEvent


func _init(p_input_type: int, p_position: Vector2, p_relative: Vector2,
			p_grabbed_object: InputObject, p_input_state: int) -> void:
	_input_type = p_input_type
	_position = p_position
	_relative = p_relative
	_grabbed_object = p_grabbed_object
	_input_state = p_input_state
