#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name BubbleSum
extends Field

#====================================================================
# Globals
#====================================================================
#region

enum Objects {
	GROUND,
	UNIT,
	BUBBLE,
}
enum Tools {
	NONE = Game.NO_TOOL,
	MOVER,
	UNIT_CREATOR,
	BUBBLE_CREATOR,
	UNIT_DELETER,
	BUBBLE_POPPER,
	BUBBLE_DELETER,
	BUBBLE_EDITOR,
	BUBBLE_RESIZER,
	UNIT_SELECTOR,
	BUBBLE_SELECTOR,
	UNIT_COUNTER,
}

const ObjectUnit := preload("objects/unit/unit.tscn")
const ObjectBubble := preload("objects/bubble/bubble.tscn")


func get_field_type() -> String:
	return "BubbleSum"


static func _get_interface_data() -> FieldInterfaceData:
	return preload("interface_data.gd").new()


#endregion
#====================================================================
# Behavior
#====================================================================
#region

func _on_update(update_type: int) -> void:
	if update_type == UpdateTypes.TOOL_MODE_CHANGED:
		clear_count()
		deselect_units()
		deselect_bubbles()

	_set_depth_of_bubbles_by_size()


func _set_depth_of_bubbles_by_size() -> void:
	var bubble_list = sort_bubble_list_by_size()
	for bubble in bubble_list:
		bubble.move_to_front()


func reset_state() -> void:
	push_action(set_empty)


