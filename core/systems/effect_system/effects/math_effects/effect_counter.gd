# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name EffectCounter
extends MathEffectGroup

const NEAR_OFFSET := Vector2(30, 20)
var _count: int = 0


func count_next(pos: Vector2, beside := false) -> NumberEffect:
	_count += 1
	if beside:
		return give_number(_count, pos + NEAR_OFFSET)
	else:
		return give_number(_count, pos)


func give_current_count(pos: Vector2, beside := false) -> NumberEffect:
	if beside:
		return give_number(_count, pos + NEAR_OFFSET)
	else:
		return give_number(_count, pos)


func remove_last_count() -> void:
	assert(_count != 0)

	var last_count := get_highest_count_object()
	last_count.free()
	_count -= 1


func reset_count() -> void:
	_count = 0
	clear()


func get_count() -> int:
	return _count


func get_highest_count_object() -> NumberEffect:
	assert(not get_effects().is_empty())

	return get_effects().back()
