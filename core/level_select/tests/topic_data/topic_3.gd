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
	"test_topic_3",
	# Title
	"Topic 3",
	# Levels
	[],
	# Subtopics
	[
		preload("topic_4.gd").topic,
	],
	# Layout
	preload("topic_3_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
