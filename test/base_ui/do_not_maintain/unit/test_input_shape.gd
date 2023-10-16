##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends GutTest

const RECT_SIZE := Vector2(50, 100)
const RECT_EXTENTS := RECT_SIZE/2
const CIRCLE_RADIUS := 50
const OFFSET := Vector2(200, 200)
var input_shape: InputShape


func before_each():
	input_shape = InputShape.new()


func test_unset_shape_has_no_point():
	assert_false(input_shape.has_point(Vector2(0, 0)))
	assert_false(input_shape.has_point(Vector2(50, 50)))
	assert_false(input_shape.has_point(Vector2(0.01, 0.01)))


func test_set_rect_centered():
	input_shape.set_rect(RECT_SIZE)
	_assert_has_point_within_rect_around_center(Vector2.ZERO)


func test_set_rect_centered_with_offset():
	input_shape.set_rect(RECT_SIZE, true, OFFSET)
	_assert_has_point_within_rect_around_center(OFFSET)


func test_set_rect_uncentered():
	input_shape.set_rect(RECT_SIZE, false)
	_assert_has_point_within_rect_around_center(RECT_EXTENTS)


func test_set_rect_uncentered_with_offset():
	input_shape.set_rect(RECT_SIZE, false, OFFSET)
	_assert_has_point_within_rect_around_center(RECT_EXTENTS + OFFSET)


func _assert_has_point_within_rect_around_center(expected_center: Vector2):
	assert_true(input_shape.has_point(expected_center))

	assert_true(input_shape.has_point(expected_center + Vector2(-20, -20)))
	assert_true(input_shape.has_point(expected_center + Vector2(-20, 20)))
	assert_true(input_shape.has_point(expected_center + Vector2(20, -20)))
	assert_true(input_shape.has_point(expected_center + Vector2(20, 20)))

	assert_true(input_shape.has_point(expected_center + Vector2(-20, 40)))
	assert_false(input_shape.has_point(expected_center + Vector2(-40, 40)))
	assert_true(input_shape.has_point(expected_center + Vector2(20, -40)))
	assert_false(input_shape.has_point(expected_center + Vector2(40, -40)))

	assert_true(input_shape.has_point(expected_center + RECT_EXTENTS - Vector2(0.01, 0.01)))
	assert_false(input_shape.has_point(expected_center + RECT_EXTENTS + Vector2(0.01, 0.01)))
	assert_true(input_shape.has_point(expected_center - RECT_EXTENTS + Vector2(0.01, 0.01)))
	assert_false(input_shape.has_point(expected_center - RECT_EXTENTS - Vector2(0.01, 0.01)))

	assert_false(input_shape.has_point(expected_center + Vector2(-200, -200)))
	assert_false(input_shape.has_point(expected_center + Vector2(-200, 200)))
	assert_false(input_shape.has_point(expected_center + Vector2(200, -200)))
	assert_false(input_shape.has_point(expected_center + Vector2(200, 200)))


func test_set_circle():
	input_shape.set_circle(CIRCLE_RADIUS)
	_assert_has_point_within_circle_around_center(Vector2.ZERO)


func test_set_circle_with_offset():
	input_shape.set_circle(CIRCLE_RADIUS, OFFSET)
	_assert_has_point_within_circle_around_center(OFFSET)

func _assert_has_point_within_circle_around_center(expected_center: Vector2):
	assert_true(input_shape.has_point(expected_center))

	assert_true(input_shape.has_point(expected_center + Vector2(-20, -40)))
	assert_true(input_shape.has_point(expected_center + Vector2(-40, 20)))
	assert_true(input_shape.has_point(expected_center + Vector2(20, -40)))
	assert_true(input_shape.has_point(expected_center + Vector2(20, 40)))

	assert_true(input_shape.has_point(expected_center + Vector2(CIRCLE_RADIUS - 0.01, 0)))
	assert_false(input_shape.has_point(expected_center + Vector2(CIRCLE_RADIUS + 0.01, 0)))
	assert_true(input_shape.has_point(expected_center + Vector2(-CIRCLE_RADIUS + 0.01, 0)))
	assert_false(input_shape.has_point(expected_center + Vector2(-CIRCLE_RADIUS - 0.01, 0)))

	var diagonal_inside_circle := Vector2(35, 35)
	var diagonal_outside_circle := Vector2(36, 36)
	assert_true(input_shape.has_point(expected_center + diagonal_inside_circle))
	assert_false(input_shape.has_point(expected_center + diagonal_outside_circle))
	assert_true(input_shape.has_point(expected_center - diagonal_inside_circle))
	assert_false(input_shape.has_point(expected_center - diagonal_outside_circle))

	assert_false(input_shape.has_point(expected_center + Vector2(-200, -200)))
	assert_false(input_shape.has_point(expected_center + Vector2(-200, 200)))
	assert_false(input_shape.has_point(expected_center + Vector2(200, -200)))
	assert_false(input_shape.has_point(expected_center + Vector2(200, 200)))
