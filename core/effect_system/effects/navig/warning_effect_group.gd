#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name WarningEffectGroup
extends NavigEffectGroup

signal warned
signal unwarned

var _staged_warning_positions: Array = []
var _current_warning_positions: Array = []
var _positions_to_warnings: Dictionary # {Vector2: ScreenEffect}


func stage_warning(p_position: Vector2) -> void:
	_staged_warning_positions.append(p_position)


func flush_stage() -> void:
	# Add new warnings
	for warning_position in _staged_warning_positions:
		if not _current_warning_positions.has(warning_position):
			var warning := warn(warning_position)
			_positions_to_warnings[warning_position] = warning

	# Remove no longer used warnings
	for warning_position in _current_warning_positions:
		if not _staged_warning_positions.has(warning_position):
			var warning = _positions_to_warnings[warning_position]
			warning.free()
			_positions_to_warnings.erase(warning_position)

	# Emit signal if status has changed
	var previously_warning = not _current_warning_positions.is_empty()
	var newly_warning = not _staged_warning_positions.is_empty()
	if newly_warning and not previously_warning:
		warned.emit()
	elif not newly_warning and previously_warning:
		unwarned.emit()

	# Prepare for staging again
	_current_warning_positions.assign(_staged_warning_positions)
	_staged_warning_positions.clear()


func clear() -> void:
	super()
	_staged_warning_positions.clear()
	_current_warning_positions.clear()
	_positions_to_warnings.clear()


func is_stage_empty() -> bool:
	return _staged_warning_positions.is_empty()
