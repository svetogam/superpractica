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
extends Node

signal memo_drag_started(memo)
signal memo_drag_ended(memo)

const InterfieldObjectScene := preload("interfield_object.tscn")
@export var setup_resource: PimnetSetupResource
var dragged_object: FieldObject
var _pims_left_to_right: Array = []
var _dragging := false
var _field_connector := ContextualConnector.new(self, "fields", true)
@onready var overlay := %Overlay as PimnetOverlay
@onready var effect_layer := %RootEffectLayer as CanvasLayer
@onready var dragged_object_layer := %DraggedObjectLayer as CanvasLayer


func _enter_tree() -> void:
	_field_connector.connect_signal("interfield_object_requested",
			create_interfield_object_by_original)
	_field_connector.connect_signal("dragged_memo_requested",
			create_dragged_memo)
	CSLocator.with(self).register(GameGlobals.SERVICE_PIMNET, self)


func _ready() -> void:
	CSLocator.with(self).register(GameGlobals.SERVICE_EFFECT_LAYER, effect_layer)

	if setup_resource != null:
		# Set up pims
		for pim_scene in setup_resource.pims:
			var pim = pim_scene.instantiate()
			_pims_left_to_right.append(pim)
			%PimStrip.add_child(pim)

		# Set up panels
		if setup_resource.reversion_enable:
			overlay.activate_reversion()
		overlay.setup_panel(PimnetOverlay.PimnetPanels.INVENTORY,
				setup_resource.inventory_enable,
				setup_resource.inventory_start_active)
		overlay.setup_panel(PimnetOverlay.PimnetPanels.TOOLS,
				setup_resource.tools_enable,
				setup_resource.tools_start_active)
		overlay.setup_panel(PimnetOverlay.PimnetPanels.CREATION,
				setup_resource.creation_enable,
				setup_resource.creation_start_active)
		overlay.setup_panel(PimnetOverlay.PimnetPanels.TRANSLATION,
				setup_resource.translation_enable,
				setup_resource.translation_start_active)
		overlay.goal_type = setup_resource.goal_type
		overlay.setup_panel(PimnetOverlay.PimnetPanels.GOAL,
				setup_resource.goal_enable,
				setup_resource.goal_start_active)
		overlay.setup_panel(PimnetOverlay.PimnetPanels.PLAN,
				setup_resource.plan_enable,
				setup_resource.plan_start_active)

		_setup_tool_panel()
		_setup_creation_panel()

	# Set up camera and scrolling
	overlay.enable_scroll_buttons(_pims_left_to_right.size() > 1)
	_clamp_camera_in_bounds.call_deferred(false)

	if _pims_left_to_right.size() > 0:
		_pims_left_to_right[0].focus_entered.emit()


func _process(_delta: float) -> void:
	_clamp_camera_in_bounds()


func _input(event: InputEvent) -> void:
	# Stop dragging camera
	if event is InputEventMouseButton and event.is_action_released("primary_mouse"):
		_dragging = false

	# Drag camera
	if event is InputEventMouseMotion and _dragging:
		%CameraPoint.position -= event.relative


func _unhandled_input(event: InputEvent) -> void:
	# Start dragging camera
	if event is InputEventMouseButton and event.is_action_pressed("primary_mouse"):
		_dragging = true


func _on_left_button_pressed() -> void:
	if _pims_left_to_right.is_empty():
		return

	var pim_to_focus
	if _is_camera_left_of_pim(_pims_left_to_right.front()):
		pim_to_focus = _pims_left_to_right.front()
	else:
		for pim in _pims_left_to_right:
			if _is_camera_right_of_pim(pim):
				pim_to_focus = pim

	_center_camera_on_pim(pim_to_focus)
	pim_to_focus.focus_entered.emit()


func _on_right_button_pressed() -> void:
	if _pims_left_to_right.is_empty():
		return

	var pim_to_focus
	if _is_camera_right_of_pim(_pims_left_to_right.back()):
		pim_to_focus = _pims_left_to_right.back()
	else:
		var pims_right_to_left = _pims_left_to_right.duplicate()
		pims_right_to_left.reverse()
		for pim in pims_right_to_left:
			if _is_camera_left_of_pim(pim):
				pim_to_focus = pim

	_center_camera_on_pim(pim_to_focus)
	pim_to_focus.focus_entered.emit()


func _setup_tool_panel() -> void:
	for pim in _pims_left_to_right:
		if pim is FieldPim:
			var field_type = pim.field.get_field_type()
			overlay.tool_panel.add_toolset(pim.field.interface_data)
			overlay.tool_panel.tool_selected.connect(
					pim.field.on_tool_panel_tool_selected)
			pim.field.tool_changed.connect(
					overlay.tool_panel.on_field_tool_changed.bind(field_type))
			pim.focus_entered.connect(overlay.tool_panel.show_toolset.bind(field_type))


