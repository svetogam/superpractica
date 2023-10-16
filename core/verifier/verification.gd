##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Verification
extends Process

signal verified
signal rejected

var verifier: Node
var pack: Node
var screen_verifier: Node


func _init() -> void:
	add_to_group("verifications")


func _enter_tree() -> void:
	ContextualConnector.register(self)

	pack = get_parent()
	assert(pack != null)
	verifier = pack.get_parent()
	assert(verifier != null)
	screen_verifier = verifier.screen_verifications
	assert(screen_verifier != null)


func connect_result_callbacks(callback_object: Object, verified_callback_method: String,
			rejected_callback_method: String) -> void:
	connect("verified", callback_object, verified_callback_method)
	connect("rejected", callback_object, rejected_callback_method)


func verify_or_else_reject(verify: bool) -> void:
	if verify:
		verify()
	else:
		reject()


func verify() -> void:
	complete()
	emit_signal("verified")


func reject() -> void:
	complete()
	emit_signal("rejected")
