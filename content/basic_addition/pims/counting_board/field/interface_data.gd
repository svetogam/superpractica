#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PimInterfaceData


func _init() -> void:
	tool_data = {
		CountingBoard.Tools.NUMBER_CIRCLER: {
			"name": "NumberCircler",
			"text": "Circle Number",
			"object_modes": {
				CountingBoard.Objects.NUMBER_SQUARE: ["circle"],
			},
		},
		CountingBoard.Tools.SQUARE_MARKER: {
			"name": "SquareMarker",
			"text": "Mark Square",
			"object_modes": {
				CountingBoard.Objects.NUMBER_SQUARE: ["highlight"],
			},
		},
		CountingBoard.Tools.COUNTER_CREATOR: {
			"name": "CounterCreator",
			"text": "Create Counter",
			"object_modes": {
				CountingBoard.Objects.NUMBER_SQUARE: ["create_counter"],
			},
		},
		CountingBoard.Tools.COUNTER_DELETER: {
			"name": "CounterDeleter",
			"text": "Delete Counter",
			"object_modes": {
				CountingBoard.Objects.COUNTER: ["delete"],
			},
		},
		CountingBoard.Tools.COUNTER_DRAGGER: {
			"name": "CounterDragger",
			"text": "Drag Counter",
			"object_modes": {
				CountingBoard.Objects.COUNTER: ["drag"],
			},
		},
		CountingBoard.Tools.MEMO_GRABBER: {
			"name": "MemoGrabber",
			"text": "Get Memo",
			"object_modes": {
				CountingBoard.Objects.NUMBER_SQUARE: ["get_memo"],
			},
		},
	}

	creation_data = {
		CountingBoard.Objects.COUNTER: {
			"text": "Counter",
			"graphic": preload("objects/counter/graphic.gd"),
		},
	}
