# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Pimnet
extends Node

signal memo_drag_started(memo)
signal memo_drag_ended(memo)

const InterfieldObjectScene := preload("interfield_object.tscn")
const MemoDragPreview := preload("memo_slot/memo_drag_preview.tscn")
var dragged_object: FieldObject
var pims: Array:
	get:
		return _pims_left_to_right
var fields: Array:
	get:
		var list: Array = []
		for pim in pims:
			if pim.has_field():
				list.append(pim.field)
		return list
var _pims_left_to_right: Array = []
var _last_destination: Field
@onready var overlay := %Overlay as PimnetOverlay
@onready var effect_layer := %RootEffectLayer as CanvasLayer
@onready var dragged_object_layer := %DraggedObjectLayer as CanvasLayer
@onready var info_signaler := %InfoSignaler as InfoSignaler


func _enter_tree() -> void:
	CSConnector.with(self).connect_signal(
		Game.AGENT_FIELD, "external_drag_requested", start_interfield_drag
	)
	CSConnector.with(self).connect_signal(
		Game.AGENT_FIELD, "dragged_memo_requested", start_memo_drag
	)
	CSLocator.with(self).register(Game.SERVICE_PIMNET, self)

	_center_camera_on_pim_strip()
	get_viewport().size_changed.connect(_center_camera_on_pim_strip)


func _ready() -> void:
	CSLocator.with(self).register(Game.SERVICE_ROOT_EFFECT_LAYER, effect_layer)

	overlay.pim_tools.tool_selected.connect(_on_pim_tool_selected)
	overlay.pim_objects.tool_dragged.connect(create_interfield_object)


## Pass [code]null[/code] to clear everything.
func setup(level_data: LevelResource) -> void:
	# Clear everything
	for pim in _pims_left_to_right:
		pim.free()
	_pims_left_to_right.clear()
	%UndoButton.visible = false
	%RedoButton.visible = false
	%ResetButton.visible = false
	%PlaytypeExampleButton.visible = false
	%PlaytypeTrialButton.visible = false
	%PlanButton.visible = false
	%EditPanelsButton.visible = false
	overlay.deactivate_panel(PimnetOverlay.PimnetPanels.PIM_TOOLS)
	overlay.deactivate_panel(PimnetOverlay.PimnetPanels.PIM_OBJECTS)

	# Setup by level_data
	if level_data != null:
		for pim_scene in level_data.pims:
			var pim = pim_scene.instantiate()
			_pims_left_to_right.append(pim)
			%PimStrip.add_child(pim)

		# Set up panels
		%UndoButton.visible = level_data.enable_reversion
		%RedoButton.visible = level_data.enable_reversion
		%ResetButton.visible = level_data.enable_reversion
		%PlanButton.visible = level_data.enable_plan
		%EditPanelsButton.visible = level_data.enable_edit_layout
		match level_data.level_type:
			LevelResource.LevelTypes.EXAMPLE_PRACTICE:
				%PlaytypeExampleButton.show()
			LevelResource.LevelTypes.TRIAL_PRACTICE:
				%PlaytypeTrialButton.show()
		if level_data.enable_pim_tools:
			overlay.activate_panel(PimnetOverlay.PimnetPanels.PIM_TOOLS)
		if level_data.enable_pim_objects:
			overlay.activate_panel(PimnetOverlay.PimnetPanels.PIM_OBJECTS)

	# Setup pim-tools panel
	for pim in _pims_left_to_right:
		if pim.has_field():
			overlay.pim_tools.add_toolset(pim.field.interface_data)
			overlay.pim_tools.deactivate(pim.field.field_type)
			overlay.pim_tools.include_all(pim.field.field_type)
			overlay.pim_tools.enable_all(pim.field.field_type)
			pim.field.tool_changed.connect(
				overlay.pim_tools.on_field_tool_changed.bind(pim.field.field_type)
			)
			pim.focus_entered.connect(
				overlay.pim_tools.show_toolset.bind(pim.field.field_type)
			)

	# Setup pim-objects panel
	for pim in _pims_left_to_right:
		if pim.has_field():
			overlay.pim_objects.add_toolset(pim.field.interface_data)
			overlay.pim_objects.include_all(pim.field.field_type)
			overlay.pim_objects.enable_all(pim.field.field_type)
			pim.focus_entered.connect(
				overlay.pim_objects.show_toolset.bind(pim.field.field_type)
			)

	# Set up camera and scrolling
	if _pims_left_to_right.size() > 1:
		%CameraPoint.draggable = true
		%CameraPoint.bounds = _get_camera_limit_rect()
		%CameraPoint.clamp_in_bounds.call_deferred()
	elif _pims_left_to_right.size() == 1:
		_center_camera_on_pim.call_deferred(0)
	%Camera.reset_smoothing.call_deferred()

	# Focus on first pim
	if _pims_left_to_right.size() > 0:
		_pims_left_to_right[0].focus_entered.emit()


func _on_pim_tool_selected(toolset_name: String, tool_mode: String) -> void:
	for field in fields:
		if toolset_name == field.field_type:
			field.set_tool(tool_mode)


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


func _center_camera_on_pim_strip() -> void:
	%CameraPoint.position.y = Game.get_screen_rect().get_center().y


func _center_camera_on_pim(pim_index: int) -> void:
	# Do nothing if index is out of bounds
	if pim_index < 0 or pim_index >= _pims_left_to_right.size():
		return

	%CameraPoint.position.x = _pims_left_to_right[pim_index].get_rect().get_center().x


