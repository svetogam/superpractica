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
	"test_topic_2",
	# Title
	"Topic 2",
	# Levels
	[
		LevelResource.new(
			# ID
			"dummy_level_2_1",
			# Scene
			null,
			# Title
			"Level 2.1",
			# Program Vars
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"dummy_level_2_2",
			# Scene
			null,
			# Title
			"Level 2.2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"dummy_level_2_3",
			# Scene
			null,
			# Title
			"Level 2.3",
			# Thumbnail
		),
	],
	# Subtopics
	[],
	# Layout
	preload("topic_2_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
