#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldInterfaceData


func _init() -> void:
	field_type = "BubbleSum"

	tool_data = {
		BubbleSum.Tools.MOVER: {
			"name": "Mover",
			"text": "Move Object",
			"object_modes": {
				BubbleSum.Objects.UNIT: ["move"],
			},
		},
		BubbleSum.Tools.UNIT_CREATOR: {
			"name": "UnitCreator",
			"text": "Create Unit",
			"object_modes": {
				BubbleSum.Objects.GROUND: ["create_unit"],
			},
		},
		BubbleSum.Tools.BUBBLE_CREATOR: {
			"name": "BubbleCreator",
			"text": "Create Bubble",
			"object_modes": {
				BubbleSum.Objects.GROUND: ["create_bubble"],
			},
		},
		BubbleSum.Tools.UNIT_DELETER: {
			"name": "UnitDeleter",
			"text": "Delete Unit",
			"object_modes": {
				BubbleSum.Objects.UNIT: ["delete"],
			},
		},
		BubbleSum.Tools.BUBBLE_POPPER: {
			"name": "BubblePopper",
			"text": "Pop Bubble",
			"object_modes": {
				BubbleSum.Objects.BUBBLE: ["pop"],
			},
		},
		BubbleSum.Tools.BUBBLE_DELETER: {
			"name": "BubbleDeleter",
			"text": "Delete Bubble",
			"object_modes": {
				BubbleSum.Objects.BUBBLE: ["delete"],
			},
		},
		BubbleSum.Tools.UNIT_SELECTOR: {
			"name": "UnitSelector",
			"text": "Select Unit",
			"object_modes": {
				BubbleSum.Objects.UNIT: ["select"],
			},
		},
		BubbleSum.Tools.BUBBLE_SELECTOR: {
			"name": "BubbleSelector",
			"text": "Select Bubble",
			"object_modes": {
				BubbleSum.Objects.BUBBLE: ["select"],
			},
		},
		BubbleSum.Tools.UNIT_COUNTER: {
			"name": "UnitCounter",
			"text": "Count Unit",
			"object_modes": {
				BubbleSum.Objects.UNIT: ["count"],
			},
		},
	}

	draggable_object_data = {
		BubbleSum.Objects.UNIT: {
			"text": "Unit",
			"sprite": preload("objects/unit/graphic.gd"),
		},
		BubbleSum.Objects.BUBBLE: {
			"text": "Bubble",
			"sprite": preload("objects/bubble/graphic.gd"),
		},
	}
