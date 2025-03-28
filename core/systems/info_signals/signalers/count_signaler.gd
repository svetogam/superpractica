# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CountSignaler
extends InfoSignaler

var _count: int = 0


func count_next(pos: Vector2) -> InfoSignal:
	_count += 1
	return popup_number(_count, pos)


func popup_current_count(pos: Vector2) -> InfoSignal:
	return popup_number(_count, pos)


func remove_last_count() -> void:
	assert(_count != 0)

	var last_count := get_highest_count_object()
	last_count.erase()
	_count -= 1


func reset_count() -> void:
	_count = 0
	clear()


func get_count() -> int:
	return _count


func get_highest_count_object() -> InfoSignal:
	assert(not get_children().is_empty())

	return get_children().back()
