# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name CountSignaler
extends InfoSignaler
## An [InfoSignaler] specialized for counting.
##
## Regular usage is the following:
## [br][br]
## [b]1.[/b] Call [method count_next] or [method count_object] repeatedly.
## [br]
## [b]2.[/b] Do something with the returned [NumberSignal] or [param current_signal].
## [br]
## [b]3.[/b] Call [method reset_count] to be ready to count again.

## The number the count is on.
## [br][br]
## You can modify this to begin a count from anywhere.
## But you should usually call [method count_next] and [method reset_count]
## instead of changing this manually.
var count: int = 0
## The last [NumberSignal] created by this [CountSignaler].
var current_signal: NumberSignal


## Create a [NumberSignal] greater than the last by [param increment]
## at [param p_position].
## [br][br]
## Like saying "1! 2! 3! 4!" and so on.
## This is more suitable for animating counts than [method popup_number].
func count_next(p_position: Vector2, increment: int = 1) -> NumberSignal:
	count += increment
	if current_signal != null:
		current_signal.erase("out_slow_fade")
	current_signal = popup_number(count, p_position, "in_pop")
	return current_signal


## Count the [param object], creating a [NumberSignal] greater than the
## last by [param increment].
## [br][br]
## Like saying "1! 2! 3! 4!" and so on.
## This is more suitable for animating counts than [method popup_number].
func count_object(object: Node2D, increment: int = 1) -> NumberSignal:
	return count_next(object.position, increment)


## Reset the count back to [code]0[/code] and get ready to count again.
## [br][br]
## It is expected that there will be a short delay between calling this
## and counting again.
func reset_count() -> void:
	count = 0
	if current_signal != null:
		current_signal.erase("out_slow_fade")
		current_signal = null
