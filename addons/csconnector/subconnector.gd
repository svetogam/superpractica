class_name CSConnector_Subconnector
extends RefCounted
## The [CSConnector] interface for particular [Node]s in the [SceneTree].
##
## [b]Never[/b] use this class directly. Only call its methods
## through [method CSConnector.with].

const _GROUP_PREFIX := "CSConnector_"
var _source: Node
var _agent_keys: Array = []
var _key_to_setups: Dictionary # {String: [Callable, ...], ...}
var _key_to_signal_connections: Dictionary
# {String: [{"signal_name": String, "callable": Callable}, ...], ...}


# This should only be called by the main connector.
func _init(p_source: Node) -> void:
	_source = p_source
	_source.tree_exiting.connect(_on_source_exiting_tree)


# Remove the subconnector when the source node exits the tree.
func _on_source_exiting_tree() -> void:
	# Use a duplicate list of agent keys because unregistration removes them
	for key in _agent_keys.duplicate():
		unregister(key)

	CSConnector._remove_subconnector(_source, self)


# Do things on newly registered agents if the subconnector previously
# initiated connection.
func _react_to_registration(agent: Node, key: String) -> void:
	# Call setup funcs
	for setup_func in _key_to_setups.get(key, []):
		setup_func.call(agent)

	# Connect signals
	for connection in _key_to_signal_connections.get(key, []):
		agent.connect(connection.signal_name, connection.callable)


# Do things on unregistered agents if they were previously connected.
func _react_to_unregistration(agent: Node, key: String) -> void:
	# Disconnect signals
	for connection in _key_to_signal_connections.get(key, []):
		if agent.is_connected(connection.signal_name, connection.callable):
			agent.disconnect(connection.signal_name, connection.callable)


## Registers the source [Node] under the [param agent_key], or does nothing
## if it is already registered under that key.
## The same source [Node] can be registered under many [param agent_key]s.
## To easily remember the [param agent_key], it is recommended to use the
## name of a group the [Node] is already in.
## [br][br]
## Call this with a [Node] lower in the [SceneTree] to initiate connection
## with an ancestor [Node].
## It can trigger callbacks connected by [method connect_setup] and
## [method connect_signal] on ancestor [Node]s.
## Registered [Node]s can be found using [method find].
## [br][br]
## On the backend, this adds the source [Node] to a [SceneTree] group
## (prefixed with [code]"CSConnector_"[/code]).
func register(agent_key: String) -> void:
	# Do nothing if already registered under the given key
	var group := _get_agent_group_name(agent_key)
	if not _source.is_in_group(group):
		# Store registration data
		_source.add_to_group(group)
		_agent_keys.append(agent_key)
		# Call the _react methods in subconnectors on ancestor nodes
		CSConnector._react_to_registration_in_higher_connectors(true, _source, agent_key)


## Unregisters the source [Node] if it was previously registered under
## [param agent_key], and does nothing otherwise.
## [br][br]
## Registered [Node]s are automatically unregistered upon
## [signal Node.tree_exiting].
## [br][br]
## This stops callbacks connected by [method connect_setup] and
## [method connect_signal] from being triggered.
func unregister(agent_key: String) -> void:
	# Do nothing if not registered under the given key
	var group := _get_agent_group_name(agent_key)
	if _source.is_in_group(group):
		# Call the _react methods in subconnectors on ancestor nodes
		CSConnector._react_to_registration_in_higher_connectors(false, _source, agent_key)
		# Remove registration data only after it's used in reactions
		_source.remove_from_group(group)
		_agent_keys.erase(agent_key)

	# Potentially delete the subconnector
	_free_if_empty()


## Initiates connection in the source [Node] with all descendant [Node]s
## registered under [param agent_key] to call [param setup_func] with
## that descendant [Node] as an argument.
## This can be called before or after [method register] is called with the
## descendant [Node]. [param setup_func] will be called immediately
## after both sides initate connection.
## [br][br]
## Multiple different [param setup_func]s can be connected to the
## same [param agent_key].
## Calling this to connect the same thing twice will push a warning and
## do nothing.
## [br][br]
## Descendant [Node]s that [method register], [method unregister], and
## [method register] again may trigger calling [param setup_func]
## multiple times.
func connect_setup(agent_key: String, setup_func: Callable) -> void:
	# Initiate data for agent_key
	if not _key_to_setups.has(agent_key):
		_key_to_setups[agent_key] = []

	# Push warning and abort if calling this twice on the same subconnector
	if _key_to_setups[agent_key].has(setup_func):
		push_warning("CSConnector warning: Setup connection already exists.")
		return

	# Store data to call the setup func with later registered nodes
	_key_to_setups[agent_key].append(setup_func)

	# Call the setup func with already registered nodes
	for agent in find(agent_key):
		setup_func.call(agent)


