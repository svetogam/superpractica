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

var _dimensions := Vector2(500, 500)
@onready var _graphic := %Graphic as ProceduralGraphic


func _on_field_ready() -> void:
	#Get this from the pim later
	input_shape.set_rect(_dimensions*2)
	_graphic.set_properties({"rect": get_board_rect()})
	_set_number_squares()


func _set_number_squares() -> void:
	var board_rect = get_board_rect()
	var square_size = get_square_size()
	var number = 0
	for row in range(10):
		for col in range(10):
			number += 1
			var square_x = board_rect.position.x + col * square_size.x + square_size.x/2
			var square_y = board_rect.position.y + row * square_size.y + square_size.y/2
			var square_position = Vector2(square_x, square_y)
			add_number_square(number, square_position)


func add_number_square(number: int, square_position: Vector2) -> NumberSquare:
	var number_square = field.create_object(CountingBoardGlobals.Objects.NUMBER_SQUARE)
	var square_size = get_square_size()
	number_square.setup(square_size, number)
	number_square.position = square_position
	return number_square


func get_board_rect() -> Rect2:
	return Rect2(Vector2.ZERO, _dimensions)


func get_square_size() -> Vector2:
	return get_board_rect().size/10
