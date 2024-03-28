#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SpIntegrationTest
extends GutTest

const AWAIT_QUICK := 1.0
const AWAIT_LONG := 10.0
var scene: Node
var simulator := MouseInputSimulator.new()


# Virtual
func _get_scene_path() -> String:
	return ""


func _has_scene() -> bool:
	return _get_scene_path() != ""


func _on_interference(_interfering_events: Array) -> void:
	var message := ("Do not perform inputs while tests are running. "
			+ InputEventSimulator.get_interference_message(_interfering_events))
	assert(false, message)


func before_all():
	add_child(simulator)
	simulator.ignore_interference(false)
	simulator.interference_detected.connect(_on_interference)


func before_each():
	if _has_scene():
		scene = _load_scene(_get_scene_path())
	simulator.reset()


func after_each():
	if _has_scene():
		scene.free()
	_remove_ref_scene()


func after_all():
	simulator.interference_detected.disconnect(_on_interference)
	simulator.queue_free()


func _load_scene(path: String) -> Node:
	var loaded_scene = load(path).instantiate()
	add_child(loaded_scene)
	return loaded_scene


func _load_ref_scene(path: String) -> void:
	var ref_scene := _load_scene(path)
	for child in ref_scene.get_children():
		if child is CanvasItem:
			child.hide()


func _remove_ref_scene() -> void:
	if get_node_or_null("Ref") != null:
		$Ref.free()


func _get_await_time() -> float:
	return AWAIT_QUICK * Engine.time_scale


func _save_failure_screenshot() -> void:
	if is_failing():
		var source = get_stack()[1]["source"]
		source = source.trim_suffix(".gd")
		source = source.rsplit("/", false, 1)[1]
		var line = get_stack()[1]["line"]
		var filename = "res://test/" + source + "-line-" + str(line) + ".png"
		var image := get_viewport().get_texture().get_image()
		image.save_png(filename)