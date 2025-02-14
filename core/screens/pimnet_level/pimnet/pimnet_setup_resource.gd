#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimnetSetupResource
extends Resource

@export_group("Pim Strip")
@export var pims: Array[PackedScene] = []
@export_group("Top Bar")
@export var reversion_enable := false
@export_group("Bottom Bar")
@export var tools_enable := false
@export var tools_start_active := false
@export var creation_enable := false
@export var creation_start_active := false
@export var translation_enable := false
@export var translation_start_active := false
@export var goal_start_active := false
@export var plan_enable := false
@export var plan_start_active := false
