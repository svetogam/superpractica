#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends WindowContent

var _pim: Pim
@onready var _container := %MainContainer as VBoxContainer
@onready var _sub_container_prototype := %SubContainerPrototype as CenterContainer


func _ready() -> void:
	taking_input = true


func setup(p_pim: Pim, included: Array = []) -> void:
	_pim = p_pim
	for object_type in included:
		add_spawner(object_type)


func add_spawner(object_type: int) -> void:
	var sub_container := _add_sub_container()
	var spawners_dict := _pim.get_spawner_scenes()
	var spawner = spawners_dict[object_type].instantiate()
	sub_container.add_child(spawner)
	spawner.set_object_type(object_type)


func _add_sub_container() -> Control:
	var sub_container := _sub_container_prototype.duplicate()
	_container.add_child(sub_container)
	var spawner_container := sub_container.get_node("SpawnerContainer")
	return spawner_container


func get_spawner(spawner_type: int) -> ObjectSpawner:
	for spawner in _get_spawners():
		if spawner.get_object_type() == spawner_type:
			return spawner
	return null


func _get_spawners() -> Array:
	return ContextUtils.get_children_in_group(self, "object_spawners")


func _superscreen_input(event: SuperscreenInputEvent) -> void:
	for spawner in _get_spawners():
		spawner.take_input(event)


func set_disabled(status := true) -> void:
	taking_input = not status


# Hack for the crooked container cartel
func _on_panel_container_resized() -> void:
	if _container != null:
		custom_minimum_size.y = _container.get_rect().size.y + 24
