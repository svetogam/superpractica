# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InfoSignaler
extends Node2D

const NEAR_OFFSET := Vector2(20, 15)
const DEFAULT_DELETE_DELAY := 1.0
const AffirmScene := preload("uid://51v0feqeyjdr")
const RejectScene := preload("uid://dmg7uc5b3wqhc")
const WarningScene := preload("uid://dk3ojkrwuffyq")
const NumberScene := preload("uid://cobbyy58sstrk")


func create_signal(signal_scene: PackedScene, pos: Vector2) -> InfoSignal:
	var info_signal := signal_scene.instantiate()
	add_child(info_signal)
	info_signal.position = pos
	return info_signal


func affirm_or_else_reject(p_affirm: bool, pos: Vector2) -> InfoSignal:
	if p_affirm:
		return affirm(pos)
	else:
		return reject(pos)


func affirm(pos: Vector2, deletion_delay := DEFAULT_DELETE_DELAY) -> InfoSignal:
	var info_signal := create_signal(AffirmScene, pos)
	info_signal.animator.delete_after_delay(deletion_delay)
	return info_signal


func reject(pos: Vector2, deletion_delay := DEFAULT_DELETE_DELAY) -> InfoSignal:
	var info_signal := create_signal(RejectScene, pos)
	info_signal.animator.delete_after_delay(deletion_delay)
	return info_signal


func warn(pos: Vector2) -> InfoSignal:
	return create_signal(WarningScene, pos + NEAR_OFFSET)


func give_number(number: int, pos: Vector2, animation := "rise") -> InfoSignal:
	var info_signal := create_signal(NumberScene, pos)
	info_signal.number = number
	info_signal.animate(animation)
	return info_signal


func clear() -> void:
	for child in get_children():
		child.free()
