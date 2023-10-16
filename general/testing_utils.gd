##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name TestingUtils
extends Reference

var test: Node
var _mocked_arrays: Array


func _init(p_test: Node) -> void:
	test = p_test


func mock_objects_from_script(script: Script, number: int) -> Array:
	var array = []
	for _i in range(number):
		var object = test.double(script).new()
		array.append(object)
	_mocked_arrays.append(array)
	return array


func mock_objects_from_scene(scene: PackedScene, number: int) -> Array:
	var array = []
	for _i in range(number):
		var object = test.double(scene).instance()
		array.append(object)
	_mocked_arrays.append(array)
	return array


func clear_mocks() -> void:
	for array in _mocked_arrays:
		array.clear()


#Call this only after adding the parent node, so onready vars don't override it.
func mock_subnode_on_node(node: Node, subnode_class: Script,
			property_name: String) -> Node:
	var subnode = test.double(subnode_class).new()
	var old_subnode = node.get(property_name)
	subnode.name = old_subnode.name
	for group in old_subnode.get_groups():
		subnode.add_to_group(group)

	node.remove_child(old_subnode)
	old_subnode.queue_free()

	node.add_child(subnode)
	node.set(property_name, subnode)
	return subnode


func assert_expected_signals_emitted(object: Object,
			asserted_signals: Array, expected_signals:=[]) -> void:
	var signals_map = {}
	for sig in asserted_signals:
		signals_map[sig] = expected_signals.has(sig)

	for sig in signals_map:
		var expected = signals_map[sig]
		if expected:
			test.assert_signal_emitted(object, sig)
		else:
			test.assert_signal_not_emitted(object, sig)
