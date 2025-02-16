#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Pim

@onready var output_slot: MemoSlot = %OutputSlot as MemoSlot


func _ready() -> void:
	_setup_field(%FieldContainer)

	_setup_slot(output_slot)
	set_slot_empty()
	output_slot.hide()
