# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name AutoCountProgram
extends FieldProgram

signal completed(last_count_object: NumberSignal)

@export var delay := 0.5
var items: Array
var _last_count_object: NumberSignal
var _items_counted: int


func _ready() -> void:
	$StateChart.set_expression_property("delay", delay)


# Virtual
func _count_next(_counted: int) -> NumberSignal:
	return null


# Virtual
func _count_zero() -> NumberSignal:
	return null


func run() -> void:
	_items_counted = 0
	if items.is_empty():
		$StateChart.send_event.call_deferred("run_zero")
	else:
		$StateChart.send_event.call_deferred("run_count")


func _on_count_state_entered() -> void:
	assert(items.size() > 0)

	_last_count_object = _count_next(_items_counted)
	_items_counted += 1


func _on_count_zero_state_entered() -> void:
	assert(items.is_empty())

	_last_count_object = _count_zero()


func _on_check_state_entered() -> void:
	if _items_counted == items.size():
		completed.emit(_last_count_object)
		$StateChart.send_event("stop")
	else:
		$StateChart.send_event("count_next")
