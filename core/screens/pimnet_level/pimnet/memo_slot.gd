# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

@tool # For drawing previews only
class_name MemoSlot
extends Control

signal memo_accepted(memo)
signal memo_changed(memo)

const REGULAR_FONT_COLOR := Color.BLACK
const FADED_FONT_COLOR := Color.SLATE_GRAY
const MemoDragPreview := preload("memo_drag_preview.tscn")
@export var acceptable_types: Array[String]
@export var memo_input_enabled := true
@export var memo_output_enabled := true
var memo: Memo
var pimnet: Pimnet
var accept_condition := Callable()
var value:
	get:
		assert(memo != null)
		return memo.value
var dragging := false:
	set(value):
		dragging = value
		queue_redraw()
var hovering := false:
	set(value):
		hovering = value
		queue_redraw()
var accepting_drag := false:
	set(value):
		accepting_drag = value
		queue_redraw()
var suggestion := Game.SuggestiveSignals.NONE:
	set(value):
		suggestion = value
		queue_redraw()
@onready var _label := %Label as Label


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	var frame_box := get_theme_stylebox("frame")
	var bg_rect := Rect2(
		frame_box.texture_margin_left,
		frame_box.texture_margin_top,
		rect.size.x - frame_box.texture_margin_left - frame_box.texture_margin_right,
		rect.size.y - frame_box.texture_margin_top - frame_box.texture_margin_bottom
	)
	var back_color: Color
	if dragging:
		back_color = get_theme_color("dragging")
	elif accepting_drag and hovering:
		back_color = get_theme_color("accepting")
	elif accepting_drag and not hovering:
		back_color = get_theme_color("pre_accepting")
	elif memo_output_enabled and hovering:
		back_color = get_theme_color("pre_drag")
	elif suggestion == Game.SuggestiveSignals.AFFIRM:
		back_color = get_theme_color("affirming")
	elif suggestion == Game.SuggestiveSignals.WARN:
		back_color = get_theme_color("warning")
	elif suggestion == Game.SuggestiveSignals.REJECT:
		back_color = get_theme_color("warning")
	else:
		back_color = get_theme_color("normal")

	draw_rect(bg_rect, back_color)
	draw_style_box(frame_box, rect)


func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		CSConnector.with(self).register(Game.AGENT_MEMO_SLOT)
		CSLocator.with(self).connect_service_found(Game.SERVICE_PIMNET, _on_pimnet_found)


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

		dragging = true
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


func set_memo(memo_type: GDScript, p_value: Variant, bypass_hooks := false) -> void:
	var new_memo: Memo = memo_type.new()
	new_memo.set_by_value(p_value)
	_accept_memo(new_memo, bypass_hooks)
	_set_faded(false)


func set_by_memo(p_memo: Memo, bypass_hooks := false) -> void:
	var new_memo: Memo = p_memo.duplicate()
	_accept_memo(new_memo, bypass_hooks)
	_set_faded(false)


func set_memo_as_hint(memo_type: GDScript, p_value: Variant) -> void:
	set_memo(memo_type, p_value, true)
	_set_faded()


func set_text(text: String) -> void:
	_label.text = text


func set_text_as_hint(text: String) -> void:
	_label.text = text
	_set_faded()


func set_no_memo_with_text(text: String) -> void:
	memo = null
	set_text(text)


func set_empty() -> void:
	set_no_memo_with_text("")


func is_empty() -> bool:
	return memo == null


func _accept_memo(new_memo: Memo, bypass_hooks := false) -> void:
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

	if not bypass_hooks:
		memo_accepted.emit(memo)


func _on_memo_drag_started(p_memo: Memo) -> void:
	assert(p_memo != null)

	if memo_input_enabled and would_accept_memo(p_memo):
		accepting_drag = true


func _on_memo_drag_ended(_p_memo: Memo) -> void:
	dragging = false
	accepting_drag = false


func set_input_output_ability(input: bool, output: bool) -> void:
	memo_input_enabled = input
	memo_output_enabled = output


func _set_faded(faded := true) -> void:
	%Label.label_settings = %Label.label_settings.duplicate()
	if faded:
		%Label.label_settings.font_color = FADED_FONT_COLOR
	else:
		%Label.label_settings.font_color = REGULAR_FONT_COLOR


func _on_mouse_entered() -> void:
	hovering = true


func _on_mouse_exited() -> void:
	hovering = false
