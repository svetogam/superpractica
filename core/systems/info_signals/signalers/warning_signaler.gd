# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name WarningSignaler
extends InfoSignaler
## An [InfoSignaler] specialized for giving warnings.
##
## Regular usage is the following:
## [br][br]
## [b]1.[/b] Call [method stage_warning] for everything that should give warnings.
## [br]
## [b]2.[/b] Call [method flush_stage] to update warnings.
## [br]
## [b]3.[/b] React to [signal warned] and [signal unwarned] being
## emitted when warning status changes between flushes.

## Emitted upon calling [method flush_stage] if there were no warnings
## at previous flush and there are some warnings now.
signal warned
## Emitted upon calling [method flush_stage] if there were some warnings
## at previous flush and there are no warnings now.
signal unwarned

var _staged_warning_positions: Array = []
var _current_warning_positions: Array = []
var _positions_to_warnings: Dictionary # {Vector2: InfoSignal}


## Prepare to give a warning at [param p_position] the next time
## [method flush_stage] is called.
func stage_warning(p_position: Vector2) -> void:
	_staged_warning_positions.append(p_position)


## Erase all past warnings and give new warnings prepared with
## [method stage_warning].
## Nothing happens to warnings prepared for both flushes.
## [br][br]
## Can emit [signal warned] or [signal unwarned].
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
			warning.erase()
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


## Clear all staged and current warnings.
func clear() -> void:
	super()
	_staged_warning_positions.clear()
	_current_warning_positions.clear()
	_positions_to_warnings.clear()
