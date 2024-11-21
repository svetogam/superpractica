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
	field_type = "GridCounting"

	object_data = {
		GridCounting.Objects.UNIT: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.UNIT,
			# Name Text
			"Unit",
			# Drag Sprite
			preload("objects/unit/sprite.tscn"),
			# Icon
			preload("graphics/unit_icon.svg"),
		),
		GridCounting.Objects.TWO_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.TWO_BLOCK,
			# Name Text
			"Two Block",
			# Drag Sprite
			preload("objects/two_block/sprite.tscn"),
			# Icon
			preload("graphics/two_block_icon.svg"),
		),
		GridCounting.Objects.TEN_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.TEN_BLOCK,
			# Name Text
			"Ten Block",
			# Drag Sprite
			preload("objects/ten_block/sprite.tscn"),
			# Icon
			preload("graphics/ten_block_icon.svg"),
		),
		GridCounting.Objects.GRID_CELL: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.GRID_CELL,
			# Name Text
			"Grid Cell",
			# Drag Sprite
			# Icon
		),
	}

	tool_data = {
		GridCounting.Tools.CELL_MARKER: {
			"name": "CellMarker",
			"text": "Mark Square",
			"object_modes": {
				GridCounting.Objects.GRID_CELL: ["mark"],
			},
		},
		GridCounting.Tools.UNIT_CREATOR: {
			"name": "UnitCreator",
			"text": "Create Unit",
			"object_modes": {
				GridCounting.Objects.GRID_CELL: ["create_unit"],
			},
		},
		GridCounting.Tools.PIECE_DELETER: {
			"name": "PieceDeleter",
			"text": "Delete Piece",
			"object_modes": {
				GridCounting.Objects.UNIT: ["delete"],
				GridCounting.Objects.TWO_BLOCK: ["delete"],
				GridCounting.Objects.TEN_BLOCK: ["delete"],
			},
		},
		GridCounting.Tools.PIECE_DRAGGER: {
			"name": "PieceDragger",
			"text": "Drag Piece",
			"object_modes": {
				GridCounting.Objects.UNIT: ["drag"],
				GridCounting.Objects.TWO_BLOCK: ["drag"],
				GridCounting.Objects.TEN_BLOCK: ["drag"],
			},
		},
	}
