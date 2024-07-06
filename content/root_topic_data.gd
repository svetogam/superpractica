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
	"root",
	# Title
	"Topics",
	# Levels
	[],
	# Subtopics
	[
		preload("basic_addition/topic_data.gd").topic,
		preload("debug/topic_data.gd").topic,
	],
	# Layout
	preload("root_topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
