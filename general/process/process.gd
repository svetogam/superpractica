#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name Process
extends Node
## Simple base class for running logic in a [Node] as a child of another [Node].
##
## [b]Process[/b] is mostly a regular [Node], but with a specialized interface.
## It is useful for splitting up game logic into logical components in a standardized way.
## Override engine callbacks such as [method Node._ready] in the subclass to use.
## [br][br]
## Example using a [GDScript]:
## [code]MyProcess.new(setup_arg).run(self, _then_do_this)[/code]
## [br]
## Example using a [PackedScene]:
## [code]MyProcess.instantiate().setup(setup_arg).run(self, _then_do_this)[/code]
## [br]
## Example composing a [b]Process[/b] on another [b]Process[/b]:
## [code]Step_3.new().run(self, complete)[/code]


## Emitted when [method complete] is called and right before removal.
signal completed #(varargs ...)


## Adds this [b]Process[/b] as a child to [param context]. An optional [param callback]
## can be set to be called after this [b]Process[/b] completes.
## [br][br]
## Returns itself, which can be useful for chaining.
func run(context: Node, callback := Callable()) -> Process:
	assert(not is_inside_tree())

	if not callback.is_null():
		completed.connect(callback)
	context.add_child(self)
	return self


## Calls previously connected callbacks with the given arguments and removes this
## [b]Process[/b]. This can be any variable number of arguments as long as the reserved
## string [code]"__"[/code] is not used.
func complete(arg1: Variant = "__",
		arg2: Variant = "__",
		arg3: Variant = "__",
		arg4: Variant = "__",
		arg5: Variant = "__",
		arg6: Variant = "__",
		arg7: Variant = "__",
		arg8: Variant = "__"
) -> void:
	assert(is_inside_tree())

	var args := Utils.pack_args(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	Utils.emit_signal_v(completed, args)
	queue_free()
