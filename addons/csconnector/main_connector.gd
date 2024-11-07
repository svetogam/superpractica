class_name CSConnector
extends Object
## The main class for the Contextual Signal/Setup Connector.
##
## [CSConnector] is a static class that helps decouple connections
## between a common ancestor [Node] higher in the [SceneTree] and
## descendant [Node]s below it in the [SceneTree].
## [br][br]
## Basic usage is to call, in any order:
## [br]
## * [method CSConnector_Subconnector.register] with the descendant "agent"
## [Node]s to connect.
## [br]
## * A method such as [method CSConnector_Subconnector.connect_signal]
## with the ancestor "context" [Node] responsible for managing the agents.
## [br][br]
## All uses of [CSConnector] should go through [method CSConnector.with] and
## select a method with the dot operator.
## For example:
## [codeblock]
## CSConnector.with(self).register("key")
## [/codeblock]
## See [CSConnector_Subconnector] for the set of methods.

const _MAX_TREE_DEPTH: int = 10000
static var _id_to_subconnector: Dictionary # {int: CSConnector_Subconnector, ...}


## Returns a [CSConnector_Subconnector] pointing to the [param source] [Node].
## [br][br]
## The [param source] [Node] [b]must[/b] be in the [SceneTree], otherwise it
## pushes an error and returns [code]null[/code].
## [br][br]
## It is [b]not[/b] a supported use to keep references to subconnectors,
## such as by [code]var oops = CSConnector.with(self)[/code].
## This can lead to unexpected behavior.
static func with(source: Node) -> CSConnector_Subconnector:
	# Give error if used incorrectly
	if source == null or not source.is_inside_tree():
		push_error("CSConnector error: Node must be in scene tree.")
		return null

	# Use an existing subconnector for the source node or make a new one
	var subconnector = _get_subconnector(source)
	if subconnector != null:
		return subconnector
	return _add_subconnector(source)


# Add a new subconnector to be gettable by the node's instance id.
static func _add_subconnector(node: Node) -> CSConnector_Subconnector:
	var subconnector := CSConnector_Subconnector.new(node)
	var node_id := node.get_instance_id()
	if not _id_to_subconnector.has(node_id):
		_id_to_subconnector[node_id] = subconnector
	return subconnector


# Get a subconnector by the node's instance id.
static func _get_subconnector(node: Node) -> CSConnector_Subconnector:
	return _id_to_subconnector.get(node.get_instance_id(), null)


# Remove subconnector, which should also automatically free it.
static func _remove_subconnector(node: Node, subconnector: CSConnector_Subconnector
) -> void:
	var node_id := node.get_instance_id()
	_id_to_subconnector.erase(node_id)


# Make subconnectors on ancestors of the source node react to
# registration/unregistration.
static func _react_to_registration_in_higher_connectors(registered: bool,
		source: Node, agent_key: String
) -> void:
	var subconnector: CSConnector_Subconnector
	# Start with the source's parent
	var next_node := source.get_parent()
	# End eventually to ensure against an infinite loop
	for i in range(_MAX_TREE_DEPTH):
		# End when beyond the root node
		if next_node == null:
			return
		# Call reaction on the subconnector for that node if it has one
		subconnector = _get_subconnector(next_node)
		if subconnector != null:
			if registered:
				subconnector._react_to_registration(source, agent_key)
			else:
				subconnector._react_to_unregistration(source, agent_key)
		# Continue to the next parent
		next_node = next_node.get_parent()
