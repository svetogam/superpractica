class_name CReverter
extends RefCounted
## The main class for the Composite Reverter, a memento-based undo/redo utility.
##
## [CReverter] (Composite Reverter) is an object that manages undo, redo,
## and related functions.
## It supports composing mementos together, so that different subsystems
## can handle their own saving and loading independently of each other
## while still operating in unison.
## [br][br]
## [b]Basic Usage:[/b][br]
## 1. Make a new reverter object with [method CReverter.new].
## [br]
## 2. Connect functions for building and loading mementos with [method connect_save_load].
## [br]
## 3. Save points in history with [method commit].
## [br]
## 4. Use the other methods to traverse the [member history].

## Emitted after a new memento is saved via [method commit].
signal saved
## Emitted after an old memento is loaded.
signal loaded

## Constant naming the tag in [member history]
## used to keep track of the cursor.
const CURSOR_TAG: StringName = "_CRCursor"
## Resource for keeping track of the history.
## It starts empty and mementos are added to it by calling [method commit].
## It can be accessed for extra functionality, but this is not necessary
## for most common uses of the [CReverter].
var history: CRHistory
## Signifies the current position of the [CReverter]
## in the [member history].
## The cursor is kept track of in the history using a tag named by
## [constant CURSOR_TAG]. Trying to set it to outside the history will
## clamp it inside.
## [br][br]
## [b]Warning:[/b] This is automatically set when using methods
## like [method undo], so don't use this unless you know what you're doing.
var cursor: int:
	set = set_cursor,
	get = get_cursor
# connections struct: {id_1: {"save_func": save_func, "load_func": load_func}, ...}
var _connections: Dictionary = {}


# Putting this in the constructor helps clean the automatic documentation.
func _init() -> void:
	history = CRHistory.new()


## Call this before calling [method commit].
## It connects save/load methods to the [CReverter] which will be used
## to build and load mementos.
## This can be called multiple times to track multiple save/load methods.
## [br][br]
## [param id] gives the id that combines the given save and load methods.
## Getting the id from [method Object.get_instance_id] is a good choice.
## [br][br]
## [param save_func] should be a method that returns either a [Dictionary]
## or a [CRMemento]-derived class.
## It will be called upon [method commit] to build the memento.
## [br][br]
## [param load_func] is the method that will be called with the same
## object as previously returned by [param save_func] as its first parameter.
## It will be called when loading, so it should handle setting things
## according to the memento.
## [br][br]
## Example: [code]
## reverter.connect_save_load(get_instance_id(), _build_memento, _load_memento)[/code]
## [br][br]
## [b]Warning:[/b] Calls will be ignored if the [member history] is not empty
## or if the given [param id] is equal to a previously given one.
## [br][br]
## [b]Warning:[/b] If [param save_func] or [param load_func] are
## methods on [Node]s that are freed or removed from the [SceneTree],
## then they will stop being operational.
## The [CReverter] will not add the nodes again back to the tree.
## Instead it will attempt to continue running while ignoring
## the removed nodes.
## It is therefore recommended to give for [param save_func] and
## [param load_func] methods on objects with the same expected
## lifetime as the [CReverter], representing whole subsystems
## instead of individual nodes in a subsystem.
func connect_save_load(id: Variant, save_func: Callable, load_func: Callable) -> void:
	if not history.is_empty():
		push_error(
			"CReverter error: " +
			"Connecting save/load functions after commiting is not supported. " +
			"Connection request will be ignored. " +
			"Make sure to connect everything before the first commit, " +
			"or to clear the history before connecting more save/load functions."
		)
		return
	if _connections.has(id):
		push_error(
			"CReverter error: " +
			"Connecting save/load functions under the same id multiple times " +
			"is not supported. " +
			"Connection request will be ignored. " +
			"Make sure to use unique ids such as by Object.get_instance_id()."
		)
		return

	_connections[id] = {
		"save_func": save_func,
		"load_func": load_func,
		"from_dictionary": false,
	}

	# Automatically disconnect removed nodes
	var save_object = save_func.get_object()
	if save_object is Node:
		save_object.tree_exiting.connect(_disconnect_save_load.bind(id))
	var load_object = load_func.get_object()
	if save_func.get_object_id() != load_func.get_object_id() and load_object is Node:
		load_object.tree_exiting.connect(_disconnect_save_load.bind(id))


## Call this to build and push a new memento to the [member history]
## after connecting objects with [method connect_save_load].
## If the [member cursor] is not at the newest position in the
## [member history], then it will remove all newer mementos
## than the one pointed to by the [member cursor] before pushing
## the new memento.
## [br][br]
## If the [member cursor] is on the newest memento and the number of
## mementos in [member history] is equal to [member CRHistory.max_size],
## then the memento at the oldest position will be forgotten.
## [br][br]
## Pass an optional [param tag] to tag the new memento.
## This enables loading it later with [method load_tag].
## Commiting with the same tag as an already exsting
## one moves the tag.
## [br][br]
## If the new memento is equal to the old memento, then no new
## memento will be pushed, though the old memento will
## be tagged with [param tag] if one is given.
## See [method CRMemento.equals] for the default behavior
## checking equality between mementos, which can be overridden.
## [br][br]
## Emits [signal saved] if the new memento was not deemed
## equal to the old one.
func commit(tag: StringName = "") -> void:
	if _connections.is_empty():
		push_error(
			"CReverter error: " +
			"Cannot commit because no save/load functions were connected. " +
			"Make sure to call CReverter.connect_save_load() before CReverter.commit()."
		)
		return

	var new_combined_state := _make_combined_state()

	# Abort if no change
	if not history.is_empty():
		var last_combined_state = history.get_item(cursor)
		if new_combined_state.equals(last_combined_state):
			if tag != "":
				history.add_tag(tag, cursor)
			return

	history._push(new_combined_state, cursor + 1)
	cursor = history.newest_position
	if tag != "":
		history.add_tag(tag, cursor)

	saved.emit()


