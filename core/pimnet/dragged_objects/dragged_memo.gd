#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name DraggedMemo
extends SuperscreenObject

var memo: Memo
@onready var _graphic_box := %GraphicBox as ColorRect
@onready var _label := %Label as Label


func _init() -> void:
	_drag_only = true


func setup(p_memo: Memo) -> void:
	memo = p_memo


func _ready():
	super()
	assert(memo != null)
	_set_text_by_memo()


func _set_text_by_memo() -> void:
	_label.text = memo.get_string()


func set_size(size: Vector2) -> void:
	_graphic_box.size = size
	input_shape.set_rect(size)


func _on_drop(_point: Vector2) -> void:
	superscreen.process_dragged_memo_drop(self)
