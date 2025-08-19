class_name CRHistory
extends Resource
## History resource for use with [CReverter].
##
## [CRHistory] is a data structure containing [CRMemento]s and tags,
## combined with a few other functions.
## [br][br]
## Most uses of [CReverter] do not require accessing this class directly.
## Good reasons to access this class are to set the [member max_size],
## [method clear] the history, and draw the history.

## Constant signifying an invalid position in the history.
const NULL_POSITION: int = -1
## Constant signifying the first position in the history.
const FIRST_POSITION: int = 0
## Maximum number of items that can be added before items begin
## to be forgotten, from oldest to newest.
## [br][br]
## It is recommended to clear the history before shrinking its max size.
## If this is reduced to allow fewer items than are in the history,
## then items will be forgotten in an unspecified but efficient way.
@export var max_size: int = 10000:
	set = _set_max_size
## Position of the newest item in the history. This is equal to
## [constant NULL_POSITION] when the history is empty.
var newest_position: int:
	get = _get_newest_position
## Position of the oldest item in the history. This is equal to
## [constant NULL_POSITION] when the history is empty and to
## [constant FIRST_POSITION] when it is not empty.
var oldest_position: int:
	get = _get_oldest_position
var _stack: Array[CRMemento] = []
var _tags: Dictionary = {} #[String, int]


## Adds the given tag to the item at the given position, or moves
## the tag there if it already exists.
## Does nothing if the history is empty or if the position is out of bounds.
## [br][br]
## The first position in the history is equal to [constant FIRST_POSITION].
func add_tag(tag: String, position: int) -> void:
	if is_empty() or position < FIRST_POSITION or position > newest_position:
		return

	_tags[tag] = position


## Removes the given tag.
## [br][br]
## Does nothing if the tag does not exist.
func remove_tag(tag: String) -> void:
	_tags.erase(tag)


## Clears the history, forgetting all items and tags.
## [br][br]
## This can be called safely while [CReverter] is in operation.
func clear() -> void:
	_stack = []
	_tags = {}


## Returns the [CRMemento] at the given position if the position is valid.
## Returns [code]null[/code] if the history is empty or if the position is
## out of bounds.
## [br][br]
## The first position in the history is equal to [constant FIRST_POSITION].
func get_item(position: int) -> CRMemento:
	if is_empty() or position < FIRST_POSITION or position > newest_position:
		return null

	return _stack[position]


## Returns the position in the history of the given tag,
## or [constant NULL_POSITION] if it does not exist.
## [br][br]
## The first position in the history is equal to [constant FIRST_POSITION].
func get_tag_position(tag: String) -> int:
	return _tags.get(tag, NULL_POSITION)


## Returns an array of all the tags at the given position,
## or an empty array if the given position is out of bounds.
## [br][br]
## The first position in the history is equal to [constant FIRST_POSITION].
func get_tags_at(position: int) -> Array:
	var dict = _get_position_to_tags_dict()
	return dict.get(position, [])


## Returns the number of items in the history.
func size() -> int:
	return _stack.size()


## Returns [code]true[/code] if the history is empty, [code]false[/code] otherwise.
func is_empty() -> bool:
	return _stack.is_empty()


## Returns [code]true[/code] if the history has the given tag,
## [code]false[/code] otherwise.
func has_tag(tag: String) -> bool:
	return _tags.has(tag)


# Push to the given position, replacing it and forgetting all items in front of it.
# Pushes to the end by default.
func _push(item: CRMemento, position: int = NULL_POSITION) -> void:
	if position < NULL_POSITION or position > newest_position + 1:
		return

	if position == 0:
		_stack = []

	elif position != NULL_POSITION and position != newest_position + 1:
		_forget_from(position - 1)

	_stack.append(item)

	if _stack.size() > max_size:
		_forget_behind(FIRST_POSITION + 1)


# Forget everything in front of the given position
func _forget_from(position: int) -> void:
	if is_empty() or position < FIRST_POSITION or position >= newest_position:
		return

	_stack = _stack.slice(0, position + 1)

	# Forget tags
	var position_to_tags_dict := _get_position_to_tags_dict()
	for tag_position in position_to_tags_dict:
		if tag_position > newest_position:
			for tag in position_to_tags_dict[tag_position]:
				_tags.erase(tag)


# Forget everything behind the given position
func _forget_behind(position: int) -> void:
	if is_empty() or position <= FIRST_POSITION or position > newest_position:
		return

	# Forget tags
	var position_to_tags_dict := _get_position_to_tags_dict()
	for tag_position in position_to_tags_dict:
		if tag_position < position:
			for tag in position_to_tags_dict[tag_position]:
				_tags.erase(tag)

	_stack = _stack.slice(position)

	# Update tag positions
	for tag in _tags:
		_tags[tag] = _tags[tag] - position


# Forgets newest items to fit if necessary.
func _set_max_size(p_max_size: int) -> void:
	if not is_empty() and p_max_size < max_size:
		_forget_from(p_max_size - 1)
	max_size = p_max_size


func _get_newest_position() -> int:
	return size() - 1


func _get_oldest_position() -> int:
	if is_empty():
		return NULL_POSITION
	return FIRST_POSITION


# Returns Dictionary[int, [Array[String]]]
func _get_position_to_tags_dict() -> Dictionary:
	var dict := {}
	for tag in _tags:
		var position = _tags[tag]
		if not dict.has(position):
			dict[position] = []
		dict[position].append(tag)
	return dict
