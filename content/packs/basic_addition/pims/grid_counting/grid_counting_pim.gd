# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Pim

signal output_decided(output_number) #int with -1 for no output

@export var _enable_output_slot := false


func _ready() -> void:
	enable_output_slot(_enable_output_slot)


func enable_output_slot(enable := true) -> void:
	if enable:
		$StateChart.send_event.call_deferred("enable_output_slot")
	else:
		$StateChart.send_event.call_deferred("disable_output_slot")


func _on_output_slot_on_state_entered() -> void:
	slot.show()
	_update_output_memo()
	MrGodotPlz.update_sizes_in_container(self)
	if not field.updated.is_connected($StateChart.step):
		field.updated.connect($StateChart.step)


func _on_output_slot_off_state_entered() -> void:
	slot.hide()
	slot.set_empty()
	MrGodotPlz.update_sizes_in_container(self)
	if field.updated.is_connected($StateChart.step):
		field.updated.disconnect($StateChart.step)


func _on_output_slot_on_state_stepped() -> void:
	_update_output_memo()


func _update_output_memo() -> void:
	var output_number = _calc_output_number()
	if output_number == -1:
		slot.set_empty()
	else:
		slot.set_memo(IntegerMemo, output_number)
	output_decided.emit(output_number)


func _calc_output_number() -> int:
	var marks = field.get_marked_numbers()
	if marks.size() > 1:
		return -1

	var first_number: int
	if marks.size() == 0:
		first_number = 0
	else:
		first_number = marks[0]
	var contiguous_numbers = field.get_contiguous_occupied_numbers_from(first_number + 1)
	if contiguous_numbers.is_empty():
		return first_number
	else:
		return contiguous_numbers.back()
