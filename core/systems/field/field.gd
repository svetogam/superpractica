# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Field
extends Node

signal updated
signal tool_changed(tool_mode)
signal external_drag_requested(original)
signal dragged_memo_requested(memo)

enum UpdateTypes {
	INITIAL,
	TOOL_MODE_CHANGED,
	ACTIONS_COMPLETED,
	STATE_LOADED,
}

var action_queue := FieldActionQueue.new(self)
var tool_mode: int = Game.NO_TOOL
var dragged_object: FieldObject
var field_type: String:
	get = _get_field_type
var interface_data: FieldInterfaceData:
	get = _get_interface_data
@onready var effect_layer := %EffectLayer as CanvasLayer
@onready var info_signaler := %InfoSignaler as InfoSignaler
@onready var warning_signaler := %WarningSignaler as WarningSignaler
@onready var count_signaler := %CountSignaler as CountSignaler
@onready var programs := $Programs as ModeGroup


# Virtual
static func _get_field_type() -> String:
	assert(false)
	return ""


# Virtual
static func _get_interface_data() -> FieldInterfaceData:
	assert(false)
	return null


func _enter_tree() -> void:
	CSConnector.with(self).register(Game.AGENT_FIELD)
	CSLocator.with(self).connect_service_found(Game.SERVICE_REVERTER, _on_reverter_found)


func _ready() -> void:
	tool_changed.connect(_on_tool_changed)
	action_queue.flushed.connect(_trigger_update.bind(UpdateTypes.ACTIONS_COMPLETED))
	CSLocator.with(self).connect_service_found(Game.SERVICE_ROOT_EFFECT_LAYER,
			_on_root_effect_layer_found)
	CSLocator.with(self).register(Game.SERVICE_FIELD, self)

	_trigger_update(UpdateTypes.INITIAL)


func _exit_tree() -> void:
	info_signaler.free()
	warning_signaler.free()
	count_signaler.free()


func _on_reverter_found(reverter: CReverter) -> void:
	reverter.connect_save_load(get_instance_id(), build_state, load_state)


func _on_root_effect_layer_found(p_effect_layer: CanvasLayer) -> void:
	effect_layer = p_effect_layer
	info_signaler.reparent(effect_layer)
	warning_signaler.reparent(effect_layer)
	count_signaler.reparent(effect_layer)


func _trigger_update(update_type: int) -> void:
	_on_update(update_type)
	updated.emit()
	warning_signaler.flush_stage()


# Virtual
func _on_update(_update_type: int) -> void:
	pass


# Virtual
func reset_state() -> void:
	pass


# Virtual
func _dragged_in(_object_data: FieldObjectData, _point: Vector2, _source: Field) -> void:
	pass


# Virtual
func _dragged_out(_object_data: FieldObjectData, _point: Vector2, _source: Field) -> void:
	pass


# Virtual
func _received_in(_object_data: FieldObjectData, _point: Vector2, _source: Field) -> void:
	pass


# Virtual
func _on_selected() -> void:
	pass


# Virtual
func build_state() -> CRMemento:
	assert(false)
	return null


# Call this _trigger_update line after loading in implementations:
	#_trigger_update(UpdateTypes.STATE_LOADED)
# Virtual
func load_state(_state: CRMemento) -> void:
	assert(false)


# Virtual
func get_objects_by_type(_object_type: int) -> Array:
	return []


func set_tool(p_tool_mode: int) -> void:
	if p_tool_mode != tool_mode:
		tool_mode = p_tool_mode
		tool_changed.emit(tool_mode)


func _on_tool_changed(_new_tool: int) -> void:
	_trigger_update(UpdateTypes.TOOL_MODE_CHANGED)


func get_active_modes_for_object(object_type: int) -> Array:
	return interface_data.get_object_modes(tool_mode, object_type)


func drag_object(original: FieldObject, external_drag := false) -> void:
	if external_drag:
		external_drag_requested.emit(original)
	else:
		dragged_object = original


func end_drag() -> void:
	dragged_object = null


func request_drag_memo(memo: Memo) -> void:
	dragged_memo_requested.emit(memo)


func get_program(program_name: String) -> FieldProgram:
	return programs.get_mode(program_name)


func get_active_programs() -> Array:
	return programs.get_active_modes()
