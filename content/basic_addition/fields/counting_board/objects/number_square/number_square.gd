##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name NumberSquare
extends FieldObject

var number: int
var circled := false
var highlighted := false
var _size: Vector2
@onready var _label := %Label as Label
@onready var _circled_graphic := %CircledGraphic as ProceduralGraphic
@onready var _highlight_graphic := %HighlightGraphic as ProceduralGraphic


func setup(p_size: Vector2, p_number: int) -> void:
	_size = p_size
	number = p_number
	_label.size = _size
	_label.text = str(number)
	input_shape.set_rect(_size)
	_circled_graphic.set_properties({"rect": get_rect()})
	_highlight_graphic.set_properties({"rect": get_rect()})


func get_rect() -> Rect2:
	return Rect2(-_size.x/2, -_size.y/2, _size.x, _size.y)


func toggle_circle() -> void:
	circled = not circled
	if circled:
		_circled_graphic.show()
	else:
		_circled_graphic.hide()


func set_circle_variant(variant: String) -> void:
	_circled_graphic.set_properties({"variant": variant})


func toggle_highlight() -> void:
	highlighted = not highlighted
	if highlighted:
		_highlight_graphic.show()
	else:
		_highlight_graphic.hide()


func get_memo() -> IntegerMemo:
	return IntegerMemo.new(number)


func has_counter() -> bool:
	return field.queries.get_number_squares_with_counters().has(self)


func get_counter() -> FieldObject:
	return field.queries.get_counter_on_square(self)
