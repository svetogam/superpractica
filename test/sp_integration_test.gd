##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SpIntegrationTest
extends GutTest

var scene: Node
var simulator := MouseInputSimulator.new()


#Virtual Default
func _get_scene_path() -> String:
	return ""


func _has_scene() -> bool:
	return _get_scene_path() != ""


func _on_interference(_interfering_events: Array):
	assert(false)


func before_all():
	add_child(simulator)
	simulator.ignore_interference(false)
	simulator.connect("interference_detected", self, "_on_interference")


func before_each():
	if _has_scene():
		scene = _load_scene(_get_scene_path())
	simulator.reset()


func after_each():
	if _has_scene():
		remove_child(scene)
	_remove_ref_scene()


func after_all():
	simulator.disconnect("interference_detected", self, "_on_interference")
	remove_child(simulator)


func _load_scene(path: String) -> Node:
	var t_scene = load(path).instance()
	add_child(t_scene)
	return t_scene


func _load_ref_scene(path: String) -> void:
	var ref_scene = _load_scene(path)
	for child in ref_scene.get_children():
		child.hide()


func _remove_ref_scene() -> void:
	if get_node_or_null("Ref") != null:
		remove_child($Ref)


func _save_failure_screenshot() -> void:
	if is_failing():
		var source = get_stack()[1]["source"]
		source = source.trim_suffix(".gd")
		source = source.rsplit("/", false, 1)[1]
		var line = get_stack()[1]["line"]
		var filename = source + String(line)
		Utils.save_screenshot("res://test/failure_screens", filename)
