require "json"
require "./shiny_json_logic/errors/base"
require "./shiny_json_logic/errors/invalid_arguments"
require "./shiny_json_logic/errors/not_a_number"
require "./shiny_json_logic/errors/unknown_operator"
require "./shiny_json_logic/truthy"
require "./shiny_json_logic/scope_stack"
require "./shiny_json_logic/operations/base"
require "./shiny_json_logic/operations/numerics"
require "./shiny_json_logic/operations/compare_chain"
require "./shiny_json_logic/operations/iterables"
require "./shiny_json_logic/operations/strings"
require "./shiny_json_logic/operations/var"
require "./shiny_json_logic/operations/val"
require "./shiny_json_logic/operations/missing"
require "./shiny_json_logic/operations/missing_some"
require "./shiny_json_logic/operations/exists"
require "./shiny_json_logic/operations/equal"
require "./shiny_json_logic/operations/strict_equal"
require "./shiny_json_logic/operations/different"
require "./shiny_json_logic/operations/strict_different"
require "./shiny_json_logic/operations/greater"
require "./shiny_json_logic/operations/greater_equal"
require "./shiny_json_logic/operations/smaller"
require "./shiny_json_logic/operations/smaller_equal"
require "./shiny_json_logic/operations/not"
require "./shiny_json_logic/operations/double_not"
require "./shiny_json_logic/operations/or"
require "./shiny_json_logic/operations/and"
require "./shiny_json_logic/operations/if"
require "./shiny_json_logic/operations/coalesce"
require "./shiny_json_logic/operations/addition"
require "./shiny_json_logic/operations/subtraction"
require "./shiny_json_logic/operations/product"
require "./shiny_json_logic/operations/division"
require "./shiny_json_logic/operations/modulo"
require "./shiny_json_logic/operations/max"
require "./shiny_json_logic/operations/min"
require "./shiny_json_logic/operations/concatenation"
require "./shiny_json_logic/operations/substring"
require "./shiny_json_logic/operations/inclusion"
require "./shiny_json_logic/operations/merge"
require "./shiny_json_logic/operations/map"
require "./shiny_json_logic/operations/filter"
require "./shiny_json_logic/operations/reduce"
require "./shiny_json_logic/operations/all"
require "./shiny_json_logic/operations/some"
require "./shiny_json_logic/operations/none"
require "./shiny_json_logic/operations/throw"
require "./shiny_json_logic/operations/try"
require "./shiny_json_logic/operations/preserve"
require "./shiny_json_logic/engine"

module ShinyJsonLogic
  VERSION = "0.1.0"

  def self.apply(rule : JSON::Any, data : JSON::Any = JSON::Any.new(nil)) : JSON::Any
    scope_stack = Array(JSON::Any).new
    scope_stack << data
    Engine.call(rule, scope_stack)
  end

  # Accept raw Hash/Array/primitives via JSON round-trip for ergonomics in specs
  def self.apply(rule : String, data : String = "null") : JSON::Any
    apply(JSON.parse(rule), JSON.parse(data))
  end
end

JsonLogic = ShinyJsonLogic
JSONLogic = ShinyJsonLogic