func _incoming_drop(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"BubbleSum":
			match object_data.object_type:
				BubbleSum.Objects.UNIT:
					_accept_incoming_unit(point)
				BubbleSum.Objects.BUBBLE:
					push_action(create_bubble.bind(point))
		"GridCounting":
			match object_data.object_type:
				GridCounting.Objects.UNIT:
					_accept_incoming_unit(point)


func _accept_incoming_unit(point: Vector2) -> void:
	push_action(create_unit.bind(point))


func _outgoing_drop(object: FieldObject) -> void:
	match object.object_type:
		BubbleSum.Objects.UNIT:
			push_action(delete_unit.bind(object))


#endregion
#====================================================================
# Queries
#====================================================================
#region

#--------------------------------------
# Object-Finding
#--------------------------------------

func get_unit_list() -> Array:
	return get_objects_in_group("units")


func get_bubble_list() -> Array:
	return get_objects_in_group("bubbles")


func get_selected_unit_list() -> Array:
	return get_unit_list().filter(_is_object_selected)


func get_unselected_unit_list() -> Array:
	var unselected_unit_list := get_unit_list()
	var selected_unit_list := get_selected_unit_list()
	for selected_unit in selected_unit_list:
		unselected_unit_list.erase(selected_unit)
	return unselected_unit_list


func get_selected_bubble_list() -> Array:
	return get_bubble_list().filter(_is_object_selected)


static func _is_object_selected(object: FieldObject) -> bool:
		return object.selected


func get_units_at_point(point: Vector2) -> Array:
	var units: Array = []
	for unit in get_unit_list():
		if unit.has_point(point):
			units.append(unit)
	return units


func get_bubbles_at_point(point: Vector2) -> Array:
	var bubbles: Array = []
	for bubble in get_bubble_list():
		if bubble.has_point(point):
			bubbles.append(bubble)
	return bubbles


func get_units_internal_to_bubbles(bubble_list: Array = [null]) -> Array:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	var all_internal_units: Array = []
	for bubble in bubble_list:
		var internal_units = bubble.get_internal_units()
		for unit in internal_units:
			if not all_internal_units.has(unit):
				all_internal_units.append(unit)
	return all_internal_units


func get_smallest_bubble_at_point(point: Vector2) -> FieldObject:
	var smallest: FieldObject = null
	for bubble in get_bubbles_at_point(point):
		if smallest == null or bubble.radius < smallest.radius:
			smallest = bubble
	return smallest


func get_biggest_bubble_at_point(point: Vector2) -> FieldObject:
	var biggest: FieldObject = null
	for bubble in get_bubbles_at_point(point):
		if biggest == null or bubble.radius > biggest.radius:
			biggest = bubble
	return biggest


# Returns a list of nested bubbles between given bubbles from given list
# Returns an empty list if they are immediate relatives or are not relatives
func get_intermediate_bubbles(bubble_1: FieldObject, bubble_2: FieldObject,
		bubble_list: Array = [null]
) -> Array:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	var smaller: FieldObject
	var bigger: FieldObject
	if bubble_1.is_inside_bubble(bubble_2):
		smaller = bubble_1
		bigger = bubble_2
	elif bubble_2.is_inside_bubble(bubble_1):
		smaller = bubble_2
		bigger = bubble_1
	else:
		return []

	var intermediate_bubbles: Array = []
	for bubble in bubble_list:
		if smaller.is_inside_bubble(bubble) and bubble.is_inside_bubble(bigger):
			intermediate_bubbles.append(bubble)
	return intermediate_bubbles


#--------------------------------------
# Analysis
#--------------------------------------

func is_unit_at_point(point: Vector2) -> bool:
	var units := get_units_at_point(point)
	return not units.is_empty()


func is_bubble_at_point(point: Vector2) -> bool:
	var bubbles := get_bubbles_at_point(point)
	return not bubbles.is_empty()


func do_any_bubbles_intersect(bubble_list: Array = [null]) -> bool:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	for bubble_1 in bubble_list:
		for bubble_2 in bubble_list:
			if bubble_1.intersects_bubble(bubble_2):
				return true
	return false


func is_bubble_directly_inside_bubble(bubble_1: FieldObject, bubble_2: FieldObject,
		bubble_list: Array = [null]
) -> bool:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	if bubble_1.is_inside_bubble(bubble_2):
		var intermediate_bubbles := get_intermediate_bubbles(
				bubble_1, bubble_2, bubble_list)
		if intermediate_bubbles.size() == 0:
			return true
	return false


# Sorted from biggest to smallest
func sort_bubble_list_by_size(bubble_list: Array = [null]) -> Array:
	if bubble_list.has(null):
		bubble_list = get_bubble_list()

	bubble_list.sort_custom(is_bubble_bigger_than_bubble)
	return bubble_list


static func is_bubble_bigger_than_bubble(bubble_1: FieldObject, bubble_2: FieldObject
) -> bool:
	return bubble_1.radius >= bubble_2.radius


#--------------------------------------
# Memo-Building
#--------------------------------------

func get_selected_unit_sum() -> IntegerMemo:
	var unit_sum := get_selected_unit_list().size()
	return IntegerMemo.new(unit_sum)


func get_selected_bubble_sum() -> IntegerMemo:
	var bubble_sum := get_selected_bubble_list().size()
	return IntegerMemo.new(bubble_sum)


#func get_expression_by_selected_objects() -> ExpressionMemo:
#	return null


#endregion
#====================================================================
# Actions
#====================================================================
#region

#--------------------------------------
# Basic Actions
#--------------------------------------

func create_unit(point: Vector2) -> FieldObject:
	var unit := BubbleSum.ObjectUnit.instantiate() as FieldObject
	add_child(unit)
	unit.position = point
	return unit


func create_bubble(point: Vector2, radius := -1.0) -> FieldObject:
	var bubble := BubbleSum.ObjectBubble.instantiate() as FieldObject
	add_child(bubble)
	bubble.position = point
	if radius != -1.0:
		bubble.resize_to(radius)
	return bubble


func delete_unit(unit: FieldObject) -> void:
	unit.queue_free()


func pop_bubble(bubble: FieldObject) -> void:
	bubble.queue_free()


func delete_bubble(bubble: FieldObject) -> void:
	delete_objects_internal_to_bubble(bubble)
	bubble.queue_free()


func delete_objects_internal_to_bubble(bubble: FieldObject) -> void:
	var internal_objects = bubble.get_internal_objects()
	for object in internal_objects:
		object.queue_free()


func move_unit(unit: FieldObject, p_position: Vector2) -> void:
	unit.position = p_position


func move_unit_by(unit: FieldObject, vector: Vector2) -> void:
	move_unit(unit, unit.position + vector)


func move_bubble(bubble: FieldObject, p_position: Vector2) -> void:
	var delta_vector := p_position - bubble.position
	for object in bubble.get_internal_objects():
		object.position += delta_vector
	bubble.position = p_position


func move_bubble_by(bubble: FieldObject, vector: Vector2) -> void:
	move_bubble(bubble, bubble.position + vector)


func resize_bubble(bubble: FieldObject, radius: int) -> void:
	bubble.resize_to(radius)


func select_unit(unit: FieldObject) -> void:
	unit.toggle_select()


func select_bubble(bubble: FieldObject) -> void:
	toggle_bubble_selection(bubble, true)


func toggle_bubble_selection(bubble: FieldObject, give_contents_same_selection: bool
) -> void:
	bubble.toggle_select()
	if give_contents_same_selection:
		deselect_units()
		select_units_internal_to_selected_bubbles()


func select_units_internal_to_selected_bubbles() -> void:
	var units_to_select = get_units_internal_to_bubbles(get_selected_bubble_list())
	for unit in units_to_select:
		unit.set_selected(true)


func deselect_units() -> void:
	for unit in get_unit_list():
		unit.set_selected(false)


func deselect_bubbles() -> void:
	for bubble in get_bubble_list():
		bubble.set_selected(false)


func count_unit(unit: FieldObject) -> NumberEffect:
	if not unit.selected:
		unit.set_selected(true)
		return effect_counter.count_next(unit.position, true)
	return null


func clear_count() -> void:
	deselect_units()
	effect_counter.reset_count()


#--------------------------------------
# Field-Setting
#--------------------------------------

func set_empty() -> void:
	for unit in get_unit_list():
		unit.queue_free()
	for bubble in get_bubble_list():
		bubble.queue_free()
	clear_count()


#endregion
#====================================================================
# History
#====================================================================
#region

#--------------------------------------
# State Building
#--------------------------------------

const MemStateClass := preload("mem_state.gd")


func build_state() -> CRMemento:
	return MemStateClass.new({
		"unit_data_list": _get_unit_data_list(),
		"bubble_data_list": _get_bubble_data_list()
	})


func _get_unit_data_list() -> Array:
	var unit_data_list: Array = []
	for unit in get_unit_list():
		var unit_data := _get_unit_data(unit)
		unit_data_list.append(unit_data)
	return unit_data_list


func _get_bubble_data_list() -> Array:
	var bubble_data_list: Array = []
	for bubble in get_bubble_list():
		var bubble_data := _get_bubble_data(bubble)
		bubble_data_list.append(bubble_data)
	return bubble_data_list


func _get_unit_data(unit: FieldObject) -> Dictionary:
	return {"position": unit.position}


func _get_bubble_data(bubble: FieldObject) -> Dictionary:
	return {"position": bubble.position, "radius": bubble.radius}


#--------------------------------------
# State Loading
#--------------------------------------

func load_state(state: CRMemento) -> void:
	set_empty()

	_create_units_by_data_list(state.data.unit_data_list)
	_create_bubbles_by_data_list(state.data.bubble_data_list)

	_trigger_update(UpdateTypes.STATE_LOADED)


func _create_units_by_data_list(unit_data_list: Array) -> void:
	for unit_data in unit_data_list:
		_create_unit_by_data(unit_data)


func _create_unit_by_data(unit_data: Dictionary) -> FieldObject:
	var point = unit_data.position
	return create_unit(point)


func _create_bubbles_by_data_list(bubble_data_list: Array) -> void:
	for bubble_data in bubble_data_list:
		_create_bubble_by_data(bubble_data)


func _create_bubble_by_data(bubble_data: Dictionary) -> FieldObject:
	var point = bubble_data.position
	var radius = bubble_data.radius
	return create_bubble(point, radius)


#endregion
