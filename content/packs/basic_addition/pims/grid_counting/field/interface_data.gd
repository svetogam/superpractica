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
		GridCounting.Objects.UNIT: preload("objects/unit/object_data.gd").new(),
		GridCounting.Objects.TEN_BLOCK: preload("objects/ten_block/object_data.gd").new(),
		GridCounting.Objects.GRID_CELL: preload("objects/grid_cell/object_data.gd").new(),
	}

	tool_data = {
		GridCounting.Tools.CELL_MARKER: {
			"name": "CellMarker",
			"text": "Mark Square",
			"object_modes": {
				GridCounting.Objects.GRID_CELL: ["highlight"],
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
				GridCounting.Objects.TEN_BLOCK: ["delete"],
			},
		},
		GridCounting.Tools.PIECE_DRAGGER: {
			"name": "PieceDragger",
			"text": "Drag Piece",
			"object_modes": {
				GridCounting.Objects.GRID_CELL: ["drag_piece"],
				GridCounting.Objects.UNIT: ["drag"],
				GridCounting.Objects.TEN_BLOCK: ["drag"],
			},
		},
	}
