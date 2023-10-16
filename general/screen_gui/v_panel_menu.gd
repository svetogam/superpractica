##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name VPanelMenu
extends PanelContainer

export(int) var _min_panel_height := 100
var _panels := {}
onready var _container := $"%MainContainer"


#Virtual
func _get_panel_map() -> Dictionary:
	return {}


func add_panel(panel_type) -> Control:
	var panel_class = _get_panel_map()[panel_type]
	var panel = panel_class.instance()
	panel.rect_min_size.y = _min_panel_height
	_container.add_child(panel)
	_panels[panel_type] = panel
	return panel


func remove_panel(panel_type) -> void:
	assert(has_panel(panel_type))

	var panel = _panels[panel_type]
	panel.queue_free()
	_panels.erase(panel_type)


func get_panel(panel_type) -> Control:
	if _panels.has(panel_type):
		return _panels[panel_type]
	return null


func has_panel(panel_type) -> bool:
	return get_panel(panel_type) != null
