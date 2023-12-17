#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldToolMode


func get_label_text() -> String:
	return "Delete Counter"


func get_object_modes_map() -> Dictionary:
	return {
		CountingBoard.Objects.COUNTER: ["delete"],
	}
