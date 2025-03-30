# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ProcessMoveSignalToSlot
extends Process

const MOVE_TIME := 1.0
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
	var slot_position = slot.get_global_rect().get_center()
	var global_dest = pimnet.overlay_position_to_effect_layer(slot_position)
	var move_time := MOVE_TIME * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(info_signal, "global_position", global_dest, move_time)
	tween.tween_callback(complete)
