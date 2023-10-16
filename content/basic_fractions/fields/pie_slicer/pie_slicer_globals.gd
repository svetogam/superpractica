##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name PieSlicerGlobals

enum Objects {
	PIE,
	SLICE,
	REGION,
}

enum SliceVariants {
	NORMAL = 0,
	WARNING,
	GUIDE,
	PREFIG,
}

const OBJECT_TO_GROUP_MAP := {
	Objects.PIE: "pies",
	Objects.SLICE: "pie_slices",
	Objects.REGION: "pie_regions",
}
