#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name LevelNode
extends TopicNode

var level_data: LevelResource


func setup(value: LevelResource) -> void:
	level_data = value
	id = level_data.id

	# Set title
	%MaskLabel.text = level_data.title
	if level_data.title.length() > 10:
		%MaskLabel.label_settings.font_size = 14
	else:
		%MaskLabel.label_settings.font_size = 16
	%OverviewLabel.text = level_data.title

	# Set thumbnail
	if level_data.thumbnail != null:
		%Thumbnail.texture = level_data.thumbnail
	else:
		%Thumbnail.hide()
		%ThumbnailPlaceholder.show()

	# Set progress
	if Game.progress_data.is_level_completed(id):
		%MaskCheckBox.button_pressed = true
		%OverviewCheckBox.button_pressed = true
	else:
		%MaskCheckBox.button_pressed = false
		%OverviewCheckBox.button_pressed = false
