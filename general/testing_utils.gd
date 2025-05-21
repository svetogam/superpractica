# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name TestingUtils
extends Object


static func add_ref_scene(test_suite: GdUnitTestSuite, scene_path: String) -> Node:
	var ref_scene = test_suite.auto_free(load(scene_path).instantiate())
	test_suite.add_child(ref_scene)
	for child in ref_scene.get_children():
		if child is CanvasItem:
			child.hide()
	return ref_scene
