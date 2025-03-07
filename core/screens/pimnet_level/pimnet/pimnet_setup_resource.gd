# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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
@export var goal_start_active := false
@export var plan_enable := false
@export var edit_panels_enable := false
