#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name MemoSlot
extends WindowContent

signal memo_changed(memo)

@export var acceptable_types: Array[String]
@export var memo_input_enabled := true
@export var memo_output_enabled := true
var pimnet: Pimnet:
	set = _do_not_set,
	get = _get_pimnet
var memo: Memo
@onready var _drag_control := %DragControl as SuperscreenObject
@onready var _graphic := %Graphic as Control


func _enter_tree() -> void:
	ContextualConnector.register(self)

	pimnet.memo_drag_started.connect(_on_memo_drag_started)
	pimnet.memo_drag_stopped.connect(_on_memo_drag_stopped)


func _ready() -> void:
	taking_input = true
	_drag_control.setup(self)


func _superscreen_input(event: SuperscreenInputEvent) -> void:
	_drag_control.take_input(event)


func take_memo(p_memo: Memo) -> void:
	if would_accept_memo(p_memo):
		set_by_memo(p_memo)


func would_accept_memo(p_memo: Memo) -> bool:
	assert(p_memo != null)
	if acceptable_types.size() == 0:
		return memo_input_enabled
	else:
		var memo_type := p_memo.get_class()
		return memo_input_enabled and acceptable_types.has(memo_type)


func set_memo(memo_type: GDScript, value: Variant) -> void:
	memo = memo_type.new()
	memo.set_by_value(value)
	_accept_memo()


func set_by_memo(p_memo: Memo) -> void:
	memo = p_memo.duplicate()
	_accept_memo()


func _accept_memo() -> void:
	_graphic.set_text(memo.get_string())
	var prev_memo: Memo = null
	if memo != prev_memo:
		memo_changed.emit(memo)


func set_no_memo_with_text(text: String) -> void:
	memo = null
	_graphic.set_text(text)


func set_empty() -> void:
	set_no_memo_with_text("")


func is_empty() -> bool:
	return memo == null


func _on_memo_drag_started(p_memo: Memo) -> void:
	assert(p_memo != null)
	if memo_input_enabled and would_accept_memo(p_memo):
		_graphic.set_highlight(true)


func _on_memo_drag_stopped(_p_memo: Memo) -> void:
	_graphic.set_highlight(false)


func set_input_output_ability(input: bool, output: bool) -> void:
	memo_input_enabled = input
	memo_output_enabled = output


func _get_pimnet() -> Pimnet:
	return superscreen


static func _do_not_set(_value: Variant) -> void:
	assert(false)
