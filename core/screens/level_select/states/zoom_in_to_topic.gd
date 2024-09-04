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
	_target.enter_staged_map()
	_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)

	_on_zoom_finished()


func _on_zoom_finished() -> void:
	_target.zoomed_in.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
