#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name TopicNode
extends Control

var id: String
@onready var mask := %MaskContainer as SubViewportContainer:
	set(_value):
		assert(false)
@onready var mask_button := %MaskButton as BaseButton:
	set(_value):
		assert(false)
@onready var overview_panel := %OverviewPanel as Control:
	set(_value):
		assert(false)
@onready var overview_button := %OverviewButton as BaseButton:
	set(_value):
		assert(false)
