##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name VerificationPack
extends Node

var verifier: Node
@onready var _verification_factory := $VerificationFactory as NodeFactory
@onready var _process_factory := $ProcessFactory as NodeFactory


func _enter_tree() -> void:
	verifier = get_parent()
	assert(verifier != null)


func _ready() -> void:
	_verification_factory.connect_setup_on_all("setup")
	_process_factory.connect_setup_on_all("setup")


func verify(verification_name: String, args: Array,
		callback_object: Object, verify_callback: String, reject_callback: String) -> void:
	var verification = _verification_factory.create(verification_name, args)
	verification.connect_result_callbacks(callback_object, verify_callback, reject_callback)
	add_child(verification)


func run_process(process_name: String, args:=[],
			callback_object: Object =null, callback_method:="") -> Process:
	var process = _process_factory.create(process_name, args)
	process.run_on(self, callback_object, callback_method)
	return process
