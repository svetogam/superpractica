#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name InputShapeSetupResource
extends Resource

@export var shape_type: InputShape.ShapeTypes
@export var size: Vector2
@export var rect_center := true
@export var circle_radius: float
@export var offset := Vector2.ZERO
