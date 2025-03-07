# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SoftLimiterProgram
extends FieldProgram

var _object_rules := {} # {object_type: [Callable, ...], ...}
var _object_outcomes := {} #{object_type: {"pass": Callable, "fail": Callable}, ...}


# Virtual
func _cache() -> void:
	pass


func _start() -> void:
	field.updated.connect(_run_rules)


func set_object_rule_results(object_type: int, pass_func: Callable, fail_func: Callable
) -> void:
	if not _object_outcomes.has(object_type):
		_object_outcomes[object_type] = {}
	_object_outcomes[object_type].pass = pass_func
	_object_outcomes[object_type].fail = fail_func


func add_object_rule(object_type: int, condition_func: Callable) -> void:
	if not _object_rules.has(object_type):
		_object_rules[object_type] = []
	_object_rules[object_type].append(condition_func)


func remove_object_rule(object_type: int, condition_func: Callable) -> void:
	if _object_rules.has(object_type):
		_object_rules[object_type].erase(condition_func)


func disallow_object(object_type: int) -> void:
	add_object_rule(object_type, _disallowed_object_rule)


func reallow_object(object_type: int) -> void:
	remove_object_rule(object_type, _disallowed_object_rule)


func is_valid() -> bool:
	_cache()

	for object_type in _object_outcomes.keys():
		for object in field.get_objects_by_type(object_type):
			var conditions = _object_rules.get(object_type, [])
			var results = Utils.call_callables(conditions, [object])
			var passes = results.all(func(a: bool): return a)
			if not passes:
				return false
	return true


func _run_rules() -> void:
	_cache()

	for object_type in _object_outcomes.keys():
		for object in field.get_objects_by_type(object_type):
			var conditions = _object_rules.get(object_type, [])
			var results = Utils.call_callables(conditions, [object])
			var passes = results.all(func(a: bool): return a)
			if passes:
				_object_outcomes[object_type].pass.call(object)
			else:
				_object_outcomes[object_type].fail.call(object)


func _pass_everything() -> void:
	for object_type in _object_outcomes.keys():
		for object in field.get_objects_by_type(object_type):
			_object_outcomes[object_type].pass.call(object)


func _end() -> void:
	_pass_everything()

	_object_rules.clear()
	_object_outcomes.clear()
	field.warning_effects.clear()
	field.updated.disconnect(_run_rules)


func _disallowed_object_rule(_object: FieldObject) -> bool:
	return false
