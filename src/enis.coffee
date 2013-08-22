_ = require 'underscore'
parser = require './grammar'

parse = (input_string) -> parser.parse input_string

global_object = {}

current_top_block = null

parse_node = (node, block_object = null) ->
  _.extend (block_object || global_object), switch node.type
    when "top_block" then parse_top_block node
    when "block" then parse_block node
    when "property" then parse_property node, block_object


parse_top_block = (node) ->
  if global_object[node.name]?
    throw new Error "Name already exisits"

  global_object[node.name] = {}
  current_top_block = node.name

  if node.inherits?
    _.extend global_object[node.name], global_object[node.inherits]
    global_object[node.name].__inherits = node.inherits

  parse_node node.value, global_object[node.name]

  global_object


parse_block = (node) ->
  block_object = {}
  parse_node node, block_object for node in node.value
  block_object


check_types = (a, b) ->
  if (typeof a) != (typeof b)
    return false

  if _.isArray a # we have to check for array first since _.isObject([]) === true
    return true # Temporary for now..
  else if _.isObject a
    _.every(check_types a[k], b[k] for k of a)
  else
    true


parse_property = (node, block_object = null) ->
  property = {}

  property_value = node.value

  top_block_inherits = global_object[current_top_block].__inherits?
  inherited_object = if top_block_inherits
    global_object[global_object[current_top_block].__inherits]
  else
    null

  property[node.name] = switch property_value.type
    when "integer", "string", "bool" then property_value.value
    when "block"
      if top_block_inherits
        _.extend {}, inherited_object[node.name], parse_block property_value
      else
        parse_block property_value

    when "reference"
      if global_object[property_value.value]?
        _.extend {}, global_object[property_value.value]
      else
        throw new Error "Reference #{property_value.value} does not exist"

  # check to see if this node is inherited, and if so, make sure we are not
  # changing types
  if top_block_inherits
    # TODO: if objects, do a deep compare
    if inherited_object[node.name]? and check_types(inherited_object[node.name], property[node.name]) == false
      throw new Error "Cannot change types of inherited properties"
  else
    if block_object[node.name]?
      throw new Error "Property #{node.name} already exisits"

  property


compile = (input_string) ->
  ast = parse input_string

  global_object = {}
  
  parse_node node, global_object for node in ast

  global_object



module.exports = {
  parse
  compile
}

