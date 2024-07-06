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
extends Control

signal memo_accepted(memo)
signal memo_changed(memo)

enum HighlightTypes {
	REGULAR,
	ACCEPTING,
	WARNING,
}

const REGULAR_FONT_COLOR := Color.BLACK
const FADED_FONT_COLOR := Color.SLATE_GRAY
const REGULAR_BACKGROUND_COLOR := Color.WHITE
const ACCEPTING_BACKGROUND_COLOR := GameGlobals.COLOR_HIGHLIGHT
const WARNING_BACKGROUND_COLOR := Color.GRAY
const MemoDragPreview := preload("memo_drag_preview.tscn")
@export var acceptable_types: Array[String]
@export var memo_input_enabled := true
@export var memo_output_enabled := true
var memo: Memo
var pimnet: Pimnet
var accept_condition := Callable()
@onready var _background := %Background as ColorRect
@onready var _label := %Label as Label


func _enter_tree() -> void:
	ContextualConnector.register(self)
	CSLocator.with(self).connect_service_found(
			GameGlobals.SERVICE_PIMNET, _on_pimnet_found)


func _on_pimnet_found(p_pimnet: Pimnet) -> void:
	pimnet = p_pimnet
	pimnet.memo_drag_started.connect(_on_memo_drag_started)
	pimnet.memo_drag_ended.connect(_on_memo_drag_ended)


func _get_drag_data(_position: Vector2) -> Memo:
	if memo_output_enabled and memo != null:
		# Use workaround because Godot's drag previews are bugged
		#var preview = make_memo_preview(memo)
		#set_drag_preview(preview)
		var preview = make_memo_preview_2(memo)

		pimnet.start_memo_drag(preview, memo)
		return memo
	return null


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Memo and would_accept_memo(data)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	assert(data != null)
	assert(data is Memo)

	set_by_memo(data)


# Godot's drag previews are bugged
#func make_memo_preview(p_memo: Memo) -> Control:
	#var preview := ColorRect.new()
	#preview.color = Color(0.6, 0.6, 0.9, 0.5)
	#preview.custom_minimum_size = Vector2(120.0, 80.0)
	#preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#var preview_label := Label.new()
	#preview_label.text = p_memo.get_string()
	#preview_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#preview_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#preview_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	#preview.add_child(preview_label)
	#return preview


func make_memo_preview_2(p_memo: Memo) -> Control:
	var preview := MemoDragPreview.instantiate()
	pimnet.dragged_object_layer.add_child(preview)
	preview.label.text = p_memo.get_string()
	return preview


func take_memo(p_memo: Memo) -> void:
	if would_accept_memo(p_memo):
		set_by_memo(p_memo)


func would_accept_memo(p_memo: Memo) -> bool:
	assert(p_memo != null)
	if memo_input_enabled:
		if accept_condition.is_null() or accept_condition.call(p_memo):
			var memo_type := p_memo.get_class()
			return acceptable_types.size() == 0 or acceptable_types.has(memo_type)
	return false


func set_memo(memo_type: GDScript, value: Variant, bypass_hooks := false) -> void:
	var new_memo: Memo = memo_type.new()
	new_memo.set_by_value(value)
	_accept_memo(new_memo, bypass_hooks)


func set_by_memo(p_memo: Memo, bypass_hooks := false) -> void:
	var new_memo: Memo = p_memo.duplicate()
	_accept_memo(new_memo, bypass_hooks)


func set_text(text: String) -> void:
	_label.text = text


func set_no_memo_with_text(text: String) -> void:
	memo = null
	set_text(text)


func set_empty() -> void:
	set_no_memo_with_text("")


func is_empty() -> bool:
	return memo == null


func set_highlight(highlight_type: int) -> void:
	match highlight_type:
		HighlightTypes.REGULAR:
			_background.color = REGULAR_BACKGROUND_COLOR
		HighlightTypes.ACCEPTING:
			_background.color = ACCEPTING_BACKGROUND_COLOR
		HighlightTypes.WARNING:
			_background.color = WARNING_BACKGROUND_COLOR


func _accept_memo(new_memo: Memo, bypass_hooks := false) -> void:
	if not bypass_hooks:
		memo_accepted.emit(memo)

	var same: bool = (
		(memo == null and new_memo == null)
		or (memo != null and new_memo != null
				and memo.get_value() == new_memo.get_value())
	)
	if not same:
		memo = new_memo
		set_text(memo.get_string())
		if not bypass_hooks:
			memo_changed.emit(memo)


func _on_memo_drag_started(p_memo: Memo) -> void:
	assert(p_memo != null)
	if memo_input_enabled and would_accept_memo(p_memo):
		set_highlight(HighlightTypes.ACCEPTING)


func _on_memo_drag_ended(_p_memo: Memo) -> void:
	if _background.color == ACCEPTING_BACKGROUND_COLOR:
		set_highlight(HighlightTypes.REGULAR)


func set_input_output_ability(input: bool, output: bool) -> void:
	memo_input_enabled = input
	memo_output_enabled = output


func set_faded(faded := true) -> void:
	%Label.label_settings = %Label.label_settings.duplicate()
	if faded:
		%Label.label_settings.font_color = FADED_FONT_COLOR
	else:
		%Label.label_settings.font_color = REGULAR_FONT_COLOR
