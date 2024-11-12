#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCell
extends FieldObject

var number: int
var circled := false
var highlighted := false
var _size: Vector2:
	get:
		return %Collider.shape.get_rect().size
@onready var _circled_graphic := %CircledGraphic as ProceduralGraphic
@onready var _highlight_graphic := %HighlightGraphic as ProceduralGraphic


static func _get_object_type() -> int:
	return GridCounting.Objects.GRID_CELL


# First row and column are 0
func setup(p_number: int, row: int, col: int) -> void:
	position = Vector2(col * _size.x + _size.x/2, row * _size.y + _size.y/2)
	number = p_number
	%Label.text = str(number)
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


func has_unit() -> bool:
	return field.get_grid_cells_with_units().has(self)


func get_unit() -> FieldObject:
	return field.get_unit(number)


func has_point(point: Vector2) -> bool:
	var rect = Rect2(position - _size / 2, _size)
	return rect.has_point(point)
