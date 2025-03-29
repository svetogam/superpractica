# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CountSignaler
extends InfoSignaler

var count: int = 0


func count_next(pos: Vector2) -> InfoSignal:
	count += 1
	return popup_number(count, pos)


func reset_count() -> void:
	count = 0
	clear()
