##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name BubbleSumGlobals

enum Objects {
	GROUND,
	UNIT,
	BUBBLE,
}

const OBJECT_TO_GROUP_MAP := {
	Objects.GROUND: "field_grounds",
	Objects.UNIT: "units",
	Objects.BUBBLE: "bubbles",
}
