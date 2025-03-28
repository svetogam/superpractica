# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InfoSignaler
extends Node2D

const NEAR_OFFSET := Vector2(20, 15)
const AffirmScene := preload("uid://51v0feqeyjdr")
const RejectScene := preload("uid://dmg7uc5b3wqhc")
const WarningScene := preload("uid://dk3ojkrwuffyq")
const NumberScene := preload("uid://cobbyy58sstrk")
const EqualityScene = preload("uid://r2lr30ufuth5")
const InequalityScene = preload("uid://d3fuvg0owj4ty")


func affirm(pos: Vector2) -> InfoSignal:
	return _create_signal(AffirmScene, pos)


func reject(pos: Vector2) -> InfoSignal:
	return _create_signal(RejectScene, pos)


func warn(pos: Vector2) -> InfoSignal:
	return _create_signal(WarningScene, pos + NEAR_OFFSET)


func popup_number(number: int, pos: Vector2, animation := "in_rise") -> InfoSignal:
	var info_signal := _create_signal(NumberScene, pos)
	info_signal.number = number
	info_signal.anim_player.play(animation)
	return info_signal


func popup_equality(pos: Vector2) -> InfoSignal:
	return _create_signal(EqualityScene, pos)


func popup_inequality(pos: Vector2) -> InfoSignal:
	return _create_signal(InequalityScene, pos)


func clear() -> void:
	for child in get_children():
		child.free()


func _create_signal(signal_scene: PackedScene, pos: Vector2) -> InfoSignal:
	var info_signal := signal_scene.instantiate()
	add_child(info_signal)
	info_signal.position = pos
	return info_signal
