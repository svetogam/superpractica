##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldObject

var square: NumberSquare = null
@onready var _graphic := %Graphic as ProceduralGraphic


func put_on_square(p_square: NumberSquare) -> void:
	square = p_square
	position = square.position
	if square.is_mode_active("get_memo"):
		set_transparent()


func set_transparent(transparent:=true) -> void:
	_graphic.set_properties({"transparent": transparent})


func set_warning(warning:=true) -> void:
	_graphic.set_properties({"warning": warning})


func set_affirmation(affirm:=true) -> void:
	_graphic.set_properties({"affirmation": affirm})


func get_number() -> int:
	assert(square != null)
	return square.number


func get_drag_graphic() -> ProceduralGraphic:
	return _graphic
