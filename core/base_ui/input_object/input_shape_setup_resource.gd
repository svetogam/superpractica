##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name InputShapeSetupResource
extends Resource

export(InputShape.ShapeTypes) var shape_type: int
export(Vector2) var rect_size: Vector2
export(bool) var rect_center := true
export(float) var circle_radius: float
export(Vector2) var offset := Vector2.ZERO
