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
			preload("graphics/icons/unit_icon.svg"),
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
			preload("graphics/icons/two_block_icon.svg"),
		),
		GridCounting.Objects.THREE_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.THREE_BLOCK,
			# Name Text
			"Three Block",
			# Drag Sprite
			preload("objects/three_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/three_block_icon.svg"),
		),
		GridCounting.Objects.FOUR_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.FOUR_BLOCK,
			# Name Text
			"Four Block",
			# Drag Sprite
			preload("objects/four_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/four_block_icon.svg"),
		),
		GridCounting.Objects.FIVE_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.FIVE_BLOCK,
			# Name Text
			"Five Block",
			# Drag Sprite
			preload("objects/five_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/five_block_icon.svg"),
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
			preload("graphics/icons/ten_block_icon.svg"),
		),
		GridCounting.Objects.TWENTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.TWENTY_BLOCK,
			# Name Text
			"Twenty Block",
			# Drag Sprite
			preload("objects/twenty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/twenty_block_icon.svg"),
		),
		GridCounting.Objects.THIRTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.THIRTY_BLOCK,
			# Name Text
			"Thirty Block",
			# Drag Sprite
			preload("objects/thirty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/thirty_block_icon.svg"),
		),
		GridCounting.Objects.FORTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.FORTY_BLOCK,
			# Name Text
			"Forty Block",
			# Drag Sprite
			preload("objects/forty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/forty_block_icon.svg"),
		),
		GridCounting.Objects.FIFTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.Objects.FIFTY_BLOCK,
			# Name Text
			"Fifty Block",
			# Drag Sprite
			preload("objects/fifty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/fifty_block_icon.svg"),
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
		GridCounting.Tools.PIECE_DELETER: {
			"name": "PieceDeleter",
			"text": "Delete Piece",
			"object_modes": {
				GridCounting.Objects.UNIT: ["delete"],
				GridCounting.Objects.TWO_BLOCK: ["delete"],
				GridCounting.Objects.THREE_BLOCK: ["delete"],
				GridCounting.Objects.FOUR_BLOCK: ["delete"],
				GridCounting.Objects.FIVE_BLOCK: ["delete"],
				GridCounting.Objects.TEN_BLOCK: ["delete"],
				GridCounting.Objects.TWENTY_BLOCK: ["delete"],
				GridCounting.Objects.THIRTY_BLOCK: ["delete"],
				GridCounting.Objects.FORTY_BLOCK: ["delete"],
				GridCounting.Objects.FIFTY_BLOCK: ["delete"],
			},
		},
		GridCounting.Tools.PIECE_DRAGGER: {
			"name": "PieceDragger",
			"text": "Drag Piece",
			"object_modes": {
				GridCounting.Objects.UNIT: ["drag"],
				GridCounting.Objects.TWO_BLOCK: ["drag"],
				GridCounting.Objects.THREE_BLOCK: ["drag"],
				GridCounting.Objects.FOUR_BLOCK: ["drag"],
				GridCounting.Objects.FIVE_BLOCK: ["drag"],
				GridCounting.Objects.TEN_BLOCK: ["drag"],
				GridCounting.Objects.TWENTY_BLOCK: ["drag"],
				GridCounting.Objects.THIRTY_BLOCK: ["drag"],
				GridCounting.Objects.FORTY_BLOCK: ["drag"],
				GridCounting.Objects.FIFTY_BLOCK: ["drag"],
			},
		},
	}
