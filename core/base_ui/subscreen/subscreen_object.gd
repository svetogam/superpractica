#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SubscreenObject
extends InputObject

var superscreen: Superscreen
var _subscreen: Subscreen:
	get = _get_subscreen
var _subscreen_viewer: SubscreenViewer


func _init() -> void:
	add_to_group("subscreen_objects")


func _enter_tree() -> void:
	_subscreen_viewer = ContextUtils.get_parent_in_group(self, "subscreen_viewers")
	if _subscreen_viewer != null:
		superscreen = ContextUtils.get_parent_in_group(self, "superscreens")
		assert(superscreen != null)
		superscreen.input_sequencer.connect_input_object(self, _subscreen_viewer)


func _get_subscreen() -> Subscreen:
	if _subscreen == null:
		_subscreen = ContextUtils.get_parent_in_group(self, "subscreens")
		assert(_subscreen != null)
	return _subscreen
