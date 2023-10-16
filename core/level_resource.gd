##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name LevelResource
extends Resource

export(String) var name
export(String) var _name_text
export(PackedScene) var _scene


func get_name() -> String:
	return name


func get_name_text() -> String:
	return _name_text


func get_scene() -> PackedScene:
	return _scene
