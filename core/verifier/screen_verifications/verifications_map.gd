##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends StaticDictionary

static func get_data() -> Dictionary:
	return {
		"numbers_are_equal": preload("equality_verification.gd"),
		"evaluates_to_number": preload("evaluation_verification.gd"),
		"number_is_equal_to_digit": preload("digit_equality_verification.gd"),
	}
