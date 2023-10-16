##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldProgram


func _start() -> void:
	action_queue.connect_post_action("add_slice", self, "_on_slices_changed")
	action_queue.connect_post_action("remove_slice", self, "_on_slices_changed")


func _on_slices_changed(_arg) -> void:
	field.actions.update_slice_warnings_by_guides()


func _end() -> void:
	action_queue.disconnect_post_action("add_slice", self, "_on_slices_changed")
	action_queue.disconnect_post_action("remove_slice", self, "_on_slices_changed")
