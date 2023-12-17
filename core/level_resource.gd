#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name LevelResource
extends Resource

@export var name: String
@export var _name_text: String
@export var _scene: PackedScene


func get_name_text() -> String:
	return _name_text


func get_scene() -> PackedScene:
	return _scene
