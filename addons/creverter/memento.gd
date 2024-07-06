class_name CRMemento
extends Resource
## Memento resource for the Composite Reverter.
##
## [CRMemento] is a data structure for the mementos of the [CReverter].
## It is designed so that [CRMemento]s can be composed together.
## [br][br]
## The [CReverter] can be used without touching this directly.
## Extend this class to add functionality to mementos.
## One reason to do so is to override [method equals].

## Utility variable for adding data to the [CRMemento] without
## having to extend it and define new variables.
## [br][br]
## The default behavior of [method equals] is to compare
## [member data] values against each other.
@export var data: Dictionary


## Pass a dictionary into [method CRMemento.new] to
## set [member data] on construction.
## Otherwise [member data] begins as an empty dictionary.
func _init(p_data := {}) -> void:
	data = p_data


## Takes another [CRMemento]-derived resource and returns [code]true[/code] if
## they are equal, [code]false[/code] otherwise.
## [br][br]
## This is called by the
## [CReverter] to determine if it should ignore a new commit due to
## it being the same as the previous one.
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