## Moves the [member cursor] to the next older memento and loads it.
## Does nothing if [method is_undo_possible] returns [code]false[/code].
## [br][br]
## Emits [signal loaded] after loading.
func undo() -> void:
	if history.is_empty():
		push_warning(
			"CReverter warning: " +
			"History is empty. Ignoring load request."
		)
		return

	if is_undo_possible():
		cursor -= 1
		_load_by_cursor()
		loaded.emit()


## Moves the [member cursor] to the next newer memento and loads it.
## Does nothing if [method is_redo_possible] returns [code]false[/code].
## [br][br]
## Emits [signal loaded] after loading.
func redo() -> void:
	if history.is_empty():
		push_warning(
			"CReverter warning: " +
			"History is empty. Ignoring load request."
		)
		return

	if is_redo_possible():
		cursor += 1
		_load_by_cursor()
		loaded.emit()


## Loads the memento currently pointed to by the [member cursor].
## Does nothing if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func revert() -> void:
	if history.is_empty():
		push_warning(
			"CReverter warning: " +
			"History is empty. Ignoring load request."
		)
		return

	_load_by_cursor()
	loaded.emit()


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
	if history.is_empty():
		push_warning(
			"CReverter warning: " +
			"History is empty. Ignoring load request."
		)
		return

	cursor = history.newest_position
	_load_by_cursor()
	loaded.emit()


## Moves the [member cursor] to the oldest memento and loads it.
## Does nothing if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func load_oldest() -> void:
	if history.is_empty():
		push_warning(
			"CReverter warning: " +
			"History is empty. Ignoring load request."
		)
		return

	cursor = history.oldest_position
	_load_by_cursor()
	loaded.emit()


## Moves the [member cursor] to the given [param tag] and loads it.
## Does nothing if the tag was never previously added,
## or if the [member history] is empty.
## [br][br]
## Emits [signal loaded] after loading.
func load_tag(tag: StringName) -> void:
	if not history.has_tag(tag):
		push_warning(
			"CReverter warning: " +
			"Tag \"" + tag + "\" was not found in history. " +
			"Ignoring load request."
		)
		return

	if not history.is_empty():
		cursor = history.get_tag_position(tag)
		_load_by_cursor()
		loaded.emit()


func has_connected_funcs() -> bool:
	return not _connections.is_empty()


# Sets the cursor in the history by adding the tag CURSOR_TAG.
# It always clamps it in the history, so this can never put it out of bounds.
func set_cursor(position: int) -> void:
	if history.is_empty():
		return

	position = clampi(position, history.oldest_position, history.newest_position)
	history.add_tag(CURSOR_TAG, position)


func get_cursor() -> int:
	return history.get_tag_position(CURSOR_TAG)


func _disconnect_save_load(id: Variant) -> void:
	_connections.erase(id)


# Calls load functions pointed to by the cursor
func _load_by_cursor() -> void:
	var combined_state = history.get_item(cursor)
	_load_memento(combined_state)


# Calls load functions on the given memento, without setting the
# cursor in history.
func _load_memento(combined_state: CRMemento) -> void:
	# Only call connected load functions
	for id in _connections:
		var partial_state: CRMemento = combined_state.data[id]
		if partial_state != null:
			# Call with Dictionary or CRMemento according to how it was saved.
			if _connections[id].from_dictionary:
				_connections[id].load_func.call(partial_state.data)
			else:
				_connections[id].load_func.call(partial_state)


# Calls save functions to build a composite memento and returns it.
# CRMemento.data = {id_1: returned_1, ...}
func _make_combined_state() -> CRMemento:
	var combined_state := CRMemento.new()
	for id in _connections:
		# Build partial states by id first.
		var partial_state = _make_partial_state(id)
		# Then add it to CRMemento.data under the id as the key.
		combined_state.data[id] = partial_state
	return combined_state


# Calls the save function connected to the given id to build a memento,
# and then returns it.
func _make_partial_state(id: Variant) -> CRMemento:
	var partial_state = _connections[id].save_func.call()

	# Allow the return value to be either CRMemento or Dictionary.
	if partial_state is Dictionary:
		partial_state = CRMemento.new(partial_state)
		_connections[id].from_dictionary = true

	# Give a warning and abort if the return value was an incorrect type.
	if not partial_state is CRMemento:
		push_error(
			"CReverter error: " +
			"Built memento is not of type CRMemento. Returning null instead." +
			"Make sure that you only pass functions returning either a CRMemento " +
			"or a Dictionary as the save_func parameter to CReverter.connect_save_load()."
		)
		return null

	return partial_state
