##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name CountingBoardGlobals

enum Objects {
	NUMBER_SQUARE,
	COUNTER,
}

enum SquareMarks {
	ALL = 0,
	CIRCLE,
	COUNTER,
	HIGHLIGHT,
}

const OBJECT_TO_GROUP_MAP := {
	Objects.NUMBER_SQUARE: "number_squares",
	Objects.COUNTER: "counters",
}
