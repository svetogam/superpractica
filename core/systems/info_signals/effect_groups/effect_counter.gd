# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name EffectCounter
extends ScreenEffectGroup

var _count: int = 0


func count_next(pos: Vector2) -> NumberEffect:
	_count += 1
	return give_number(_count, pos)


func give_current_count(pos: Vector2) -> NumberEffect:
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