func _setup_creation_panel() -> void:
	overlay.creation_panel.tool_dragged.connect(create_interfield_object_by_type)
	for pim in _pims_left_to_right:
		if pim is FieldPim:
			var field_type = pim.field.get_field_type()
			overlay.creation_panel.add_toolset(pim.field.interface_data)
			pim.focus_entered.connect(
					overlay.creation_panel.show_toolset.bind(field_type))


func _center_camera_on_pim(pim: Pim) -> void:
	%CameraPoint.position = pim.get_rect().get_center()


func _is_camera_left_of_pim(pim: Pim) -> bool:
	return %CameraPoint.position.x < pim.get_global_rect().get_center().x


func _is_camera_right_of_pim(pim: Pim) -> bool:
	return %CameraPoint.position.x > pim.get_global_rect().get_center().x


func _clamp_camera_in_bounds(smoothly := true) -> void:
	var camera_limit_rect: Rect2
	if _pims_left_to_right.size() > 1:
		camera_limit_rect = _get_camera_limit_rect()
		%CameraPoint.position = %CameraPoint.position.clamp(
				camera_limit_rect.position, camera_limit_rect.end)
	elif _pims_left_to_right.size() == 1:
		_center_camera_on_pim(_pims_left_to_right[0])

	if not smoothly:
		%Camera.reset_smoothing()


func _get_camera_limit_rect() -> Rect2:
	const CAMERA_OVERSHOOT_MARGIN_RATIO := 0.15
	var screen_rect = Game.get_screen_rect()
	var limit_margin = screen_rect.size.x * CAMERA_OVERSHOOT_MARGIN_RATIO
	var pim_strip_width := _get_pim_strip_width()
	var rect_width = pim_strip_width - screen_rect.size.x + (2 * limit_margin)
	return Rect2(screen_rect.get_center().x - limit_margin, screen_rect.get_center().y,
			maxf(rect_width, 0.0), 0.0)


func _get_pim_strip_width() -> float:
	const PIM_SEPARATION_WIDTH := 40.0
	var combined_width := 0.0
	for pim in _pims_left_to_right:
		combined_width += pim.size.x
	return combined_width + PIM_SEPARATION_WIDTH * (_pims_left_to_right.size() - 1)


func get_pim_list() -> Array:
	return ContextUtils.get_children_in_group(self, "pims")


func get_pim(index: int = 0) -> Pim:
	var pims = get_pim_list()
	if pims.size() > 0:
		return pims[index]
	else:
		return null


func get_field_list() -> Array:
	return ContextUtils.get_children_in_group(self, "fields")


#====================================================================
# Drag and Drop
#====================================================================

func create_interfield_object_by_original(original: FieldObject) -> InterfieldObject:
	return _create_interfield_object(original)


func create_interfield_object_by_type(field_type: String, object_type: int,
		drag_graphic: Node2D
) -> InterfieldObject:
	return _create_interfield_object(null, drag_graphic, object_type, field_type)


func _create_interfield_object(original: FieldObject, graphic: Node2D = null,
		object_type := GameGlobals.NO_OBJECT, field_type := ""
) -> InterfieldObject:
	var past_objects = get_tree().get_nodes_in_group("interfield_objects")
	for past_object in past_objects:
		past_object.free()

	var interfield_object := InterfieldObjectScene.instantiate()
	if original != null:
		interfield_object.setup_by_original(original)
		original.start_interfield_drag()
		dragged_object = original
	else:
		interfield_object.setup_by_parts(object_type, field_type, graphic)
	%DraggedObjectLayer.add_child(interfield_object)

	return interfield_object


func create_dragged_memo(memo: Memo) -> void:
	# Use workaround because Godot's drag previews are bugged
	#var preview = %DummySlot.make_memo_preview(memo)
	var preview = %DummySlot.make_memo_preview_2(memo)

	%DummySlot.force_drag(memo, preview)
	start_memo_drag(preview, memo)


func start_memo_drag(preview: Control, memo: Memo) -> void:
	memo_drag_started.emit(memo)
	preview.tree_exited.connect(emit_signal.bind("memo_drag_ended", memo))


func process_interfield_object_drop(object: InterfieldObject) -> void:
	var source := object.get_source()
	var destination: Field
	var external_point: Vector2 = %PimStrip.get_global_mouse_position()
	var field_point: Vector2

	for pim in _pims_left_to_right:
		if pim is FieldPim and pim.field_has_point(external_point):
			destination = pim.field
			field_point = pim.convert_external_to_internal_point(external_point)

	if source != null and destination != source:
		source._outgoing_drop(object.original)

	if destination != null:
		if destination == source:
			object.original.end_interfield_drag(field_point)
			object.original._drop(field_point)

		else:
			destination._incoming_drop(object, field_point, source)

	# Defer set so that input-processing order does not matter
	set_deferred("dragged_object", null)