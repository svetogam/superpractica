##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node

var level_group_1 := preload("res://content/basic_addition/levels/level_group/level_group.tres")
var level_group_2 := preload("res://content/basic_fractions/levels/level_group/level_group.tres")
var level_group_3 := preload("res://content/debug/levels/level_group/level_group.tres")


func _ready() -> void:
	randomize()

	Game.level_loader.add_level_group(level_group_1)
	Game.level_loader.add_level_group(level_group_2)
	Game.level_loader.add_level_group(level_group_3)
