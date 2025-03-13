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
const NormalLabelSettings := preload("memo_normal_label_settings.tres")
const HintLabelSettings := preload("memo_hint_label_settings.tres")
@export var acceptable_types: Array[String]
@export var memo_input_enabled := true:
	set(value):
		memo_input_enabled = value
		queue_redraw()
@export var memo_output_enabled := true:
	set(value):
		memo_output_enabled = value
		queue_redraw()
var memo: Memo
var pimnet: Pimnet
var accept_condition := Callable()
var value:
	get:
		assert(memo != null)
		return memo.value
var self_dragging := false:
	set(value):
		self_dragging = value
		queue_redraw()
var other_dragging := false:
	set(value):
		other_dragging = value
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
var hinting := false:
	set(value):
		if value == true:
			%Label.label_settings = HintLabelSettings
		else:
			%Label.label_settings = NormalLabelSettings


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)

	# Determine frame
	var frame_box: StyleBox
	if memo_input_enabled and memo_output_enabled:
		frame_box = get_theme_stylebox("frame_in_out")
	elif memo_input_enabled and not memo_output_enabled:
		frame_box = get_theme_stylebox("frame_in")
	elif not memo_input_enabled and memo_output_enabled:
		frame_box = get_theme_stylebox("frame_out")
	elif not memo_input_enabled and not memo_output_enabled:
		frame_box = get_theme_stylebox("frame_static")

	# Determine background
	var bg_rect := Rect2(
		frame_box.texture_margin_left,
		frame_box.texture_margin_top,
		rect.size.x - frame_box.texture_margin_left - frame_box.texture_margin_right,
		rect.size.y - frame_box.texture_margin_top - frame_box.texture_margin_bottom
	)
	var back_color: Color
	if self_dragging:
		back_color = get_theme_color("dragging")
	elif accepting_drag and hovering and other_dragging:
		back_color = get_theme_color("accepting")
	elif accepting_drag and not hovering and other_dragging:
		back_color = get_theme_color("pre_accepting")
	elif memo_output_enabled and hovering and not other_dragging:
		back_color = get_theme_color("pre_drag")
	elif suggestion == Game.SuggestiveSignals.AFFIRM:
		back_color = get_theme_color("affirming")
	elif suggestion == Game.SuggestiveSignals.WARN:
		back_color = get_theme_color("warning")
	elif suggestion == Game.SuggestiveSignals.REJECT:
		back_color = get_theme_color("warning")
	else:
		back_color = get_theme_color("normal")

	# Draw
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


func _on_mouse_entered() -> void:
	hovering = true


func _on_mouse_exited() -> void:
	hovering = false


func _get_drag_data(_position: Vector2) -> Memo:
	if memo_output_enabled and memo != null:
		pimnet.start_memo_drag(memo)
		self_dragging = true
		return memo
	return null


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Memo and would_accept_memo(data)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	assert(data != null)
	assert(data is Memo)

	set_by_memo(data)


func _on_memo_drag_started(p_memo: Memo) -> void:
	assert(p_memo != null)

	if not self_dragging:
		other_dragging = true
		if memo_input_enabled and would_accept_memo(p_memo):
			accepting_drag = true


func _on_memo_drag_ended(_p_memo: Memo) -> void:
	self_dragging = false
	other_dragging = false
	accepting_drag = false


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
	hinting = false


func set_by_memo(p_memo: Memo, bypass_hooks := false) -> void:
	var new_memo: Memo = p_memo.duplicate()
	_accept_memo(new_memo, bypass_hooks)
	hinting = false


func set_memo_as_hint(memo_type: GDScript, p_value: Variant) -> void:
	set_memo(memo_type, p_value, true)
	hinting = true


func set_text(text: String) -> void:
	%Label.text = text


func set_text_as_hint(text: String) -> void:
	%Label.text = text
	hinting = true


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
