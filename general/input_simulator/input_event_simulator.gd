##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name InputEventSimulator
extends Node

signal done
signal interference_detected(interfering_events)

var _events := []
var _got_events := []
var _running := false
var _frame := 0
var _reset_on_finish: bool
var _ignoring_interference := true


func add_event(event: InputEvent) -> void:
	_events.append(event)


func run(p_reset_on_finish:=true) -> void:
	assert(not _events.is_empty())
	_running = true
	_reset_on_finish = p_reset_on_finish


func reset() -> void:
	_stop()
	_events.clear()
	_got_events.clear()


func _stop() -> void:
	_running = false
	_frame = 0


func ignore_interference(ignore:=true) -> void:
	_ignoring_interference = ignore


static func get_interference_message(events: Array, max_events: int =3) -> String:
	var message_start := ("The first few interfering input events are:")
	var message_list := ""
	var i := 0
	for event in events:
		message_list += " "
		message_list += event.as_text()
		i += 1
		if i >= max_events:
			break
	return message_start + message_list


func _physics_process(_delta: float) -> void:
	if _running:
		assert(_frame < _events.size())
		_simulate_next_input()
		_frame += 1
		if _frame == _events.size():
			if not _ignoring_interference:
				_check_interference()
			if _reset_on_finish:
				reset()
			else:
				_stop()
			done.emit()


func _simulate_next_input() -> void:
	var event = _events[_frame]
	Input.parse_input_event(event)


func _check_interference() -> void:
	if _events.size() < _got_events.size():
		var interfering_events = get_interfering_events()
		interference_detected.emit(interfering_events)


func get_interfering_events() -> Array:
	var interfering_events = []
	for got_event in _got_events:
		var was_expected = false
		for expected_event in _events:
			if expected_event.as_text() == got_event.as_text():
				was_expected = true
		if not was_expected:
			interfering_events.append(got_event)
	return interfering_events


func _input(event: InputEvent) -> void:
	_got_events.append(event)
