##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name ScreenEffectGroup
extends Node2D


func _init(effect_layer: CanvasLayer) -> void:
	effect_layer.add_child(self)


func create_effect(effect_scene: PackedScene, pos: Vector2) -> Node2D:
	var effect = effect_scene.instance()
	_add_effect(effect)
	effect.position = pos
	return effect


func _add_effect(effect: Node2D) -> void:
	add_child(effect)


func clear() -> void:
	for child in get_effects():
		remove_child(child)


func get_effects() -> Array:
	return get_children()


func duplicate_effect(effect: Node2D) -> Node2D:
	var duplicate = effect.duplicate()
	_add_effect(duplicate)

	var superscreen = get_tree().get_nodes_in_group("superscreens")[0]
	var source_viewer = ContextUtils.get_parent_in_group(effect, "subscreen_viewers")
	var dest_viewer = ContextUtils.get_parent_in_group(self, "subscreen_viewers")
	duplicate.position = superscreen.convert_point_between_subscreen_viewers(
			effect.position, source_viewer, dest_viewer)
	duplicate.set_by_effect(effect)

	return duplicate
