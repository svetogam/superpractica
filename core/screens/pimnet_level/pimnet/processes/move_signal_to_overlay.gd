# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ProcessMoveSignalToOverlay
extends Process

const MOVE_TIME := 1.0
var pimnet: Pimnet
var info_signal: InfoSignal
var overlay_destination: Vector2


func _init(p_info_signal: InfoSignal, p_overlay_destination: Vector2) -> void:
	info_signal = p_info_signal
	overlay_destination = p_overlay_destination


func _enter_tree() -> void:
	pimnet = get_parent() as Pimnet
	assert(pimnet != null)


func _ready() -> void:
	var global_dest = pimnet.overlay_position_to_effect_layer(overlay_destination)
	var move_time := MOVE_TIME * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(info_signal, "global_position", global_dest, move_time)
	tween.tween_callback(complete)
