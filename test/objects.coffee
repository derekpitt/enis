enis = require '../src/enis'
assert = require 'assert'


are_equal = (input_string, expected_object) ->
  input_result = enis.compile input_string
  assert.deepEqual input_result, expected_object


describe 'equal objects', ->
  it 'should be equal for booleans', ->
    input = """
      test {
        bool -> true
      }
    """

    are_equal input,
      test:
        bool: true


  it 'should be equal for strings', ->
    input = """
      test {
        string -> 'string'
      }
    """

    are_equal input,
      test:
        string: "string"


  it 'should be equal for numbers', ->
    input = """
      test {
        number -> 123
      }
    """

    are_equal input,
      test:
        number: 123


  it 'should be equal for blocks', ->
    input = """
      test {
        block -> {
          string -> 'pow'
        }
        block2 -> {
          string -> 'pow pow'
        }
      }
    """

    are_equal input,
      test:
        block:
          string: "pow"
        block2:
          string: "pow pow"


  it 'should be equal for references', ->
    input = """
      ref {
        pow -> 'pow'
      }

      test {
        reference -> ref
      }
    """

    are_equal input,
      ref:
        pow: "pow"
      test:
        reference:
          pow: "pow"


  it 'should be equal for inheritance', ->
    input = """
      base {
        pow -> 'pow'
      }

      test <- base {
        some_other -> 123
      }
    """

    are_equal input,
      base:
        pow: "pow"
      test:
        __inherits: "base"
        pow: "pow"
        some_other: 123


  it 'should be equal when inherits a block and adds a key', ->
    input = """
      base {
        pow -> {
          powpow -> 123
        }
      }

      test <- base {
        pow -> {
          whammy -> '123'
        }
      }
    """

    are_equal input,
      base:
        pow:
          powpow: 123
      test:
        __inherits: "base"
        pow:
          powpow: 123
          whammy: '123'


  it 'should be super advanced equal', ->
    input = """
      ref {
        pow -> 789
        pow2 -> 'pow pow'
      }

      test <- ref {
        pow -> 123
        integer_test -> 123
        string_test -> '123'
        bool_test -> false
        ref_test -> ref
        block_test -> {
          integer_test2 -> 456
        }
      }
    """

    are_equal input,
      ref:
        pow: 789
        pow2: "pow pow"
      test:
        __inherits: "ref"
        pow: 123
        pow2: "pow pow"
        string_test: "123"
        bool_test: false
        integer_test: 123
        ref_test:
          pow: 789
          pow2: "pow pow"
        block_test:
          integer_test2: 456


describe 'name and type check', ->
  it 'should throw if a top level block is defined more than once', ->
    input = """
      test {
        test -> 123
      }

      test {
        pow -> 'pow'
      }
    """

    assert.throws -> enis.compile input


  it 'should throw if you reference something that does not exist', ->
    input = """
      test {
        pow -> pow
      }
    """

    assert.throws -> enis.compile input


  it 'should throw if you declare a property more than once', ->
    input = """
      test {
        whammy -> 123
        whammy -> 456
      }
    """

    assert.throws -> enis.compile input

    input = """
      test {
        whammy -> {
          whammy -> 123
          whammy -> 456
        }
      }
    """

    assert.throws -> enis.compile input


  it 'should throw if you change the type on an inherited property', ->
    input = """
      base {
        pow -> 'pow'
      }

      test <- base {
        pow -> 123
      }
    """

    assert.throws -> enis.compile input

    input = """
      base {
        pow -> {
          pow2 -> '123'
        }
      }

      test <- base {
        pow -> {
          pow2 -> 123
        }
      }
    """

    assert.throws -> enis.compile input


  it 'should not throw if you inherit a block and add a key not in the original', ->
    input = """
      base {
        pow -> {
          key1 -> 'pow'
        }
      }

      test <- base {
        pow -> {
          key2 -> 123
        }
      }
    """

    assert.doesNotThrow -> enis.compile input


  it 'should not throw if you do not change the type on an inherited property', ->
    input = """
      base {
        pow -> 'pow'
      }

      test <- base {
        pow -> '123'
      }
    """

    assert.doesNotThrow -> enis.compile input
