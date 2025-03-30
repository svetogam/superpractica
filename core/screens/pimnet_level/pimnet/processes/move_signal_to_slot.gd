# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ProcessMoveSignalToSlot
extends Process

const TWEEN_TIME := 1.0
const SLOT_PADDING := 2.0
var pimnet: Pimnet
var info_signal: InfoSignal
var slot: MemoSlot


func _init(p_info_signal: InfoSignal, p_slot: MemoSlot) -> void:
	info_signal = p_info_signal
	slot = p_slot


func _enter_tree() -> void:
	pimnet = get_parent() as Pimnet
	assert(pimnet != null)


func _ready() -> void:
	# Calculate new position
	var slot_position = slot.get_global_rect().get_center()
	var dest_position = pimnet.overlay_position_to_effect_layer(slot_position)

	# Calculate new scale
	var slot_size = slot.get_content_rect(SLOT_PADDING).size
	var signal_size = info_signal.get_base_size()
	var growth_ratio = minf(slot_size.x / signal_size.x, slot_size.y / signal_size.y)
	var dest_scale = Vector2(growth_ratio, growth_ratio)

	# Tween to new position and scale
	var tween_time := TWEEN_TIME * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(info_signal, "global_position", dest_position, tween_time)
	tween.parallel().tween_property(info_signal, "scale", dest_scale, tween_time)
	tween.tween_callback(complete)
