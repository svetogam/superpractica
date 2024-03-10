#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends State

var _map: TopicMap:
	get:
		return _target.get_current_topic_map()


func _enter(_last_state: String) -> void:
	var tween = (create_tween().set_trans(Tween.TRANS_QUAD)
			.set_ease(Tween.EASE_IN_OUT)
			.tween_property(
			_target.player_camera, "zoom", _target.MAP_ZOOM, _target.ZOOM_OUT_DURATION))
	tween.finished.connect(_on_zoom_finished)


func _on_zoom_finished() -> void:
	if _map.focused_node is SubtopicNode:
		_target.unstage_topic_map()

	_target.zoomed_out.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
