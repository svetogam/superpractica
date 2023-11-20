##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldInterfaceComponent

#####################################################################
# Object-Finding
#####################################################################

func get_unit_list() -> Array:
	return _field.get_object_list_by_type(BubbleSumGlobals.Objects.UNIT)


func get_bubble_list() -> Array:
	return _field.get_object_list_by_type(BubbleSumGlobals.Objects.BUBBLE)


func get_selected_unit_list() -> Array:
	var unit_list = get_unit_list()
	var filter = Callable(self, "_is_object_selected")
	var selected_unit_list = Utils.filter_list(unit_list, filter)
	return selected_unit_list


func get_unselected_unit_list() -> Array:
	var unselected_unit_list = get_unit_list()
	var selected_unit_list = get_selected_unit_list()
	for selected_unit in selected_unit_list:
		unselected_unit_list.erase(selected_unit)
	return unselected_unit_list


func get_selected_bubble_list() -> Array:
	var bubble_list = get_bubble_list()
	var filter = Callable(self, "_is_object_selected")
	var selected_bubble_list = Utils.filter_list(bubble_list, filter)
	return selected_bubble_list


static func _is_object_selected(object: FieldObject) -> bool:
		return object.selected


func get_units_at_point(point: Vector2) -> Array:
	var units = []
	for unit in get_unit_list():
		if unit.has_point(point):
			units.append(unit)
	return units


func get_bubbles_at_point(point: Vector2) -> Array:
	var bubbles = []
	for bubble in get_bubble_list():
		if bubble.has_point(point):
			bubbles.append(bubble)
	return bubbles


func get_units_internal_to_bubbles(bubble_list:=[null]) -> Array:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	var all_internal_units = []
	for bubble in bubble_list:
		var internal_units = bubble.get_internal_units()
		for unit in internal_units:
			if not all_internal_units.has(unit):
				all_internal_units.append(unit)
	return all_internal_units


func get_smallest_bubble_at_point(point: Vector2) -> FieldObject:
	var smallest = null
	for bubble in get_bubbles_at_point(point):
		if smallest == null or bubble.radius < smallest.radius:
			smallest = bubble
	return smallest


func get_biggest_bubble_at_point(point: Vector2) -> FieldObject:
	var biggest = null
	for bubble in get_bubbles_at_point(point):
		if biggest == null or bubble.radius > biggest.radius:
			biggest = bubble
	return biggest


#Returns a list of nested bubbles between given bubbles from given list
#Returns an empty list if they are immediate relatives or are not relatives
func get_intermediate_bubbles(bubble_1: FieldObject, bubble_2: FieldObject,
			bubble_list:=[null]) -> Array:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	var smaller
	var bigger
	if bubble_1.is_inside_bubble(bubble_2):
		smaller = bubble_1
		bigger = bubble_2
	elif bubble_2.is_inside_bubble(bubble_1):
		smaller = bubble_2
		bigger = bubble_1
	else:
		return []

	var intermediate_bubbles = []
	for bubble in bubble_list:
		if smaller.is_inside_bubble(bubble) and bubble.is_inside_bubble(bigger):
			intermediate_bubbles.append(bubble)
	return intermediate_bubbles


#####################################################################
# Analysis
#####################################################################

func is_unit_at_point(point: Vector2) -> bool:
	var units = get_units_at_point(point)
	return not units.is_empty()


func is_bubble_at_point(point: Vector2) -> bool:
	var bubbles = get_bubbles_at_point(point)
	return not bubbles.is_empty()


func do_any_bubbles_intersect(bubble_list:=[null]) -> bool:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	for bubble_1 in bubble_list:
		for bubble_2 in bubble_list:
			if bubble_1.intersects_bubble(bubble_2):
				return true
	return false


func is_bubble_directly_inside_bubble(bubble_1: FieldObject, bubble_2: FieldObject,
			bubble_list:=[null]) -> bool:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	if bubble_1.is_inside_bubble(bubble_2):
		var intermediate_bubbles = get_intermediate_bubbles(
				bubble_1, bubble_2, bubble_list)
		if intermediate_bubbles.size() == 0:
			return true
	return false


#Sorted from biggest to smallest
func sort_bubble_list_by_size(bubble_list:=[null]) -> Array:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	bubble_list.sort_custom(Callable(self, "is_bubble_bigger_than_bubble"))
	return bubble_list


static func is_bubble_bigger_than_bubble(bubble_1: FieldObject, bubble_2: FieldObject) -> bool:
	return bubble_1.radius >= bubble_2.radius


#####################################################################
# Memo-Building
#####################################################################

func get_selected_unit_sum() -> IntegerMemo:
	var unit_sum = get_selected_unit_list().size()
	return IntegerMemo.new(unit_sum)


func get_selected_bubble_sum() -> IntegerMemo:
	var bubble_sum = get_selected_bubble_list().size()
	return IntegerMemo.new(bubble_sum)


#func get_expression_by_selected_objects() -> ExpressionMemo:
#	return null
