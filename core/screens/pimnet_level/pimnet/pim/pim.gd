# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Pim
extends PanelContainer

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
# Shortcut assuming 1 slot
var slot: MemoSlot:
	get:
		assert(slot_map.values().size() == 1)
		return slot_map.values()[0]
@onready var programs := $Programs as ModeGroup


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	var frame = get_theme_stylebox("focus")
	var panel = get_theme_stylebox("panel")
	draw_style_box(frame, rect)
	draw_style_box(panel, rect)


func _enter_tree() -> void:
	CSConnector.with(self).connect_setup(Game.AGENT_FIELD, _setup_field)
	CSConnector.with(self).connect_setup(Game.AGENT_MEMO_SLOT, _setup_slot)


func get_program(program_name: String) -> PimProgram:
	return programs.get_mode(program_name)


#====================================================================
# Field Stuff
#====================================================================

func _setup_field(p_field: Field) -> void:
	var viewport: SubViewport = p_field.get_parent()
	assert(viewport != null)
	var container: SubViewportContainer = viewport.get_parent()
	assert(container != null)

	field_map[p_field.name] = {
		"field": p_field,
		"container": container,
		"viewport": viewport,
	}

	item_rect_changed.connect(_update_field_signalers)
	container.item_rect_changed.connect(_update_field_signalers)
	p_field.updated.connect(focus_entered.emit)
	focus_entered.connect(_on_field_focused.bind(p_field))


func _update_field_signalers() -> void:
	for dict in field_map.values():
		dict.field.info_signaler.position = dict.container.global_position
		dict.field.warning_effects.position = dict.container.global_position
		dict.field.effect_counter.position = dict.container.global_position


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


func _setup_slot(p_slot: MemoSlot) -> void:
	slot_map[p_slot.name] = p_slot
	p_slot.memo_changed.connect(_on_slot_changed.bind(p_slot.name))


func get_slot(slot_name: String) -> MemoSlot:
	return slot_map.get(slot_name)


func get_slot_position(slot_name: String) -> Vector2:
	assert(slot_map.has(slot_name))
	return slot_map[slot_name].get_global_rect().get_center()
