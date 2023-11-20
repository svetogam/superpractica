##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name ContextUtils


static func get_child_in_group(parent: Node, group: String) -> Node:
	for child in parent.get_children():
		if child.is_in_group(group):
			return child
	return null


static func get_only_child_in_group(parent: Node, group: String) -> Node:
	var first_child = null
	for child in parent.get_children():
		if child.is_in_group(group):
			if first_child == null:
				first_child = child
			else:
				return null
	return first_child


static func get_children_in_group(parent: Node, group: String, recursive:=true) -> Array:
	var children_in_group = []
	if recursive:
		for node in parent.get_tree().get_nodes_in_group(group):
			if parent.is_ancestor_of(node):
				children_in_group.append(node)
	else:
		for child in parent.get_children():
			if child.is_in_group(group):
				children_in_group.append(child)
	return children_in_group


static func get_parent_in_group(child: Node, group: String) -> Node:
	var parent = child.get_parent()
	while parent != null:
		if parent.is_in_group(group):
			return parent
		parent = parent.get_parent()
	return null


static func get_parents_with_meta(node: Node, meta_key: String, include_self:=true) -> Array:
	var node_list = []

	if include_self and node.has_meta(meta_key):
		node_list.append(node)

	var next_parent = get_parent_with_meta(node, meta_key)
	while next_parent != null:
		node_list.append(next_parent)
		next_parent = get_parent_with_meta(next_parent, meta_key)

	return node_list


static func get_parent_with_meta(node: Node, meta_key: String) -> Node:
	var parent = node.get_parent()
	while parent != null:
		if parent.has_meta(meta_key):
			return parent
		parent = parent.get_parent()
	return null