func _get_camera_limit_rect() -> Rect2:
	const CAMERA_OVERSHOOT_MARGIN_RATIO := 0.15
	var screen_rect = Game.get_screen_rect()
	var limit_margin = screen_rect.size.x * CAMERA_OVERSHOOT_MARGIN_RATIO
	var pim_strip_width := _get_pim_strip_width()
	var rect_width = pim_strip_width - screen_rect.size.x + (2 * limit_margin)
	return Rect2(
		screen_rect.get_center().x - limit_margin,
		screen_rect.get_center().y,
		maxf(rect_width, 0.0),
		0.0
	)


func _get_pim_strip_width() -> float:
	const PIM_SEPARATION_WIDTH := 50.0
	var combined_width := 0.0
	for pim in _pims_left_to_right:
		combined_width += pim.size.x
	return combined_width + PIM_SEPARATION_WIDTH * (_pims_left_to_right.size() - 1)


func overlay_position_to_effect_layer(p_position: Vector2) -> Vector2:
	var overlay_offset = %CameraPoint.global_position - Game.get_screen_rect().size / 2
	return p_position + overlay_offset


func get_pim(pim_name := "") -> Pim:
	if pim_name == "":
		assert(pims.size() == 1)
		return pims[0]
	for pim in pims:
		if pim.name == pim_name:
			return pim
	return null


func move_signal_to_slot(
	info_signal: NumberSignal, slot: MemoSlot, callback := Callable()
) -> void:
	const TWEEN_TIME := 1.0
	const SLOT_PADDING := 2.0

	# Calculate new position
	var slot_position = slot.get_global_rect().get_center()
	var dest_position = overlay_position_to_effect_layer(slot_position)

	# Calculate new scale
	var slot_size = slot.get_content_rect(SLOT_PADDING).size
	var signal_size = info_signal.get_base_size()
	var growth_ratio = minf(slot_size.x / signal_size.x, slot_size.y / signal_size.y)
	var dest_scale = Vector2(growth_ratio, growth_ratio)

	# Tween to new position and scale
	var tween_time := TWEEN_TIME * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(info_signal, "global_position", dest_position, tween_time)
	tween.parallel().tween_property(info_signal, "scale", dest_scale, tween_time)
	tween.tween_callback(callback)


func set_trial_progress(completed: int, required: int, failed := false) -> void:
	var fraction_text := str(completed) + " / " + str(required)
	if failed:
		%TrialButtonTimeLimitBar.hide()
		%TrialButtonFractionLabel.text = "Oops! " + fraction_text
	elif completed < required:
		%TrialButtonTimeLimitBar.show()
		%TrialButtonFractionLabel.text = fraction_text
	else:
		%TrialButtonTimeLimitBar.hide()
		%TrialButtonFractionLabel.text = "Success! " + fraction_text


# Times should be in seconds
func set_trial_time(remaining: float, limit: float) -> void:
	assert(limit > 0.0)

	%TrialButtonTimeLimitBar.value = (remaining / limit)


#====================================================================
# Drag and Drop
#====================================================================


func start_memo_drag(memo: Memo) -> void:
	assert(memo != null)

	var preview := MemoDragPreview.instantiate()
	%MemoDragSource.force_drag(memo, preview)
	preview.label.text = memo.get_string()

	memo_drag_started.emit(memo)
	preview.tree_exited.connect(memo_drag_ended.emit.bind(memo))


func start_interfield_drag(object: FieldObject) -> void:
	assert(object != null)
	assert(dragged_object == null)

	dragged_object = object
	for field in fields:
		field.dragged_object = dragged_object

	create_interfield_object(object.object_data)


func create_interfield_object(object_data: FieldObjectData) -> InterfieldObject:
	var interfield_object := InterfieldObjectScene.instantiate()
	interfield_object.setup(object_data)
	%DraggedObjectLayer.add_child(interfield_object)
	return interfield_object


func process_interfield_drag(object_data: FieldObjectData) -> void:
	# Obtain relevant variables
	var source: Field = null
	if dragged_object != null:
		source = dragged_object.field
	var destination: Field
	var external_point: Vector2 = %PimStrip.get_global_mouse_position()
	var field_point: Vector2
	for pim in _pims_left_to_right:
		var field = pim.get_field_at_point(external_point)
		if field != null:
			destination = field
			field_point = pim.convert_external_to_internal_point(external_point)
			break

	# React in destination
	if destination != null and destination != source:
		destination._dragged_in(object_data, field_point, source)

	# React in old destination if exiting
	elif _last_destination != null and destination != _last_destination:
		_last_destination._dragged_out(object_data, field_point, source)

	_last_destination = destination


func process_interfield_drop(object_data: FieldObjectData) -> void:
	# Obtain relevant variables
	var source: Field = null
	if dragged_object != null:
		source = dragged_object.field
	var destination: Field
	var external_point: Vector2 = %PimStrip.get_global_mouse_position()
	var field_point: Vector2
	for pim in _pims_left_to_right:
		var field = pim.get_field_at_point(external_point)
		if field != null:
			destination = field
			field_point = pim.convert_external_to_internal_point(external_point)
			break

	# React in source field to drop in other field
	if source != null and destination != source:
		dragged_object._end_external_drag(true, field_point, destination)

	if destination != null:
		# React in field to drop within itself
		if destination == source:
			dragged_object._end_external_drag(false, field_point)

		# React in destination field to drop from anywhere
		else:
			destination._received_in(object_data, field_point, source)

	if dragged_object != null:
		for field in fields:
			field._end_drag()
		dragged_object = null
