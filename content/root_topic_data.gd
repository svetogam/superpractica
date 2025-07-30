# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

static var root_topic = TopicResource.new(
	# ID
	"root",
	# Title
	"Topics",
	# Background
	TopicMap.Backgrounds.BLUE_TRIANGLES,
	# Levels
	[],
	# Subtopics
	[
		preload("packs/basic_addition/pack_data.gd").root_topic,
		preload("packs/debug/pack_data.gd").root_topic,
	],
	# Layout
	preload("root_topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
