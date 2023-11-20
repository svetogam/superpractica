##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name Process
extends Node

signal completed #(varargs ...)


static func create(process_class: Resource, call_setup:=false, setup_args:=[]) -> Process:
	var process = Utils.make_node_from_resource(process_class)
	if call_setup:
		process.callv("setup", setup_args)
	return process


static func create_and_run_on(process_class: Resource, target: Node,
			call_setup:=false, setup_args:=[],
			callback_object: Object =null, callback_method:="", binds:=[]) -> Process:
	var process = create(process_class, call_setup, setup_args)
	process.run_on(target, callback_object, callback_method, binds)
	return process


#PROTOCOL
#func setup(varargs ...) -> void:
#	pass


func run_on(target: Node, callback_object: Object =null, callback_method:="", binds:=[]) -> void:
	if callback_object != null:
		connect_callback(callback_object, callback_method, binds)
	target.add_child(self)


func connect_callback(callback_object: Object, callback_method: String, binds:=[]) -> void:
	completed.connect(Callable(callback_object, callback_method).bindv(binds))


func disconnect_callback(callback_object: Object, callback_method: String) -> void:
	completed.disconnect(Callable(callback_object, callback_method))


func complete(args:=[]) -> void:
	assert(is_inside_tree())

	Utils.emit_signal_v(self, "completed", args)
	queue_free()
