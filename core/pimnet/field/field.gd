##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Field
extends Subscreen

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
var math_effects: MathEffectGroup
var counter: EffectCounter
var _got_ready := false
@onready var queries := $Queries as FieldInterfaceComponent
@onready var actions := $Actions as FieldInterfaceComponent
@onready var programs := $Programs as ModeGroup
@onready var effect_layer := %EffectLayer as CanvasLayer
@onready var _metanavig := $Metanavig as FieldMetanavigComponent
@onready var _tool_modes := $ToolModes as ModeGroup
@onready var _field_limit := %FieldLimit as Marker2D
@onready var _object_factory := $ObjectFactory as NodeFactory
@onready var _process_factory := $ProcessFactory as NodeFactory


#Virtual
func get_globals() -> GDScript:
	assert(false)
	return null


func _enter_tree() -> void:
	super()
	ContextualConnector.register(self)


func _ready() -> void:
	super()
	math_effects = MathEffectGroup.new(effect_layer)
	counter = EffectCounter.new(effect_layer)

	set_rect(Vector2.ZERO, _field_limit.position)
	ready.connect(_trigger_update.bind(UpdateTypes.INITIAL))
	tool_changed.connect(_on_tool_changed)
	action_queue.flushed.connect(_trigger_update.bind(UpdateTypes.ACTIONS_COMPLETED))
	_process_factory.connect_setup_on_all("setup")
	_got_ready = true


func is_ready() -> bool:
	return _got_ready


func _trigger_update(update_type: int) -> void:
	_on_update(update_type)
	updated.emit()


#####################################################################
# Virtual Mechanics
#####################################################################

#Virtual
func _on_update(_update_type: int) -> void:
	pass


#Virtual
func reset_state() -> void:
	pass


#Virtual
func on_internal_drop(_object: FieldObject, _point: Vector2) -> void:
	assert(false)


#Virtual
func on_incoming_drop(_object: InterfieldObject, _point: Vector2, _source: Field) -> void:
	assert(false)


#Virtual
func on_outgoing_drop(_object: FieldObject) -> void:
	assert(false)


#####################################################################
# Tools and Modes
#####################################################################

func set_tool(tool_mode: String) -> void:
	if tool_mode != get_tool():
		if tool_mode != "":
			_tool_modes.activate_only(tool_mode)
		else:
			_tool_modes.deactivate_all()
		tool_changed.emit(tool_mode)


func set_no_tool() -> void:
	set_tool("")


func _on_tool_changed(_new_tool: String) -> void:
	_trigger_update(UpdateTypes.TOOL_MODE_CHANGED)


func get_active_modes_for_object(object_type: int) -> Array[String]:
	var object_modes_map = _get_object_modes_map()
	if object_modes_map.has(object_type):
		return object_modes_map[object_type]
	else:
		return []


func _get_object_modes_map() -> Dictionary:
	var tool_name = get_tool()
	if tool_name != "":
		var tool_mode := _tool_modes.get_mode(tool_name)
		return tool_mode.get_object_modes_map()
	else:
		return {}


func get_tool() -> String:
	if _tool_modes != null:
		return _tool_modes.get_only_active_mode_name()
	else:
		return ""


func get_tool_mode_to_text_map() -> Dictionary:
	var tool_mode_to_text_map = {}
	for tool_mode in _tool_modes.get_modes():
		tool_mode_to_text_map[tool_mode.name] = tool_mode.get_label_text()
	return tool_mode_to_text_map


#####################################################################
# Object Management
#####################################################################

func create_object(object_type: int) -> FieldObject:
	return _object_factory.create(object_type)


func get_field_objects() -> Array:
	var field_object_list = []
	for object in ContextUtils.get_children_in_group(self, "field_objects"):
		if not object.is_queued_for_deletion():
			field_object_list.append(object)
	return field_object_list


func get_object_list_by_type(object_type: int) -> Array:
	var map = get_globals().OBJECT_TO_GROUP_MAP
	assert(map.has(object_type))
	var group = map[object_type]
	return get_objects_by_group(group)


func get_objects_by_group(group: String, include_hidden:=false) -> Array:
	var object_list = get_field_objects()
	var objects_in_group = Utils.filter_objects_by_group(object_list, group)
	if not include_hidden:
		return Utils.filter_objects_by_visibility(objects_in_group)
	else:
		return objects_in_group


func get_object_at_point(point: Vector2) -> FieldObject:
	var objects = _get_objects_sorted_by_input_priority()
	for object in objects:
		if object.has_point(point):
			return object
	return null


#####################################################################
# Mechanics
#####################################################################

func request_interfield_drag(original: FieldObject) -> void:
	interfield_object_requested.emit(original)


func request_drag_memo(memo: Memo) -> void:
	dragged_memo_requested.emit(memo)


func push_action(action_name: String, args:=[]) -> void:
	action_queue.push_action_or_empty(action_name, args)


func connect_condition(action_name: String, object: Object, method: String) -> void:
	action_queue.connect_condition(action_name, object, method)


func disconnect_condition(action_name: String, object: Object, method: String) -> void:
	action_queue.disconnect_condition(action_name, object, method)


func connect_post_action(action_name: String, object: Object, method: String) -> void:
	action_queue.connect_post_action(action_name, object, method)


func disconnect_post_action(action_name: String, object: Object, method: String) -> void:
	action_queue.disconnect_post_action(action_name, object, method)


func run_process(process_name: String, args:=[],
			callback_object: Object =null, callback_method:="") -> FieldProcess:
	var process = _process_factory.create(process_name, args)
	process.run_on(self, callback_object, callback_method)
	return process


func get_program(program_name: String) -> FieldProgram:
	return programs.get_mode(program_name)


func clear_effects() -> void:
	math_effects.clear()
	counter.reset_count()


#####################################################################
# Mem-States
#####################################################################

func build_mem_state() -> MemState:
	assert(_metanavig.get_script() != null)
	return _metanavig.build()


func load_mem_state(mem_state: MemState) -> void:
	assert(_metanavig.get_script() != null)
	_metanavig.load_state(mem_state)
	_trigger_update(UpdateTypes.STATE_LOADED)


#####################################################################
# Input
#####################################################################

func _superscreen_input(event: SubscreenInputEvent) -> void:
	var object_list = _get_objects_sorted_by_input_priority()
	_give_input_to_objects_until_handled(object_list, event)


func _get_objects_sorted_by_input_priority() -> Array:
	var object_list = get_field_objects()
	object_list.sort_custom(Callable(self, "_sort_by_input_priority"))
	return object_list


static func _sort_by_input_priority(object_1: FieldObject, object_2: FieldObject) -> bool:
	return object_1.has_input_priority_over_other(object_2)


func _give_input_to_objects_until_handled(object_list: Array, event: SubscreenInputEvent) -> void:
	for object in object_list:
		if not event.is_completed():
			object.take_input(event)
