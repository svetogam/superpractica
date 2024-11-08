#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Resource


static var topic = TopicResource.new(
	# ID
	"test_topic_1",
	# Title
	"Test Topics",
	# Levels
	[
		LevelResource.new(
			# ID
			"dummy_level_1_1",
			# Scene
			null,
			# Title
			"Level 1.1",
			# Program Vars
			# Thumbnail
		),
	],
	# Subtopics
	[
		preload("topic_2.gd").topic,
		preload("topic_3.gd").topic,
	],
	# Layout
	preload("topic_1_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
