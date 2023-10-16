##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Reference

const ExampleTask1_1 := "Step 1"
const ExampleTask1_2 := "Step 2"
const ExampleTask1_3 := "Step 3"
const ExampleTask1_4 := "A text"
const ExampleTask1_5 := "B text"
const ExampleTask1_6 := "C text"
const ExampleTask1_7 := "D text"
const ExampleTask1_8 := "E text"
const ExampleTask1_9 := "F text"
const ExampleTask1_10 := "G text"
const ExampleTask1_11 := "H text"


const DATA := {
	"task_1": {
		"name": "1",
		"grid_position": Vector2(0, 0),
		"instructions": ExampleTask1_1,
		"previous": [],
		"flags": ["initial"],
	},
	"task_2": {
		"name": "2",
		"grid_position": Vector2(1, 0),
		"instructions": ExampleTask1_2,
		"previous": ["task_1"],
		"flags": [],
	},
	"task_3": {
		"name": "3",
		"grid_position": Vector2(2, 0),
		"instructions": ExampleTask1_3,
		"previous": ["task_2"],
		"flags": [],
	},
	"task_4": {
		"name": "A",
		"grid_position": Vector2(1, 1),
		"instructions": ExampleTask1_4,
		"previous": ["task_1"],
		"flags": [],
	},
	"task_5": {
		"name": "B",
		"grid_position": Vector2(2, 1),
		"instructions": ExampleTask1_5,
		"previous": ["task_3", "task_4"],
		"flags": [],
	},
	"task_6": {
		"name": "C",
		"grid_position": Vector2(3, 0),
		"instructions": ExampleTask1_6,
		"previous": ["task_3"],
		"flags": [],
	},
	"task_7": {
		"name": "D",
		"grid_position": Vector2(4, 1),
		"instructions": ExampleTask1_7,
		"previous": ["task_6"],
		"flags": [],
	},
	"task_8": {
		"name": "E",
		"grid_position": Vector2(2, 2),
		"instructions": ExampleTask1_8,
		"previous": ["task_5"],
		"flags": [],
	},
	"task_9": {
		"name": "F",
		"grid_position": Vector2(3, 2),
		"instructions": ExampleTask1_9,
		"previous": ["task_8"],
		"flags": [],
	},
	"task_10": {
		"name": "G",
		"grid_position": Vector2(5, 1),
		"instructions": ExampleTask1_10,
		"previous": ["task_7"],
		"flags": [],
	},
	"task_11": {
		"name": "H",
		"grid_position": Vector2(4, 2),
		"instructions": ExampleTask1_11,
		"previous": ["task_7", "task_9"],
		"flags": [],
	},
}
