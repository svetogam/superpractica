##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node

signal verifications_started
signal verifications_completed

export(NodePath) var _effect_layer_path: NodePath
var effect_layer: CanvasLayer
var _verifications_running := 0
var _verification_connector := ContextualConnector.new(self, "verifications", true)
var _packs: Dictionary
onready var screen_verifications := $ScreenVerifications


func _enter_tree() -> void:
	effect_layer = get_node(_effect_layer_path)
	assert(effect_layer != null)

	_verification_connector.connect_setup(self, "_register_verification")


func _ready() -> void:
	_find_verification_packs()


func _find_verification_packs() -> void:
	var pack_array = ContextUtils.get_children_in_group(self, "verification_packs")
	for pack in pack_array:
		_packs[pack.name] = pack


func get_pack(pack_name: String) -> Node:
	return _packs[pack_name]


func _register_verification(verification: Process) -> void:
	verification.connect_callback(self, "_on_verification_completed")

	_verifications_running += 1
	if _verifications_running == 1:
		emit_signal("verifications_started")


func _on_verification_completed() -> void:
	_verifications_running -= 1
	assert(_verifications_running >= 0)

	if not is_running():
		emit_signal("verifications_completed")


func is_running() -> bool:
	return _verifications_running > 0
