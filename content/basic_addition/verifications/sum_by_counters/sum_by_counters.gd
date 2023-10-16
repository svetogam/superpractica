##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Verification

var pim: Pim
var slot_panel: SlotPanel
var setup_completed: bool


func setup(p_pim: Pim, p_slot_panel: SlotPanel) -> void:
	setup_completed = true
	pim = p_pim
	slot_panel = p_slot_panel
