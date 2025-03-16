# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name NavigEffectGroup
extends ScreenEffectGroup

const AffirmEffect := preload("effects/correct_effect.tscn")
const RejectEffect := preload("effects/wrong_effect.tscn")
const WarningEffect := preload("effects/warning_effect.tscn")
const NEAR_OFFSET := Vector2(20, 15)
const DEFAULT_DELETE_DELAY := 1.0


func affirm_or_else_reject(p_affirm: bool, pos: Vector2) -> ScreenEffect:
	if p_affirm:
		return affirm(pos)
	else:
		return reject(pos)


func affirm(pos: Vector2, deletion_delay := DEFAULT_DELETE_DELAY) -> ScreenEffect:
	var effect := create_effect(AffirmEffect, pos)
	effect.animator.delete_after_delay(deletion_delay)
	return effect


func reject(pos: Vector2, deletion_delay := DEFAULT_DELETE_DELAY) -> ScreenEffect:
	var effect := create_effect(RejectEffect, pos)
	effect.animator.delete_after_delay(deletion_delay)
	return effect


func warn(pos: Vector2) -> ScreenEffect:
	return create_effect(WarningEffect, pos + NEAR_OFFSET)
