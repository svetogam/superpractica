##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name IntegerMath
extends Reference

#Place is 1 for ones, 2 for tens, etc.
#Return 0 if there is no digit at that place
static func get_digit_at_place(number: int, place: int) -> int:
	assert(number >= 0)
	assert(place >= 1)

	return int( (number % int(pow(10, place))) / pow(10, (place-1)) )


static func get_number_of_digits(number: int) -> int:
	assert(number >= 0)

	var number_copy = number
	var digit_place = 0
	if number == 0:
		return 1
	while number_copy > 0:
		number_copy /= 10
		digit_place += 1
		if number_copy == 0:
			return digit_place
		if digit_place > 100000:
			assert(false)
			return -1

	assert(false)
	return -1


#Order is: ones, tens, hundreds, etc.
static func get_number_as_digit_list(number: int) -> Array:
	assert(number >= 0)

	var digit_list = []
	var digits = get_number_of_digits(number)
	for place in range(1, digits + 1):
		var digit = get_digit_at_place(number, place)
		digit_list.append(digit)
	return digit_list


#static func set_digit_at_place(_original: int, _digit: int, _place: int) -> int:
#	pass
#
#
#static func insert_digit_at_place(_original: int, _digit: int, _place: int) -> int:
#	pass
#
#
#static func remove_digit_at_place(_original: int, _place: int) -> int:
#	pass
