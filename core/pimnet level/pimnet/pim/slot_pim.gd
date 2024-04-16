#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SlotPim
extends Pim

const DEFAULT_SLOT_NAME := "slot"
var slot_map := {}
var _effects: MathEffectGroup
var _locator := ContextualLocator.new(self)


func _enter_tree() -> void:
	_locator.auto_callback("effect_layer", _setup_effect_creator)


func _setup_effect_creator(effect_layer: CanvasLayer) -> void:
	_effects = MathEffectGroup.new(effect_layer)


func _setup_slot(slot: MemoSlot, slot_name := DEFAULT_SLOT_NAME) -> void:
	slot_map[slot_name] = slot
	slot.memo_changed.connect(_on_slot_changed.bind(slot_name))


# Virtual
func _on_slot_changed(_memo: Memo, _slot_name: String) -> void:
	pass


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
	return slot_map[slot_name].get_global_center()


func create_number_effect(slot_name := DEFAULT_SLOT_NAME) -> NumberEffect:
	assert(_effects != null)
	assert(slot_map.has(slot_name))
	var number = get_slot_value(slot_name)
	var number_position := get_slot_position(slot_name)
	return _effects.give_number(number, number_position, "grow") as NumberEffect


func clear_effects() -> void:
	_effects.clear()
