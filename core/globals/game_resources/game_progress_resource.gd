# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GameProgressResource
extends Resource

var completed_levels: Array = []


func record_level_completion(level_id: String) -> void:
	if not completed_levels.has(level_id):
		completed_levels.append(level_id)


func is_level_completed(level_id: String) -> bool:
	return completed_levels.has(level_id)


func clear() -> void:
	completed_levels.clear()
