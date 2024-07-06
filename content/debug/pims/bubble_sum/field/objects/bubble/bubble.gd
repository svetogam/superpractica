#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObject

const MIN_RADIUS := 40.0
const MAX_RADIUS := 160.0
var radius: float
var selected := false
@onready var _graphic := %Graphic as ProceduralGraphic


func _get_object_type() -> int:
	return BubbleSum.Objects.BUBBLE


func _ready() -> void:
	super()
	_set_radius(%Collider.shape.radius)


func _set_radius(new_radius: float) -> void:
	radius = new_radius
	%Collider.shape.radius = new_radius
	_graphic.set_properties({"radius": radius})


func toggle_select() -> void:
	set_selected(not selected)


func set_selected(value: bool) -> void:
	selected = value
	_graphic.set_properties({"selected": value})


func resize_by(direction: String, vector: Vector2) -> void:
	var new_radius := _get_resized_radius(direction, vector)
	resize_to(new_radius)


func _get_resized_radius(direction: String, resize_vector: Vector2) -> float:
	match direction:
		"L", "UL", "DL":
			return radius - resize_vector.x
		"R", "UR", "DR":
			return radius + resize_vector.x
		"U":
			return radius - resize_vector.y
		"D":
			return radius + resize_vector.y
		_:
			assert(false)
			return -1.0


func resize_to(new_radius: float) -> void:
	new_radius = clamp(new_radius, MIN_RADIUS, MAX_RADIUS)
	_set_radius(new_radius)


func is_inside_bubble(other_bubble: FieldObject) -> bool:
	if get_instance_id() == other_bubble.get_instance_id():
		return false

	var center_distance := position.distance_to(other_bubble.position)
	return center_distance + radius < other_bubble.radius


func overlaps_bubble(other_bubble: FieldObject) -> bool:
	if get_instance_id() == other_bubble.get_instance_id():
		return false

	var center_distance := position.distance_to(other_bubble.position)
	return center_distance <= radius + other_bubble.radius


func intersects_bubble(other_bubble: FieldObject) -> bool:
	if get_instance_id() == other_bubble.get_instance_id():
		return false

	return (overlaps_bubble(other_bubble)
			and not is_inside_bubble(other_bubble)
			and not other_bubble.is_inside_bubble(self))


func get_internal_units() -> Array:
	var internal_units: Array = []
	for unit in field.get_unit_list():
		if unit.is_inside_bubble(self):
			internal_units.append(unit)
	return internal_units


func get_internal_bubbles() -> Array:
	var internal_bubbles: Array = []
	for bubble in field.get_bubble_list():
		if bubble.is_inside_bubble(self):
			internal_bubbles.append(bubble)
	return internal_bubbles


func get_internal_objects() -> Array:
	return get_internal_units() + get_internal_bubbles()


func has_max_radius() -> bool:
	return radius == MAX_RADIUS


func has_min_radius() -> bool:
	return radius == MIN_RADIUS
