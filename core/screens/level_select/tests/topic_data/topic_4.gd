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
	"test_topic_4",
	# Title
	"Topic 4",
	# Levels
	[
		LevelResource.new(
			# ID
			"dummy_level_4_1",
			# Scene
			null,
			# Title
			"Level 4.1",
			# Thumbnail
		),
	],
	# Subtopics
	[],
	# Layout
	preload("topic_4_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
