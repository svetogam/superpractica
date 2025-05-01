# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCell
extends FieldObject

var number: int
var marked := false
var size: Vector2:
	get:
		return %Collider.shape.get_rect().size
var unit: FieldObject:
	get:
		return field.dynamic_model.get_unit(number)


static func _get_object_type() -> int:
	return GridCounting.Objects.GRID_CELL


# First row and column are 0
func setup(p_number: int, row: int, col: int) -> void:
	position = Vector2(col * size.x + size.x/2, row * size.y + size.y/2)
	number = p_number
	%Label.text = str(number)


func get_rect() -> Rect2:
	return Rect2(-size.x/2, -size.y/2, size.x, size.y)


func set_ring_variant(variant: String) -> void:
	assert(%RingSprite.sprite_frames.has_animation(variant))
	%RingSprite.animation = variant


func toggle_mark() -> void:
	marked = not marked
	if marked:
		%RingSprite.show()
	else:
		%RingSprite.hide()


func get_memo() -> IntegerMemo:
	return IntegerMemo.new(number)


func has_unit() -> bool:
	return unit != null


func has_point(point: Vector2) -> bool:
	var rect = Rect2(position - size / 2, size)
	return rect.has_point(point)
