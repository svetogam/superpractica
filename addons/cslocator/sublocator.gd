class_name CSLocator_Sublocator
extends RefCounted
## The [CSLocator] interface for particular [Node]s in the [SceneTree].
##
## [b]Never[/b] use this class directly. Only call its methods
## through [method CSLocator.with].

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


## Registers [param service] on the source [Node] under [param service_key].
## [br][br]
## This can change the service found by [method find],
## and it can trigger callbacks connected by [method connect_service_found]
## and [method connect_service_changed].
## [br][br]
## Passing in [code]null[/code] for the [param service] is identical to calling
## [method unregister].
func register(service_key: String, service: Object) -> void:
	if service == null:
		unregister(service_key)
		return

	var meta_key := CSLocator_Sublocator._get_service_meta_key(service_key)
	_source.set_meta(meta_key, {"service": service})
	CSLocator._emit_service_signal(service_key)


## Unregisters any previously registered service on the source [Node]
## under [param service_key].
## This does nothing if nothing was previously registered.
## [br][br]
## This can change the service found by [method find],
## and it can trigger callbacks connected by [method connect_service_changed].
func unregister(service_key: String) -> void:
	var meta_key := CSLocator_Sublocator._get_service_meta_key(service_key)
	var meta_dict: Dictionary = _source.get_meta(meta_key, {})
	meta_dict.erase("service")
	_source.set_meta(meta_key, meta_dict)
	CSLocator._emit_service_signal(service_key)


## Returns the service registered under [param service_key]
## on the nearest ancestor of the source [Node], including itself,
## or [param default] if no service is found.
func find(service_key: String, default: Object = null) -> Object:
	var meta_key := CSLocator_Sublocator._get_service_meta_key(service_key)
	# Start with the source
	var next_node: Node = _source
	# End eventually to ensure against an infinite loop
	for _i in range(_MAX_TREE_DEPTH):
		# End when beyond the root node
		if next_node == null:
			break
		# If node has CSLocator metadata
		elif next_node.has_meta(meta_key):
			var meta_dict: Dictionary = next_node.get_meta(meta_key)
			if meta_dict.has("service"):
				# Return first-found service metadata, which could be null
				return meta_dict["service"]
		# Try next ancestor
		next_node = next_node.get_parent()

	# Return null or given default if nothing is found
	return default


# Only one callback can be set for each `CSLocator.with` line.
## Calls [param callback] with the first service registered
## under [param service_key] on any ancestor of the source [Node],
## including itself.
## It will call [param callback] only once, and will call it immediately if
## the service is found immediately.
## It will never call [param callback] with [code]null[/code].
## [br][br]
## Multiple callbacks can be set for the same source [Node]
## and [param service_key].
func connect_service_found(service_key: String, callback: Callable) -> void:
	var found_service := find(service_key)

	if found_service == null:
		# Try calling this again for next register/unregister
		CSLocator._connect_service_signal(service_key,
				connect_service_found.bind(service_key, callback))
	else:
		# Call the callback only the first time the service is found
		callback.call(found_service)
		CSLocator._disconnect_service_signal(service_key, connect_service_found)


## Calls [param callback] with the same output as calling [method find]
## on the source [Node].
## That is, with the service registered under [param service_key]
## on the nearest ancestor of the source [Node], including itself,
## or with [param default] if no service is found.
## It calls [param callback] immediately and every time the found service
## changes.
## It will never call [param callback] with [code]null[/code] if
## [param default] is not [code]null[/code].
## [br][br]
## Multiple callbacks can be set for the same source [Node]
## and [param service_key].
func connect_service_changed(service_key: String, callback: Callable,
		default: Object = null
) -> void:
	var found_service := find(service_key, default)

	# Call this again for every next register/unregister
	CSLocator._connect_service_signal(service_key,
			connect_service_changed.bind(service_key, callback, default))

	# Call the callback with every changed value
	var service_changed := _check_and_update_current_service(found_service)
	if service_changed:
		callback.call(found_service)


## Disconnects all callbacks previously connected on the source [Node]
## under [param service_key] by [method connect_service_found] and
## [method connect_service_changed].
## [br][br]
## Does nothing if nothing was previously connected.
func disconnect_service(service_key: String) -> void:
	for sublocator in CSLocator._get_sublocators(_source):
		CSLocator._disconnect_service_signal(service_key,
				sublocator.connect_service_changed)
		CSLocator._disconnect_service_signal(service_key,
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


static func _get_service_meta_key(service_key: String) -> String:
	return _META_PREFIX + service_key
