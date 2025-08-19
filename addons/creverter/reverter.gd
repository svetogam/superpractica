@icon("res://addons/creverter/icon.png")
class_name CReverter
extends Node
## A node for memento-based undo/redo.
##
## [CReverter] (Composite Reverter) is a [Node] that manages undo, redo,
## and related functions.
## It supports composing mementos together so that objects
## can handle their own saving and loading independently of each other
## while being combined in the same history.
## [br][br]
## [b]Basic Usage:[/b][br]
## 1. Add a [CReverter] node to a scene.
## [br]
## 2. Connect functions to [signal saving] and [signal loading].
## [br]
## 3. Push mementos to [member history] with [method commit].
## [br]
## 4. Use methods such as [method undo] to traverse the [member history].

## Emitted during [method commit].
## Each connected object should build the [param memento] using
## [method CRMemento.add_submemento].
## [br][br]
## For example:
## [codeblock]
## func _on_reverter_saving(memento: CRMemento) -> void:
##     memento.add_submemento(get_instance_id(), {"my_var": 1})
## [/codeblock]
signal saving(memento: CRMemento)
## Emitted when loading a memento from [member history].
## Each connected object should load using the [param memento].
## [br][br]
## For example:
## [codeblock]
## func _on_reverter_loading(memento: CRMemento) -> void:
##     var submemento = memento.get_submemento(get_instance_id())
##     my_var = submemento.my_var
## [/codeblock]
signal loading(memento: CRMemento)
## Emitted after a new memento is saved via [method commit].
signal saved
## Emitted after an old memento is loaded via methods such as [method undo].
signal loaded

## Constant naming the tag in [member history]
## used to keep track of the cursor.
const CURSOR_TAG: String = "_CRCursor"
## Resource for keeping track of the history.
## Leaving this empty means a new one will be created.
## It can be accessed for extra functionality, but this is not necessary
## for most common use-cases.
@export var history: CRHistory
## If [code]true[/code], calling [method commit] will not push the built memento
## to [member history] if it is equal according to [method CRMemento.equals].
## [br][br]
## If [code]false[/code], calling [method commit] will always push the built memento
## to [member history] without checking equality.
@export var only_push_changes := true
## Shortcut for calling [method undo].
@export var undo_shortcut: Shortcut
## Shortcut for calling [method redo].
@export var redo_shortcut: Shortcut
## Shortcut for calling [method revert].
@export var revert_shortcut: Shortcut
## Signifies the current position in the [member history].
## The cursor is kept track of in the history using a tag named by
## [constant CURSOR_TAG]. Trying to set it to outside the history will
## clamp it inside.
## [br][br]
## [b]Warning:[/b] This is automatically set when using methods
## like [method undo], so don't use this unless you know what you're doing.
var cursor: int:
	set = set_cursor,
	get = get_cursor


# Create a new CRHistory resource if one isn't set
func _enter_tree() -> void:
	if history == null:
		history = CRHistory.new()


# Call methods by shortcut input
func _shortcut_input(event: InputEvent) -> void:
	if event.is_pressed():
		if undo_shortcut != null and undo_shortcut.matches_event(event):
			undo()
			get_viewport().set_input_as_handled()
		elif redo_shortcut != null and redo_shortcut.matches_event(event):
			redo()
			get_viewport().set_input_as_handled()
		elif revert_shortcut != null and revert_shortcut.matches_event(event):
			revert()
			get_viewport().set_input_as_handled()


