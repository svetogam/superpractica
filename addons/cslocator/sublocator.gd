class_name CSLocator_Sublocator
extends RefCounted
## This class gives an interface to the Contextual Service Locator on the
## source [Node] it was generated on.
##
## [b]Never[/b] use this class directly. Only call its public methods
## through [method CSLocator.with].
## [br][br]
## Services are stored in the source [Node]'s metadata,
## via [method Object.set_meta].
## [br][br]
## Sublocators are automatically deleted when the source [Node] exits the tree.

const _MAX_TREE_DEPTH: int = 10000
const _META_PREFIX := "CSLocator_"
var _source: Node
var _last_found_service_id: Variant = "uninitiated"


# This should only be called by the main locator.
func _init(p_source: Node) -> void:
	_source = p_source
	_source.tree_exiting.connect(_on_source_exiting_tree)


# Remove all sublocators when the source node exits the tree.
func _on_source_exiting_tree() -> void:
	CSLocator._free_sublocator(_source, self)


## Registers [param service] on the source [Node] under the key
## [param service_name].
## [br][br]
## This can change the service that is found when calling [method find],
## and it can trigger callbacks connected by [method connect_service_found]
## and [method connect_service_changed].
## [br][br]
## Passing in [code]null[/code] for the [param service] is identical to calling
## [method unregister].
func register(service_name: String, service: Object) -> void:
	if service == null:
		unregister(service_name)
		return

	var meta_key := CSLocator_Sublocator._get_service_meta_key(service_name)
	_source.set_meta(meta_key, {"service": service})
	CSLocator._emit_service_signal(service_name)


## Unregisters any previously registered service on the source [Node]
## under the key [param service_name]. This does nothing if nothing
## was previously registered.
## [br][br]
## This can change the service that is found when calling [method find],
## and it can trigger callbacks connected by [method connect_service_changed].
func unregister(service_name: String) -> void:
	var meta_key := CSLocator_Sublocator._get_service_meta_key(service_name)
	var meta_dict: Dictionary = _source.get_meta(meta_key, {})
	meta_dict.erase("service")
	_source.set_meta(meta_key, meta_dict)
	CSLocator._emit_service_signal(service_name)


## Returns the service registered under the key [param service_name]
## on the nearest ancestor of the source [Node], including itself.
## Or it returns [code]null[/code] if no service is found.
func find(service_name: String) -> Object:
	var meta_key := CSLocator_Sublocator._get_service_meta_key(service_name)
	var next_node: Node = _source # Begin with self
	for _i in range(_MAX_TREE_DEPTH): # Avoid infinite loop just in case
		# Return null if reached beyond the root node
		if next_node == null:
			return null

		# If node has CSLocator metadata
		elif next_node.has_meta(meta_key):
			var meta_dict: Dictionary = next_node.get_meta(meta_key)
			if meta_dict.has("service"):
				# Return first-found service metadata, which could be null
				return meta_dict["service"]

		# Try next ancestor
		next_node = next_node.get_parent()

	return null


# Only one callback can be set for each `CSLocator.with` line.
## Calls [param callback] with the first service registered
## under the key [param service_name] on any ancestor of the source [Node],
## including itself.
## It will call [param callback] only once, and will call it immediately if
## the service is found immediately.
## It will never pass [code]null[/code] to the [param callback].
## [br][br]
## Multiple callbacks can be set for the same source [Node]
## and [param service_name].
func connect_service_found(service_name: String, callback: Callable) -> void:
	var found_service := find(service_name)

	if found_service == null:
		# Try calling this again for next register/unregister
		CSLocator._connect_service_signal(service_name,
				connect_service_found.bind(service_name, callback))
	else:
		# Call the callback only the first time the service is found
		callback.call(found_service)
		CSLocator._disconnect_service_signal(service_name, connect_service_found)


## Calls [param callback] with the same output as calling [method find]
## on the source [Node].
## That is, with the service registered under the key [param service_name]
## on the nearest ancestor of the source [Node], including itself,
## or with [code]null[/code] if no service is found.
## It calls [param callback] immediately and every time the found service
## changes.
## [br][br]
## Multiple callbacks can be set for the same source [Node]
## and [param service_name].
func connect_service_changed(service_name: String, callback: Callable) -> void:
	var found_service := find(service_name)

	# Call this again for every next register/unregister
	CSLocator._connect_service_signal(service_name,
			connect_service_changed.bind(service_name, callback))

	# Call the callback with every changed value
	var service_changed := _check_and_update_current_service(found_service)
	if service_changed:
		callback.call(found_service)


## Disconnects all callbacks previously connected on the source [Node]
## under the key [param service_name]
## via [method connect_service_found] and [method connect_service_changed].
## [br][br]
## Does nothing if nothing was previously connected.
func disconnect_service(service_name: String) -> void:
	for sublocator in CSLocator._get_sublocators(_source):
		CSLocator._disconnect_service_signal(service_name,
				sublocator.connect_service_changed)
		CSLocator._disconnect_service_signal(service_name,
				sublocator.connect_service_found)


# Returns true if service changed, and false otherwise.
# Checks against the service this was last called with.
func _check_and_update_current_service(found_service: Object) -> bool:
	var changed: bool = (
		(_last_found_service_id is String and _last_found_service_id == "uninitiated")
		or (found_service != null and _last_found_service_id == null)
		or (found_service == null and _last_found_service_id != null)
		or (found_service != null
		and found_service.get_instance_id() != _last_found_service_id)
	)

	# Updates last found as either an object instance id or null
	if found_service == null:
		_last_found_service_id = null
	else:
		_last_found_service_id = found_service.get_instance_id()

	return changed


static func _get_service_meta_key(service_name: String) -> String:
	return _META_PREFIX + service_name
