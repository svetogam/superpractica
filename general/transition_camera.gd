# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name TransitionCamera2D
extends Camera2D

@export var duration := 1.0
@export var position_trans := Tween.TRANS_LINEAR
@export var position_ease := Tween.EASE_IN_OUT
@export var zoom_trans := Tween.TRANS_LINEAR
@export var zoom_ease := Tween.EASE_IN_OUT


func _enter_tree() -> void:
	enabled = false


func transition(
	to_camera: Camera2D,
	callback := Callable(),
	p_duration := duration,
	p_position_trans := position_trans,
	p_position_ease := position_ease,
	p_zoom_trans := zoom_trans,
	p_zoom_ease := zoom_ease
) -> void:
	var viewport = get_viewport()
	if viewport == null:
		push_error("TransitionCamera error: Transition camera does not have a viewport.")
		return
	var from_camera = get_viewport().get_camera_2d()
	if from_camera == null:
		push_error("TransitionCamera error: No camera found to transition from.")
		return
	if enabled:
		push_error("TransitionCamera error: Trying to run again when already running.")
		return
	if not to_camera.is_inside_tree():
		push_error("TransitionCamera error: to_camera is not inside scene tree.")
		return
	if from_camera.anchor_mode != to_camera.anchor_mode:
		push_warning(
			"TransitionCamera warning: Cameras have different anchor_mode values."
		)

	# Do nothing if no transition is needed
	if from_camera.get_instance_id() == to_camera.get_instance_id():
		return

	# Prepare start
	from_camera.enabled = false
	to_camera.enabled = false
	enabled = true
	anchor_mode = from_camera.anchor_mode
	global_position = from_camera.global_position
	offset = from_camera.offset
	zoom = from_camera.zoom

	# Run tweens
	var position_tween = create_tween()
	position_tween.set_trans(p_position_trans)
	position_tween.set_ease(p_position_ease)
	position_tween.tween_property(
		self,
		"global_position",
		to_camera.global_position,
		p_duration
	)
	position_tween.parallel().tween_property(
		self,
		"offset",
		to_camera.offset,
		p_duration
	)
	var zoom_tween = create_tween()
	zoom_tween.set_trans(p_zoom_trans)
	zoom_tween.set_ease(p_zoom_ease)
	zoom_tween.tween_property(
		self,
		"zoom",
		to_camera.zoom,
		p_duration
	)

	# Call callbacks when finished
	position_tween.finished.connect(set.bind("enabled", false))
	position_tween.finished.connect(to_camera.set.bind("enabled", true))
	if not callback.is_null():
		position_tween.finished.connect(callback)
