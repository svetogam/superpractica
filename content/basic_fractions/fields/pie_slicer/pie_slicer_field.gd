##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Field

export(int) var pie_radius := 200
onready var pie := $"%Pie"


func get_globals() -> GDScript:
	return PieSlicerGlobals


func _on_update(update_type: int) -> void:
	if update_type == UpdateTypes.TOOL_MODE_CHANGED:
		actions.clear_count()
		actions.deselect_regions()


func reset_state() -> void:
	push_action("set_empty_pie")


func update_pie_regions() -> void:
	var slice_list = queries.get_nonphantom_slice_list()
	pie.set_regions_by_slices(slice_list)
