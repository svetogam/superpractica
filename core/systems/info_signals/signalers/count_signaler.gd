# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CountSignaler
extends InfoSignaler

var count: int = 0
var current_signal: InfoSignal


func count_next(pos: Vector2, increment: int = 1) -> InfoSignal:
	count += increment
	if current_signal != null:
		current_signal.erase("out_slow_fade")
	current_signal = popup_number(count, pos, "in_pop")
	return current_signal


func count_object(object: Node2D, increment: int = 1) -> InfoSignal:
	return count_next(object.position, increment)


func reset_count() -> void:
	count = 0
	if current_signal != null:
		current_signal.erase("out_slow_fade")
		current_signal = null
