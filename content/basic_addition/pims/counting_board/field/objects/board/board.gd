#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObject

const BOARD_RECT := Rect2(0, 0, 350, 350)
@onready var _graphic := %Graphic as ProceduralGraphic


func _on_field_ready() -> void:
	_graphic.set_properties({"rect": BOARD_RECT})
	_set_number_squares()


func _set_number_squares() -> void:
	var square_size := get_square_size()
	var number: int = 0
	for row in range(10):
		for col in range(10):
			number += 1
			var square_x := (BOARD_RECT.position.x + col * square_size.x
					+ square_size.x/2)
			var square_y := (BOARD_RECT.position.y + row * square_size.y
					+ square_size.y/2)
			var square_position := Vector2(square_x, square_y)
			add_number_square(number, square_position)


func add_number_square(number: int, square_position: Vector2) -> NumberSquare:
	var number_square := CountingBoard.ObjectNumberSquare.instantiate() as NumberSquare
	field.add_child(number_square)
	var square_size := get_square_size()
	number_square.setup(square_size, number)
	number_square.position = square_position
	return number_square


func get_square_size() -> Vector2:
	return BOARD_RECT.size/10
