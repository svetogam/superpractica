# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends Mode

var started_value: int = 0
var ended_value: int = 0


func _start() -> void:
	started_value = _target.started_value


func _end() -> void:
	ended_value = _target.ended_value
