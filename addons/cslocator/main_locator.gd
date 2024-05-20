class_name CSLocator
## The main class for the Contextual Service Locator.
##
## All uses of the CSLocator should go through [method CSLocator.with] and
## select a method with the dot operator.
## For example:
## [code]CSLocator.with(self).register("my_service", my_service)[/code]
## [br][br]
## See [CSLocator_Sublocator] for the set of methods.

const _SERVICE_SIGNAL_PREFIX := "service_signal:"
static var _sublocators_dict: Dictionary # {int: Array[CSLocator_Sublocator], ...}
static var _signaler := Object.new() # Hack to add signals in a static class


## Generates a [CSLocator_Sublocator] pointing to the [param source] [Node]
## passed into it.
## [br][br]
## The [param source] [Node] [b]must[/b] be in the scene tree, otherwise it
## pushes an error and returns [code]null[/code].
## [br][br]
## It is [b]not[/b] a supported use to keep references to sublocators, such as by
## [code]var oops = CSLocator.with(self)[/code]. This can lead to
## unexpected behavior.
static func with(source: Node) -> CSLocator_Sublocator:
	# Give error if used incorrectly
	if source == null or not source.is_inside_tree():
		push_error("CSLocator error: Must pass a node in the scene tree.")
		return null

	return _add_sublocator(source)


# Keep references to sublocators so they don't get garbage-collected,
# and so they can be accessed together through the source node.
static func _add_sublocator(source: Node) -> CSLocator_Sublocator:
	var sublocator := CSLocator_Sublocator.new(source)
	var source_id := source.get_instance_id()
	if not _sublocators_dict.has(source_id):
		var new_sublocator_array: Array[CSLocator_Sublocator] = []
		_sublocators_dict[source_id] = new_sublocator_array
	_sublocators_dict[source_id].append(sublocator)
	return sublocator


# Remove reference to sublocator, making it get garbage-collected.
# Takes the source, though it could find it, for better performance.
static func _free_sublocator(source: Node, sublocator: CSLocator_Sublocator) -> void:
	var source_id := source.get_instance_id()
	_sublocators_dict[source_id].erase(sublocator)
	if _sublocators_dict[source_id].is_empty():
		_sublocators_dict.erase(source_id)


static func _get_sublocators(source: Node) -> Array[CSLocator_Sublocator]:
	var source_id := source.get_instance_id()
	if _sublocators_dict.has(source_id):
		return _sublocators_dict[source_id]
	return []


# First connection initializes the signal
static func _connect_service_signal(service_name: String, callback: Callable) -> void:
	var signal_name := _get_service_signal_name(service_name)

	# Initialize service signal if necessary
	if not _signaler.has_user_signal(signal_name):
		_signaler.add_user_signal(signal_name)

	if not _signaler.is_connected(signal_name, callback):
		_signaler.connect(signal_name, callback)


static func _disconnect_service_signal(service_name: String, callback: Callable) -> void:
	var signal_name := _get_service_signal_name(service_name)
	if (_signaler.has_user_signal(signal_name)
			and _signaler.is_connected(signal_name, callback)):
		_signaler.disconnect(signal_name, callback)


# Does not emit the signal if it was never initialized before
static func _emit_service_signal(service_name: String) -> void:
	var signal_name := _get_service_signal_name(service_name)
	if _signaler.has_user_signal(signal_name):
		_signaler.emit_signal(signal_name)


static func _get_service_signal_name(service_name: String) -> String:
	return _SERVICE_SIGNAL_PREFIX + service_name
