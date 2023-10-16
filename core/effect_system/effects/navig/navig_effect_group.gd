##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name NavigEffectGroup
extends ScreenEffectGroup

const AffirmEffect := preload("effects/correct_effect.tscn")
const RejectEffect := preload("effects/wrong_effect.tscn")
const WarningEffect := preload("effects/warning_effect.tscn")
const PointerEffect := preload("effects/pointer_effect.tscn")
const NEAR_OFFSET := Vector2(20, 15)


func _init(effect_layer: CanvasLayer).(effect_layer) -> void:
	pass


func affirm_or_else_reject(p_affirm: bool, pos: Vector2) -> Node2D:
	if p_affirm:
		return affirm(pos)
	else:
		return reject(pos)


func affirm(pos: Vector2) -> Node2D:
	var effect = create_effect(AffirmEffect, pos)
	effect.animator.delete_after_delay()
	return effect


func reject(pos: Vector2) -> Node2D:
	var effect = create_effect(RejectEffect, pos)
	effect.animator.delete_after_delay()
	return effect


func warn(pos: Vector2) -> Node2D:
	return create_effect(WarningEffect, pos + NEAR_OFFSET)


func point_left(pos: Vector2) -> Node2D:
	return create_effect(PointerEffect, pos)
