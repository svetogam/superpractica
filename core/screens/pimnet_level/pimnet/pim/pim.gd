#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Pim
extends Panel

const DEFAULT_FIELD_NAME := "field"
const DEFAULT_SLOT_NAME := "slot"
var field_map := {}
var slot_map := {}
# Shortcut assuming 1 field
var field: Field:
	get:
		assert(field_map.values().size() == 1)
		return field_map.values()[0].field
# Shortcut assuming 1 field
var field_container: SubViewportContainer:
	get:
		assert(field_map.values().size() == 1)
		return field_map.values()[0].container
# Shortcut assuming 1 field
var field_viewport: SubViewport:
	get:
		assert(field_map.values().size() == 1)
		return field_map.values()[0].viewport
var _effects: MathEffectGroup
@onready var programs := $Programs as ModeGroup


func _enter_tree() -> void:
	CSLocator.with(self).connect_service_changed(
			Game.SERVICE_ROOT_EFFECT_LAYER, _on_effect_layer_changed)


func get_program(program_name: String) -> PimProgram:
	return programs.get_mode(program_name)


#====================================================================
# Field Stuff
#====================================================================

func _setup_field(viewport_container: SubViewportContainer,
		field_name := DEFAULT_FIELD_NAME
) -> void:
	# Find viewport
	var viewport: SubViewport = viewport_container.get_child(0)
	assert(viewport != null)

	# Find field
	var found_field: Field
	for child in viewport.get_children():
		if child is Field:
			found_field = child
			break
	assert(found_field != null)

	field_map[field_name] = {
		"field": found_field,
		"container": viewport_container,
		"viewport": viewport,
	}
	found_field.updated.connect(focus_entered.emit)
	focus_entered.connect(_on_field_focused.bind(found_field))


func _on_field_focused(p_field: Field) -> void:
	p_field._on_selected()


func reset() -> void:
	for field_dict in field_map.values():
		field_dict.field.reset_state()


func has_field() -> bool:
	return not field_map.is_empty()


func get_field_at_point(external_point: Vector2) -> Field:
	for field_dict in field_map.values():
		if field_dict.container.get_global_rect().has_point(external_point):
			return field_dict.field
	return null


func convert_external_to_internal_point(external_point: Vector2) -> Vector2:
	var local_point := _convert_external_to_local_point(external_point)
	return _convert_local_to_internal_point(local_point)


func convert_internal_to_external_point(internal_point: Vector2) -> Vector2:
	var local_point := _convert_internal_to_local_point(internal_point)
	return _convert_local_to_external_point(local_point)


func _convert_external_to_local_point(external_point: Vector2) -> Vector2:
	return external_point - field_container.global_position


func _convert_local_to_external_point(local_point: Vector2) -> Vector2:
	return local_point + field_container.global_position


func _convert_local_to_internal_point(local_point: Vector2) -> Vector2:
	#return local_point / camera.zoom + camera.offset
	return local_point


func _convert_internal_to_local_point(internal_point: Vector2) -> Vector2:
	#return (internal_point - camera.offset) * camera.zoom
	return internal_point


func convert_external_to_internal_vector(external_vector: Vector2) -> Vector2:
	#return external_vector / camera.zoom
	return external_vector


func convert_internal_to_external_vector(internal_vector: Vector2) -> Vector2:
	#return internal_vector * camera.zoom
	return internal_vector


#====================================================================
# Slot Stuff
#====================================================================

# Virtual
func _on_slot_changed(_memo: Memo, _slot_name: String) -> void:
	pass


func _setup_slot(slot: MemoSlot, slot_name := DEFAULT_SLOT_NAME) -> void:
	slot_map[slot_name] = slot
	slot.memo_changed.connect(_on_slot_changed.bind(slot_name))


func set_slot(memo_type: GDScript, value: Variant, slot_name := DEFAULT_SLOT_NAME
) -> void:
	assert(slot_map.has(slot_name))
	slot_map[slot_name].set_memo(memo_type, value)


func set_slot_empty(slot_name := DEFAULT_SLOT_NAME) -> void:
	assert(slot_map.has(slot_name))
	slot_map[slot_name].set_empty()


func set_slot_input_output_ability(input: bool, output: bool,
		slot_name := DEFAULT_SLOT_NAME
) -> void:
	assert(slot_map.has(slot_name))
	slot_map[slot_name].set_input_output_ability(input, output)


func get_slot(slot_name := DEFAULT_SLOT_NAME) -> MemoSlot:
	assert(slot_map.has(slot_name))
	return slot_map[slot_name]


func get_slot_value(slot_name := DEFAULT_SLOT_NAME) -> Variant:
	assert(slot_map.has(slot_name))
	return slot_map[slot_name].memo.get_value()


func is_slot_empty(slot_name := DEFAULT_SLOT_NAME) -> bool:
	assert(slot_map.has(slot_name))
	return slot_map[slot_name].is_empty()


func get_slot_string(slot_name := DEFAULT_SLOT_NAME) -> String:
	assert(slot_map.has(slot_name))
	return slot_map[slot_name].memo.get_string()


func get_slot_position(slot_name := DEFAULT_SLOT_NAME) -> Vector2:
	assert(slot_map.has(slot_name))
	return slot_map[slot_name].get_global_rect().get_center()


func create_number_effect(slot_name := DEFAULT_SLOT_NAME) -> NumberEffect:
	assert(slot_map.has(slot_name))
	if _effects != null:
		var number = get_slot_value(slot_name)
		var number_position := get_slot_position(slot_name)
		return _effects.give_number(number, number_position, "grow") as NumberEffect
	else:
		return null


func clear_effects() -> void:
	if _effects != null:
		_effects.clear()


func _on_effect_layer_changed(effect_layer: CanvasLayer) -> void:
	if _effects == null and effect_layer != null:
		_effects = MathEffectGroup.new(effect_layer)
	elif _effects != null and effect_layer == null:
		_effects = null
