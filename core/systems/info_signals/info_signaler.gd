# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InfoSignaler
extends Node2D
## Node for managing signals to the player.
##
## [Node2D] that creates and animates [InfoSignal]s as its children.
## All created [InfoSignal]s will be offset by its own [param position].
## [br][br]
## Extend this class to make specialized info signalers.

## Default offset for [InfoSignal]s that pop up near rather than over something.
const NEAR_OFFSET := Vector2(20, 15)
const _AffirmScene := preload("uid://51v0feqeyjdr")
const _RejectScene := preload("uid://dmg7uc5b3wqhc")
const _WarningScene := preload("uid://dk3ojkrwuffyq")
const _NumberScene := preload("uid://cobbyy58sstrk")
const _EqualityScene = preload("uid://r2lr30ufuth5")
const _InequalityScene = preload("uid://d3fuvg0owj4ty")


## Create an [InfoSignal] to signal affirmation at [param p_position].
## [br][br]
## Like saying: "This is correct. Great!"
func affirm(p_position: Vector2) -> InfoSignal:
	return _create_signal(_AffirmScene, p_position)


## Create an [InfoSignal] to signal rejection at [param p_position].
## [br][br]
## Like saying: "This is incorrect. Try again!"
func reject(p_position: Vector2) -> InfoSignal:
	return _create_signal(_RejectScene, p_position)


## Create an [InfoSignal] to signal a warning at [param p_position].
## [br][br]
## Like saying: "Something is wrong here."
func warn(p_position: Vector2) -> InfoSignal:
	return _create_signal(_WarningScene, p_position + NEAR_OFFSET)


## Create a [NumberSignal] to signal a number at [param p_position].
## [param animation] can be any info signal animation starting with [code]in_[/code].
## [br][br]
## Like pointing at something and saying a number.
func popup_number(number: int, p_position: Vector2, animation := "in_rise"
) -> NumberSignal:
	var info_signal := _create_signal(_NumberScene, p_position)
	info_signal.number = number
	info_signal.anim_player.play(animation)
	return info_signal


## Create an [InfoSignal] to signal equality at [param p_position].
## [br][br]
## Like saying: "These are equal. Great!"
func popup_equality(p_position: Vector2) -> InfoSignal:
	return _create_signal(_EqualityScene, p_position)


## Create an [InfoSignal] to signal inequality at [param p_position].
## [br][br]
## Like saying: "These are not equal. Try again!"
func popup_inequality(p_position: Vector2) -> InfoSignal:
	return _create_signal(_InequalityScene, p_position)


## [method Object.free] all [InfoSignal]s created with this [InfoSignaler].
func clear() -> void:
	for child in get_children():
		child.free()


func _create_signal(signal_scene: PackedScene, p_position: Vector2) -> InfoSignal:
	var info_signal := signal_scene.instantiate()
	add_child(info_signal)
	info_signal.position = p_position
	return info_signal
