##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends WindowContent

var _spawner_factory: NodeFactory
onready var _container := $"%MainContainer"
onready var _sub_container_prototype := $"%SubContainerPrototype"


func _ready() -> void:
	taking_input = true


func setup(p_spawner_factory: NodeFactory, included:=[]) -> void:
	_spawner_factory = p_spawner_factory
	for spawner_type in included:
		add_spawner(spawner_type)


func add_spawner(spawner_type: int) -> void:
	var sub_container = _add_sub_container()
	var spawner = _spawner_factory.create_on(spawner_type, sub_container)
	spawner.set_object_type(spawner_type)


func _add_sub_container() -> Control:
	var sub_container = _sub_container_prototype.duplicate()
	_container.add_child(sub_container)
	var spawner_container = sub_container.get_node("SpawnerContainer")
	return spawner_container


func get_spawner(spawner_type: int) -> SuperscreenObject:
	for spawner in _get_spawners():
		if spawner.get_object_type() == spawner_type:
			return spawner
	return null


func _get_spawners() -> Array:
	return ContextUtils.get_children_in_group(self, "object_spawners")


func _superscreen_input(event: SuperscreenInputEvent) -> void:
	for spawner in _get_spawners():
		spawner.take_input(event)


func set_disabled(status:=true) -> void:
	taking_input = not status


#Hack for the crooked container cartel
func _on_PanelContainer_resized() -> void:
	if _container != null:
		rect_min_size.y = _container.get_rect().size.y + 14
