##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends StaticDictionary

static func get_data() -> Dictionary:
	return {
		BubbleSumGlobals.Objects.UNIT: preload("spawners/unit_spawner.tscn"),
		BubbleSumGlobals.Objects.BUBBLE: preload("spawners/bubble_spawner.tscn"),
	}
