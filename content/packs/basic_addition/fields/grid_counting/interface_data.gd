# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldInterfaceData


func _init() -> void:
	field_type = "GridCounting"

	object_data = {
		GridCounting.OBJECT_UNIT: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_UNIT,
			# Name Text
			"Unit",
			# Drag Sprite
			preload("objects/unit/sprite.tscn"),
			# Icon
			preload("graphics/icons/unit_icon.svg"),
		),
		GridCounting.OBJECT_TWO_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_TWO_BLOCK,
			# Name Text
			"Two Block",
			# Drag Sprite
			preload("objects/two_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/two_block_icon.svg"),
		),
		GridCounting.OBJECT_THREE_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_THREE_BLOCK,
			# Name Text
			"Three Block",
			# Drag Sprite
			preload("objects/three_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/three_block_icon.svg"),
		),
		GridCounting.OBJECT_FOUR_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_FOUR_BLOCK,
			# Name Text
			"Four Block",
			# Drag Sprite
			preload("objects/four_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/four_block_icon.svg"),
		),
		GridCounting.OBJECT_FIVE_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_FIVE_BLOCK,
			# Name Text
			"Five Block",
			# Drag Sprite
			preload("objects/five_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/five_block_icon.svg"),
		),
		GridCounting.OBJECT_TEN_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_TEN_BLOCK,
			# Name Text
			"Ten Block",
			# Drag Sprite
			preload("objects/ten_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/ten_block_icon.svg"),
		),
		GridCounting.OBJECT_TWENTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_TWENTY_BLOCK,
			# Name Text
			"Twenty Block",
			# Drag Sprite
			preload("objects/twenty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/twenty_block_icon.svg"),
		),
		GridCounting.OBJECT_THIRTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_THIRTY_BLOCK,
			# Name Text
			"Thirty Block",
			# Drag Sprite
			preload("objects/thirty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/thirty_block_icon.svg"),
		),
		GridCounting.OBJECT_FORTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_FORTY_BLOCK,
			# Name Text
			"Forty Block",
			# Drag Sprite
			preload("objects/forty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/forty_block_icon.svg"),
		),
		GridCounting.OBJECT_FIFTY_BLOCK: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_FIFTY_BLOCK,
			# Name Text
			"Fifty Block",
			# Drag Sprite
			preload("objects/fifty_block/sprite.tscn"),
			# Icon
			preload("graphics/icons/fifty_block_icon.svg"),
		),
		GridCounting.OBJECT_GRID_CELL: FieldObjectData.new(
			# Field Type
			field_type,
			# Object Type
			GridCounting.OBJECT_GRID_CELL,
			# Name Text
			"Grid Cell",
			# Drag Sprite
			# Icon
		),
	}

	tool_data = {
		GridCounting.TOOL_CELL_MARKER: {
			"text": "Mark Cell",
			"icon": preload("graphics/icons/action_mark_cell_icon.svg"),
		},
		GridCounting.TOOL_PIECE_DELETER: {
			"text": "Delete Piece",
			"icon": preload("graphics/icons/action_delete_piece_icon.svg"),
		},
		GridCounting.TOOL_PIECE_DRAGGER: {
			"text": "Drag Piece",
			"icon": preload("graphics/icons/action_drag_piece_icon.svg"),
		},
	}
