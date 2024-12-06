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
var setup_resource: PimnetSetupResource:
	get:
		assert(Game.current_level != null)
		return Game.current_level.pimnet_setup
var goal_type: LevelResource.GoalTypes:
	get:
		assert(Game.current_level != null)
		return Game.current_level.goal_type
var dragged_object: FieldObject
var _pims_left_to_right: Array = []
var _dragging := false
@onready var overlay := %Overlay as PimnetOverlay
@onready var effect_layer := %RootEffectLayer as CanvasLayer
@onready var dragged_object_layer := %DraggedObjectLayer as CanvasLayer


func _enter_tree() -> void:
	CSConnector.with(self).connect_signal(Game.AGENT_FIELD,
			"external_drag_requested", start_interfield_drag)
	CSConnector.with(self).connect_signal(Game.AGENT_FIELD,
			"dragged_memo_requested", create_dragged_memo)
	CSLocator.with(self).register(Game.SERVICE_PIMNET, self)
	CSConnector.with(self).connect_setup(Game.AGENT_FIELD, _setup_field)


func _setup_field(field: Field) -> void:
	field.effect_layer = effect_layer
	field.effect_offset_source = field.get_viewport().get_parent()


func _ready() -> void:
	CSLocator.with(self).register(Game.SERVICE_ROOT_EFFECT_LAYER, effect_layer)

	if setup_resource != null:
		# Set up pims
		for pim_scene in setup_resource.pims:
			var pim = pim_scene.instantiate()
			_pims_left_to_right.append(pim)
			%PimStrip.add_child(pim)

		# Set up panels
		overlay.reversion_menu.visible = setup_resource.reversion_enable
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
		overlay.goal_type = goal_type
		overlay.setup_panel(PimnetOverlay.PimnetPanels.GOAL,
				overlay.goal_type != LevelResource.GoalTypes.NONE,
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


func disable_verification_input(disable := true) -> void:
	set_process_input(not disable)
	overlay.set_process_input(not disable)

	if disable:
		overlay.mouse_filter = Control.MOUSE_FILTER_STOP
		overlay.mouse_default_cursor_shape = Control.CURSOR_BUSY
	else:
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		overlay.mouse_default_cursor_shape = Control.CURSOR_ARROW

	for node in get_tree().get_nodes_in_group("field_objects"):
		node.disable_input(disable)

	for button in get_tree().get_nodes_in_group("disable_during_verification"):
		button.disabled = disable
		if disable:
			button.mouse_default_cursor_shape = Control.CURSOR_BUSY
		else:
			button.mouse_default_cursor_shape = Control.CURSOR_ARROW


func _setup_tool_panel() -> void:
	for pim in _pims_left_to_right:
		if pim is FieldPim:
			overlay.tool_panel.add_toolset(pim.field.interface_data)
			overlay.tool_panel.tool_selected.connect(
					pim.field.on_tool_panel_tool_selected)
			pim.field.tool_changed.connect(
					overlay.tool_panel.on_field_tool_changed.bind(pim.field.field_type))
			pim.focus_entered.connect(
					overlay.tool_panel.show_toolset.bind(pim.field.field_type))


func _setup_creation_panel() -> void:
	overlay.creation_panel.tool_dragged.connect(create_interfield_object)
	for pim in _pims_left_to_right:
		if pim is FieldPim:
			overlay.creation_panel.add_toolset(pim.field.interface_data)
			pim.focus_entered.connect(
					overlay.creation_panel.show_toolset.bind(pim.field.field_type))


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


func overlay_position_to_effect_layer(p_position: Vector2) -> Vector2:
	var overlay_offset = %CameraPoint.global_position - Game.get_screen_rect().size/2
	return p_position + overlay_offset


func get_pim_list() -> Array:
	return Utils.get_children_in_group(self, "pims")


func get_pim(index: int = 0) -> Pim:
	var pims = get_pim_list()
	if pims.size() > 0:
		return pims[index]
	else:
		return null


func get_field_list() -> Array:
	return Utils.get_children_in_group(self, "fields")


#====================================================================
# Drag and Drop
#====================================================================

func create_dragged_memo(memo: Memo) -> void:
	# Use workaround because Godot's drag previews are bugged
	#var preview = %DummySlot.make_memo_preview(memo)
	var preview = %DummySlot.make_memo_preview_2(memo)

	%DummySlot.force_drag(memo, preview)
	start_memo_drag(preview, memo)


func start_memo_drag(preview: Control, memo: Memo) -> void:
	memo_drag_started.emit(memo)
	preview.tree_exited.connect(memo_drag_ended.emit.bind(memo))


func start_interfield_drag(object: FieldObject) -> void:
	assert(object != null)
	assert(dragged_object == null)

	dragged_object = object
	for field in get_field_list():
		field.dragged_object = dragged_object

	create_interfield_object(object.object_data)


func create_interfield_object(object_data: FieldObjectData) -> InterfieldObject:
	var interfield_object := InterfieldObjectScene.instantiate()
	interfield_object.setup(object_data)
	%DraggedObjectLayer.add_child(interfield_object)
	return interfield_object


func process_interfield_drop(object_data: FieldObjectData) -> void:
	# Obtain relevant variables
	var source: Field = null
	if dragged_object != null:
		source = dragged_object.field
	var destination: Field
	var external_point: Vector2 = %PimStrip.get_global_mouse_position()
	var field_point: Vector2
	for pim in _pims_left_to_right:
		if pim is FieldPim and pim.field_has_point(external_point):
			destination = pim.field
			field_point = pim.convert_external_to_internal_point(external_point)

	# React in source pim to drop in other pim
	if source != null and destination != source:
		dragged_object.end_external_drag(true, field_point, destination)

	if destination != null:
		# React in pim to drop within itself
		if destination == source:
			dragged_object.end_external_drag(false, field_point)

		# React in destination pim to drop from anywhere
		else:
			destination._received_in(object_data, field_point, source)

	# Defer so that input-processing order does not matter
	if dragged_object != null:
		for field in get_field_list():
			field.end_drag()
		set_deferred("dragged_object", null)
