enis = require '../src/enis'
assert = require 'assert'

describe 'good parsing', ->
  it 'should parse (simple)', ->
    input = """
      test {
        test_property -> 123
      }
    """

    assert.doesNotThrow -> enis.parse input


  it 'should parse (advanced)', ->
    input = """
      cool {
        powpow -> 'ok'
      }

      test <- cool {
        test_property -> 123
        test_property2 -> 'powpow'
        test_property3 -> true
        block_test -> {
          test_property -> 456
        }
      }
    """

    assert.doesNotThrow -> enis.parse input



describe 'bad parsing', ->
  it 'should not parse', ->
    input = 'poop'
    assert.throws -> enis.parse input


  it 'should not parse because of trailing whitespace', ->
    input = """
      test { 
        test -> 123 
      } 
    """

    assert.throws -> enis.parse input

