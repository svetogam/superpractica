# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends Process

var order: Array = []
var parent: Node = null


func _init() -> void:
	order.append("setup")


func _enter_tree() -> void:
	parent = get_parent()
	order.append("setup_with_parent")


func _ready() -> void:
	order.append("running")
