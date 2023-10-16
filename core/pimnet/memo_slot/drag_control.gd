##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SuperscreenObject

const SIZE := Vector2(120, 80)
var _memo_slot: WindowContent


func setup(p_memo_slot: WindowContent) -> void:
	_memo_slot = p_memo_slot
	input_shape.set_rect(_memo_slot.rect_size, false)


func _on_press(_point: Vector2) -> void:
	if _memo_slot.memo_output_enabled and _memo_slot.memo != null:
		_memo_slot.pimnet.create_dragged_memo(_memo_slot.memo, SIZE)

	stop_active_input()