## Call this to build and push a new memento to the [member history]
## after connecting objects with [signal saving].
## [br][br]
## If the [member cursor] is not at the newest position in the
## [member history], then it will remove all newer mementos
## than the one pointed to by the [member cursor] before pushing
## the new memento.
## If the [member cursor] is on the newest memento and the number of
## mementos in [member history] is equal to its [member CRHistory.max_size],
## then the memento at the oldest position will be forgotten.
## [br][br]
## Pass an optional [param tag] to tag the new memento.
## This enables loading it later with [method load_tag].
## Commiting with the same tag as an already exsting one moves the tag.
## [br][br]
## By default, if the built memento is equal to the old memento,
## then no new memento will be pushed, though the old memento will
## be tagged with [param tag] if one is given.
## See [method CRMemento.equals] for the default behavior
## checking equality between mementos, which can be overridden.
## However, if [member only_push_changes] is set to [code]false[/code],
## then all built mementos will be pushed without checking equality.
## [br][br]
## Emits [signal saved] if a memento was pushed to the [member history].
func commit(tag: String = "") -> void:
	# Build combined memento with connected saving functions
	var new_composite_memento := CRMemento.new()
	saving.emit(new_composite_memento)

	# Abort if no change
	if only_push_changes and not history.is_empty():
		var last_composite_memento = history.get_item(cursor)
		if new_composite_memento.equals(last_composite_memento):
			# Add tag to old memento even if aborting
			if tag != "":
				history.add_tag(tag, cursor)
			return

	# Warn against early commits
	if new_composite_memento.data.is_empty() and history.is_empty():
		push_warning(
			"CReverter Warning: Commiting empty memento to empty history."
			+ " You might want to connect saving and loading functions first."
		)

	# Push new memento and update
	history._push(new_composite_memento, cursor + 1)
	cursor = history.newest_position
	if tag != "":
		history.add_tag(tag, cursor)

	saved.emit()


## Moves the [member cursor] to the next older memento and loads it.
## Does nothing if [method is_undo_possible] returns [code]false[/code].
## [br][br]
## Emits [signal loaded] after loading.
func undo() -> void:
	if not history.is_empty():
		if is_undo_possible():
			cursor -= 1
			_load_by_cursor()
	else:
		push_warning(
			"CReverter Warning: " +
			"History is empty. Ignoring load request."
		)


## Moves the [member cursor] to the next newer memento and loads it.
## Does nothing if [method is_redo_possible] returns [code]false[/code].
## [br][br]
## Emits [signal loaded] after loading.
func redo() -> void:
	if not history.is_empty():
		if is_redo_possible():
			cursor += 1
			_load_by_cursor()
	else:
		push_warning(
			"CReverter Warning: " +
			"History is empty. Ignoring load request."
		)


## Loads the memento currently pointed to by the [member cursor].
## Does nothing if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func revert() -> void:
	if not history.is_empty():
		_load_by_cursor()
	else:
		push_warning(
			"CReverter Warning: " +
			"History is empty. Ignoring load request."
		)


## Returns [code]true[/code] if undo is possible, which is when the [member cursor] is
## on a memento that is newer than the oldest one.
## Returns [code]false[/code] otherwise, including when the [member history] is empty.
func is_undo_possible() -> bool:
	return not history.is_empty() and cursor != history.oldest_position


## Returns [code]true[/code] if redo is possible, which is when the [member cursor] is
## on a memento that is older than the newest one.
## Returns [code]false[/code] otherwise, including when the [member history] is empty.
func is_redo_possible() -> bool:
	return not history.is_empty() and cursor != history.newest_position


## Moves the [member cursor] to the newest memento and loads it.
## Does nothing if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func load_newest() -> void:
	if not history.is_empty():
		cursor = history.newest_position
		_load_by_cursor()
	else:
		push_warning(
			"CReverter Warning: " +
			"History is empty. Ignoring load request."
		)


## Moves the [member cursor] to the oldest memento and loads it.
## Does nothing if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func load_oldest() -> void:
	if not history.is_empty():
		cursor = history.oldest_position
		_load_by_cursor()
	else:
		push_warning(
			"CReverter Warning: " +
			"History is empty. Ignoring load request."
		)


## Moves the [member cursor] to the given [param tag] and loads it.
## Does nothing if the tag was never previously added,
## or if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func load_tag(tag: String) -> void:
	if not history.is_empty() and history.has_tag(tag):
		cursor = history.get_tag_position(tag)
		_load_by_cursor()
	else:
		push_warning(
			"CReverter Warning: " +
			"Tag \"" + tag + "\" was not found in history. " +
			"Ignoring load request."
		)


# Sets the cursor in the history by adding the tag CURSOR_TAG.
# It always clamps it in the history, so this can never put it out of bounds.
func set_cursor(position: int) -> void:
	if not history.is_empty():
		position = clampi(position, history.oldest_position, history.newest_position)
		history.add_tag(CURSOR_TAG, position)


func get_cursor() -> int:
	return history.get_tag_position(CURSOR_TAG)


# Calls loading functions with the memento at the cursor
func _load_by_cursor() -> void:
	# Pass memento to connected loading functions
	var composite_memento := history.get_item(cursor)
	loading.emit(composite_memento)

	loaded.emit()
