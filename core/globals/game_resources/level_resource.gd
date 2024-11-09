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
@export var title: String
@export var thumbnail: Texture2D
@export var pimnet_setup: PimnetSetupResource
@export var program: PackedScene
@export var program_vars: LevelProgramVars
@export var program_plan: PlanResource
var topic: TopicResource


func _init(
		p_id := "",
		p_title := "",
		p_thumbnail: Texture2D = null,
		p_pimnet_setup: PimnetSetupResource = null,
		p_program: PackedScene = null,
		p_program_vars: LevelProgramVars = null,
		p_program_plan: PlanResource = null,
) -> void:
	id = p_id
	title = p_title
	thumbnail = p_thumbnail
	pimnet_setup = p_pimnet_setup
	program = p_program
	program_vars = p_program_vars
	program_plan = p_program_plan