## Disconnects the connection made by [method connect_setup].
## This means that registering descendant [Node]s under [param agent_key]
## will no longer trigger calling [param setup_func] with them.
## [br][br]
## Calling this without previously connecting by [method connect_setup] will
## push a warning and do nothing.
func disconnect_setup(agent_key: String, setup_func: Callable) -> void:
	# Push warning and abort if not previously connected
	if not _key_to_setups.has(agent_key) or not _key_to_setups[agent_key].has(setup_func):
		push_warning("CSConnector warning: "
				+ "Setup connection to disconnect does not exist.")
		return

	# Remove data to no longer call setup func with registered nodes
	if _key_to_setups[agent_key].has(setup_func):
		_key_to_setups[agent_key].erase(setup_func)
		if _key_to_setups[agent_key].is_empty():
			_key_to_setups.erase(agent_key)

	# Potentially delete the subconnector
	_free_if_empty()


## Initiates connection in the source [Node] with all descendant [Node]s
## registered under [param agent_key] to connect the descendant [Node]'s
## signal named [param signal_name] to [param callback].
## This can be called before or after [method register] is called with the
## descendant [Node].
## The signal will be connected immediately after both sides
## initate connection.
## [br][br]
## Multiple different signal connections can be connected to the
## same [param agent_key].
## Calling this to connect the same thing twice will push a warning and
## do nothing.
func connect_signal(agent_key: String, signal_name: String, callback: Callable) -> void:
	# Initiate data for agent_key
	if not _key_to_signal_connections.has(agent_key):
		_key_to_signal_connections[agent_key] = []

	var connection := _make_signal_connection_dict(signal_name, callback)
	# Push warning and abort if calling this twice on the same subconnector
	if _key_to_signal_connections[agent_key].has(connection):
		push_warning("CSConnector warning: Signal connection already exists.")
		return

	# Store data to connect signals of later registered nodes
	_key_to_signal_connections[agent_key].append(connection)

	# Connect signals of alrady registered nodes
	for agent in find(agent_key):
		if not agent.is_connected(signal_name, callback):
			agent.connect(signal_name, callback)


## Disconnects the connection made by [method connect_signal].
## This means that registering descendant [Node]s under [param agent_key]
## will no longer trigger connection of signals named [param signal_name] to
## [param callback], and existing such connections will be disconnected.
## [br][br]
## Calling this without previously connecting by [method connect_signal] will
## push a warning and do nothing.
func disconnect_signal(agent_key: String, signal_name: String, callback: Callable
) -> void:
	var connection := _make_signal_connection_dict(signal_name, callback)
	# Push warning and abort if signal is not previously connected
	if (not _key_to_signal_connections.has(agent_key)
			or not _key_to_signal_connections[agent_key].has(connection)):
		push_warning("CSConnector warning: "
				+ "Signal connection to disconnect does not exist.")
		return

	# Remove data to no longer connect signals of registered nodes
	_key_to_signal_connections[agent_key].erase(connection)
	if _key_to_signal_connections[agent_key].is_empty():
		_key_to_signal_connections.erase(agent_key)

	# Disconnect signals of already registered and connected nodes
	for agent in find(agent_key):
		if agent.is_connected(signal_name, callback):
			agent.disconnect(signal_name, callback)

	# Potentially delete the subconnector
	_free_if_empty()


## Returns a list of all [Node]s registered under [param agent_key]
## that are descendants of the source [Node] in the [SceneTree].
func find(agent_key: String) -> Array[Node]:
	# Potentially delete the subconnector, but only after using it
	_free_if_empty.call_deferred()

	# Populate and return list
	var agents: Array[Node] = []
	var group := _get_agent_group_name(agent_key)
	for node in _source.get_tree().get_nodes_in_group(group):
		if _source.is_ancestor_of(node):
			agents.append(node)
	return agents


# Returns a dictionary with signal connection data.
static func _make_signal_connection_dict(signal_name: String, callable: Callable
) -> Dictionary:
	return {"signal_name": signal_name, "callable": callable}


# Returns a string for the custom group name associated the agent key.
static func _get_agent_group_name(agent_key: String) -> String:
	return _GROUP_PREFIX + agent_key


# Delete this subconnector if it keeps no data.
func _free_if_empty() -> void:
	if _is_empty():
		CSConnector._remove_subconnector(_source, self)


# Returns true if this subconnector keeps no data.
func _is_empty() -> bool:
	return (_agent_keys.is_empty() and _key_to_setups.is_empty()
			and _key_to_signal_connections.is_empty())
