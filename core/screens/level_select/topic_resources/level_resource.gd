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

@export var id: String
@export var scene: PackedScene
@export var title: String
@export var program_vars: LevelProgramVars
@export var thumbnail: Texture2D
var topic: TopicResource


func _init(p_id := "", p_scene: PackedScene = null, p_title := "",
		p_program_vars: LevelProgramVars = null, p_thumbnail: Texture2D = null
) -> void:
	id = p_id
	scene = p_scene
	title = p_title
	program_vars = p_program_vars
	thumbnail = p_thumbnail
