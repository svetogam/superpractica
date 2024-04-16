#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Field
extends Node

signal updated
signal tool_changed(tool_mode)
signal interfield_object_requested(original)
signal dragged_memo_requested(memo)

enum UpdateTypes {
	INITIAL,
	TOOL_MODE_CHANGED,
	ACTIONS_COMPLETED,
	STATE_LOADED,
}

var action_queue := FieldActionQueue.new(self)
var dragged_object: FieldObject:
	set = _do_not_set,
	get = _get_dragged_object
var math_effects: MathEffectGroup:
	get = _get_math_effects
var effect_counter: EffectCounter:
	get = _get_effect_counter
var interface_data: PimInterfaceData:
	set = _do_not_set,
	get = _get_interface_data
var _got_ready := false
@onready var programs := $Programs as ModeGroup
@onready var effect_layer := %EffectLayer as CanvasLayer
@onready var _tool_modes := $ToolModes as ModeGroup


func _enter_tree() -> void:
	ContextualConnector.register(self)


func _ready() -> void:
	ready.connect(_trigger_update.bind(UpdateTypes.INITIAL))
	tool_changed.connect(_on_tool_changed)
	action_queue.flushed.connect(_trigger_update.bind(UpdateTypes.ACTIONS_COMPLETED))
	_got_ready = true


func is_ready() -> bool:
	return _got_ready


# Virtual
func get_field_type() -> String:
	assert(false)
	return ""


# Virtual
static func _get_interface_data() -> PimInterfaceData:
	assert(false)
	return null


func _trigger_update(update_type: int) -> void:
	_on_update(update_type)
	updated.emit()


func _get_dragged_object() -> FieldObject:
	var pimnet := ContextUtils.get_parent_in_group(self, "pimnet")
	return pimnet.dragged_object


func _get_math_effects() -> MathEffectGroup:
	if math_effects == null:
		math_effects = MathEffectGroup.new(effect_layer)
	return math_effects


func _get_effect_counter() -> EffectCounter:
	if effect_counter == null:
		effect_counter = EffectCounter.new(effect_layer)
	return effect_counter


static func _do_not_set(_value: Variant) -> void:
	assert(false)


#====================================================================
# Virtual Mechanics
#====================================================================

# Virtual
func _on_update(_update_type: int) -> void:
	pass


# Virtual
func reset_state() -> void:
	pass


# Virtual
func _incoming_drop(_object: InterfieldObject, _point: Vector2, _source: Field) -> void:
	assert(false)


# Virtual
func _outgoing_drop(_object: FieldObject) -> void:
	assert(false)


# Virtual
func _on_selected() -> void:
	pass


#====================================================================
# Tools and Modes
#====================================================================

func on_tool_panel_tool_selected(field_type: String, tool_mode: int) -> void:
	if field_type == get_field_type():
		set_tool(tool_mode)


func set_tool(tool_mode: int) -> void:
	if tool_mode != get_tool():
		if tool_mode != GameGlobals.NO_TOOL:
			var tool_name := interface_data.get_tool_name(tool_mode)
			_tool_modes.activate_only(tool_name)
		else:
			_tool_modes.deactivate_all()
		tool_changed.emit(tool_mode)


func deactivate_tools() -> void:
	set_tool(GameGlobals.NO_TOOL)


func _on_tool_changed(_new_tool: int) -> void:
	_trigger_update(UpdateTypes.TOOL_MODE_CHANGED)


func get_active_modes_for_object(object_type: int) -> Array:
	var tool_mode := get_tool()
	return interface_data.get_object_modes(tool_mode, object_type)


func get_tool() -> int:
	if _tool_modes != null:
		var tool_name := _tool_modes.get_only_active_mode_name()
		return interface_data.get_tool_by_name(tool_name)
	else:
		return GameGlobals.NO_TOOL


#====================================================================
# Object Management
#====================================================================

func get_field_objects() -> Array:
	var field_objects: Array = []
	for object in ContextUtils.get_children_in_group(self, "field_objects"):
		if not object.is_queued_for_deletion():
			field_objects.append(object)
	return field_objects


func get_objects_in_group(group: String) -> Array:
	var field_objects := get_field_objects()
	return field_objects.filter(func(object: Node): return object.is_in_group(group))


#====================================================================
# Mechanics
#====================================================================

func request_interfield_drag(original: FieldObject) -> void:
	interfield_object_requested.emit(original)
	get_viewport().set_input_as_handled()


func request_drag_memo(memo: Memo) -> void:
	dragged_memo_requested.emit(memo)


func push_action(action: Callable) -> void:
	action_queue.push(action)

	if ContextUtils.get_parent_in_group(self, "levels") == null:
		action_queue.flush()


func connect_condition(action_name: String, callable: Callable) -> void:
	action_queue.connect_condition(action_name, callable)


func disconnect_condition(action_name: String, callable: Callable) -> void:
	action_queue.disconnect_condition(action_name, callable)


func connect_post_action(action_name: String, callable: Callable) -> void:
	action_queue.connect_post_action(action_name, callable)


func disconnect_post_action(action_name: String, callable: Callable) -> void:
	action_queue.disconnect_post_action(action_name, callable)


func get_program(program_name: String) -> FieldProgram:
	return programs.get_mode(program_name)


func clear_effects() -> void:
	math_effects.clear()
	effect_counter.reset_count()


#====================================================================
# Mem-States
#====================================================================

# Virtual
func build_mem_state() -> MemState:
	assert(false)
	return null


# Call this _trigger_update line after loading in implementations:
	#_trigger_update(UpdateTypes.STATE_LOADED)
# Virtual
func load_mem_state(_mem_state: MemState) -> void:
	assert(false)
