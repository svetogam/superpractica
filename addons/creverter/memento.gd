class_name CRMemento
extends Resource
## Memento resource for use with [CReverter].
##
## [CRMemento] is a data structure for the mementos of [CReverter] and [CRHistory].
## It is designed so that [CRMemento]s can be composed together.
## [br][br]
## [CRMemento]s are passed around to connected objects by [signal CReverter.saving]
## and [signal CReverter.loading].
## Functions connected to [signal CReverter.saving] should call
## [method add_submemento] to build the memento.
## Functions connected to [signal CReverter.loading] should call
## [method get_submemento] and [method has_submemento] to load using the memento.
## [br][br]
## Extend this class to add more functionality to mementos.
## One reason to do so is to override [method equals].

## Main variable for keeping data in [CRMemento]s.
## Submementos are stored here.
## Extended [CRMemento]s can use it as well for other purposes.
## [br][br]
## The default behavior of [method equals] is to compare
## [member data] values against each other.
@export var data: Dictionary


## Pass a dictionary into [method CRMemento.new] to
## set [member data] on construction.
## Otherwise [member data] begins as an empty dictionary.
func _init(p_data := {}) -> void:
	data = p_data


## Takes another [CRMemento]-derived object and returns [code]true[/code] if
## they are equal, [code]false[/code] otherwise.
## [br][br]
## This is called by [CReverter] to determine if it should ignore a new commit
## due to it being the same as the previous one,
## if [member CReverter.only_push_changes] is [code]true[/code].
## The default behavior is to check equality of [member data], checking
## [method equals] recursively to compare [CRMemento] values.
## Override this method to change this behavior.
func equals(other: CRMemento) -> bool:
	if data.size() != other.data.size():
		return false
	for key in data:
		if not other.data.has(key):
			return false
		# Call CRMemento.equals() recursively
		if data[key] is CRMemento:
			if not data[key].equals(other.data[key]):
				return false
		# Use default dictionary comparison
		else:
			if data[key] != other.data[key]:
				return false
	return true


## Call this to save a submemento that will later be retrievable
## with the same [param id] using [method get_submemento].
## [br][br]
## Good options for [param id] are [member Node.name] and
## [method Object.get_instance_id].
## [br][br]
## While [param submemento] can be any type, it is recommended to make it a
## [Dictionary] or an object extending [CRMemento].
func add_submemento(id: Variant, submemento: Variant) -> void:
	if not data.has(id):
		data[id] = submemento
	else:
		push_warning(
			"CReverter Warning: Ignoring submemento being saved to already saved ID: "
			+ str(id)
		)


## Returns the submemento for the same [param id]
## previously saved by [method add_submemento].
func get_submemento(id: Variant) -> Variant:
	if data.has(id):
		return data[id]
	else:
		push_warning(
			"CReverter Warning: Memento does not have ID: " + str(id)
			+ "; returning null."
			+ " You might want to call CRMemento.has_submemento() to avoid this."
		)
	return null


## Returns [code]true[/code] if a submemento can be accessed by calling
## [method get_submemento] with [param id].
## [br][br]
## This is useful when the object represented by [param id] has a shorter
## lifetime than the [CReverter] history,
## so that the lack of a submemento implies that object did not exist when saving.
func has_submemento(id: Variant) -> bool:
	return data.has(id)
