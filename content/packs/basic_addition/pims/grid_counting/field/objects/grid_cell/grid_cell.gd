# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCell
extends FieldObject

static var _number_font := ThemeDB.fallback_font
var number: int:
	set(value):
		number = value
		queue_redraw()
var marked := false
var size: Vector2:
	get:
		return %Collider.shape.get_rect().size
var unit: FieldObject:
	get:
		return field.dynamic_model.get_unit(number)


static func _get_object_type() -> int:
	return GridCounting.Objects.GRID_CELL


func _draw() -> void:
	draw_string(
		_number_font,
		Vector2(-18.0, 6.0), # Some unknown relation to size, font, and font_size
		str(number),
		HORIZONTAL_ALIGNMENT_CENTER,
		35.0, # Should equal size.x
		16,
		Color.BLACK
	)


# First row and column are 0
func setup(p_number: int, row: int, col: int) -> void:
	position = Vector2(col * size.x + size.x/2, row * size.y + size.y/2)
	number = p_number


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
