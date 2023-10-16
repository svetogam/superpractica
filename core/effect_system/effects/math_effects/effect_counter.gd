##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name EffectCounter
extends MathEffectGroup

const NEAR_OFFSET := Vector2(30, 20)
var _count := 0


func _init(effect_layer: CanvasLayer).(effect_layer) -> void:
	pass


func count_next(pos: Vector2, beside:=false) -> Node2D:
	_count += 1
	if beside:
		return give_number(_count, pos + NEAR_OFFSET)
	else:
		return give_number(_count, pos)


func give_current_count(pos: Vector2, beside:=false) -> Node2D:
	if beside:
		return give_number(_count, pos + NEAR_OFFSET)
	else:
		return give_number(_count, pos)


func remove_last_count() -> void:
	assert(_count != 0)

	var last_count = get_highest_count_object()
	remove_child(last_count)
	_count -= 1


func reset_count() -> void:
	_count = 0
	clear()


func get_count() -> int:
	return _count


func get_highest_count_object() -> Node2D:
	assert(not get_effects().empty())

	return get_effects().back()
