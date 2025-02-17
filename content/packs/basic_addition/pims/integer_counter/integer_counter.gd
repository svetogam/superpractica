#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Pim


func _ready() -> void:
	_reset()


func _reset() -> void:
	slot.set_memo(IntegerMemo, 0)


func _increment() -> void:
	var new_number = slot.value + 1
	slot.set_memo(IntegerMemo, new_number)


func _on_decr_button_pressed() -> void:
	var new_number = slot.value - 1
	if new_number >= 0:
		slot.set_memo(IntegerMemo, new_number)


func _on_incr_button_pressed() -> void:
	_increment()


func _on_reset_button_pressed() -> void:
	_reset()
