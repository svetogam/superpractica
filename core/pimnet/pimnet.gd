#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Pimnet
extends Superscreen

signal memo_drag_started(memo)
signal memo_drag_stopped(memo)

const InterfieldObjectScene := preload("dragged_objects/interfield_object.tscn")
const DraggedMemoScene := preload("dragged_objects/dragged_memo.tscn")
var _dragged_object_layer: CanvasLayer
var _field_connector := ContextualConnector.new(self, "fields", true)
var _locator := ContextualLocator.new(self)


func _enter_tree() -> void:
	_locator.auto_set("dragged_object_layer", "_dragged_object_layer")
	_field_connector.connect_signal("interfield_object_requested",
			create_interfield_object_by_original)
	_field_connector.connect_signal("dragged_memo_requested",
			create_dragged_memo)


#====================================================================
# Mechanics
#====================================================================

func process_interfield_object_drop(object: InterfieldObject) -> void:
	var source := object.get_source()
	var destination := get_top_field_at_point(object.position)

	if source != null and destination != source:
		source.on_outgoing_drop(object.original)

	if destination != null:
		var field_point := get_field_point_at_external_point(object.position)
		if destination == source:
			destination.on_internal_drop(object.original, field_point)
			object.original.on_interfield_drag_stopped()
		else:
			destination.on_incoming_drop(object, field_point, source)


func process_dragged_memo_drop(object: DraggedMemo) -> void:
	memo_drag_stopped.emit(object.memo)
	var destination := get_top_memo_slot_at_point(object.position)
	if destination != null:
		destination.take_memo(object.memo)


#====================================================================
# Creation
#====================================================================

func create_interfield_object_by_original(original: FieldObject) -> InterfieldObject:
	return _create_interfield_object(original)


func create_interfield_object_by_type(object_type: int, pim_data: PimInterfaceData
) -> InterfieldObject:
	var graphic := pim_data.make_creatable_object_graphic(object_type)
	return _create_interfield_object(null, graphic, object_type)


func _create_interfield_object(original: FieldObject, graphic: ProceduralGraphic = null,
		object_type := GameGlobals.NO_OBJECT
) -> InterfieldObject:
	var past_objects = get_tree().get_nodes_in_group("interfield_objects")
	for past_object in past_objects:
		past_object.queue_free()

	var interfield_object := InterfieldObjectScene.instantiate()
	if original != null:
		interfield_object.setup_by_original(original)
		original.on_interfield_drag_started()
	else:
		interfield_object.setup_by_parts(object_type, graphic)
	_add_dragged_object(interfield_object)

	interfield_object.start_grab()

	return interfield_object


func create_dragged_memo(memo: Memo, memo_size := Vector2.ZERO) -> DraggedMemo:
	var dragged_memo := DraggedMemoScene.instantiate()
	dragged_memo.setup(memo)
	_add_dragged_object(dragged_memo)
	dragged_memo.set_size(memo_size)

	dragged_memo.start_grab()
	memo_drag_started.emit(memo)

	return dragged_memo


func _add_dragged_object(object: SuperscreenObject) -> void:
	assert(_dragged_object_layer != null)
	_dragged_object_layer.add_child(object)


#====================================================================
# Finding
#====================================================================

func get_pim_list() -> Array:
	return ContextUtils.get_children_in_group(self, "pims")


func get_pim(pim_name: String) -> Pim:
	for pim in get_pim_list():
		if pim.name == pim_name:
			return pim
	return null


func get_field_list() -> Array:
	return ContextUtils.get_children_in_group(self, "fields")


func get_pim_field(pim_name: String) -> Field:
	var pim := get_pim(pim_name)
	if pim.field != null:
		return pim.field
	return null


func get_memo_slot_list() -> Array:
	return ContextUtils.get_children_in_group(self, "memo_slots")


func get_top_field_at_point(point: Vector2) -> Field:
	var top_window := get_top_window_at_point(point)
	if top_window != null:
		return _get_field_at_point(top_window, point)
	return null


func _get_field_at_point(window: SpWindow, point: Vector2) -> Field:
	var subscreen := window.get_subscreen_at_point(point)
	if subscreen != null and subscreen.is_in_group("fields"):
		return subscreen
	return null


func get_top_memo_slot_at_point(point: Vector2) -> MemoSlot:
	var top_window := get_top_window_at_point(point)
	if top_window != null:
		return _get_memo_slot_at_point(top_window, point)
	return null


func _get_memo_slot_at_point(window: SpWindow, point: Vector2) -> MemoSlot:
	for window_content in window.get_content_list_at_point(point):
		if window_content.is_in_group("memo_slots"):
			return window_content
	return null


func get_field_point_at_external_point(point: Vector2) -> Vector2:
	var subscreen_viewer := get_top_subscreen_viewer_at_point(point)
	if subscreen_viewer != null:
		var subscreen := subscreen_viewer.get_subscreen()
		if subscreen != null and subscreen.is_in_group("fields"):
			return subscreen_viewer.convert_external_to_internal_point(point)
	assert(false)
	return Vector2.ZERO
