##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Control

signal position_changed(new_position)

@onready var _h_scroll_bar := %HScrollBar as HScrollBar
@onready var _v_scroll_bar := %VScrollBar as VScrollBar


func _ready() -> void:
	_h_scroll_bar.value_changed.connect(_on_scroll_bar_value_changed)
	_v_scroll_bar.value_changed.connect(_on_scroll_bar_value_changed)


func set_scroll_bars(target_size: Vector2, camera_size: Vector2) -> void:
	_h_scroll_bar.min_value = 0
	_h_scroll_bar.max_value = target_size.x
	_h_scroll_bar.page = camera_size.x
	_hide_or_show_scroll_bar(_h_scroll_bar)

	_v_scroll_bar.min_value = 0
	_v_scroll_bar.max_value = target_size.y
	_v_scroll_bar.page = camera_size.y
	_hide_or_show_scroll_bar(_v_scroll_bar)


func _hide_or_show_scroll_bar(scroll_bar: ScrollBar) -> void:
	if scroll_bar.page < scroll_bar.max_value:
		scroll_bar.show()
	else:
		scroll_bar.hide()


func _on_scroll_bar_value_changed(_value: float) -> void:
	position_changed.emit(get_scroll_position())


func get_scroll_position() -> Vector2:
	var h_scroll = _h_scroll_bar.value
	var v_scroll = _v_scroll_bar.value
	return Vector2(h_scroll, v_scroll)


func set_scroll_position(scroll_position: Vector2) -> void:
	_h_scroll_bar.value = scroll_position.x
	_v_scroll_bar.value = scroll_position.y
