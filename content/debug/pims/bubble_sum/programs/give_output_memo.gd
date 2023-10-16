##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends PimProgram


func _start() -> void:
	_update_output_slot()
	field.connect("updated", self, "_update_output_slot")


func _update_output_slot() -> void:
	var memo = _get_output_memo()
	if memo != null:
		pim.menu_control.memo_output_slot.set_by_memo(memo)
	else:
		pim.menu_control.memo_output_slot.set_no_memo_with_text("No selection")


func _get_output_memo() -> Memo:
	match field.get_tool():
		"UnitSelector":
			return field.queries.get_selected_unit_sum()
		"BubbleSelector":
			return field.queries.get_selected_bubble_sum()
		"UnitCounter":
			return field.queries.get_selected_unit_sum()
		_:
			return null


func _end() -> void:
	field.disconnect("updated", self, "_update_output_slot")
