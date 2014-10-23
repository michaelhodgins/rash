###
Represents the root of the CSS AST.
###
class StyleSheet
    constructor: (@rules) ->

    toCSS: ->
        @rules.map (rule) ->
            rule.toCSS()
        .join  "\n"

    rash: ->
        @

###
Represents a single CSS rule, consisting on a selector and one or more properties.
###
class Rule
    constructor: (@selector, @properties) ->

    toCSS: ->
        properties = @properties.map (property) ->
            property.toCSS()
        .join ";"
        "#{@selector} {#{properties}}"

###
Represents a single CSS property, consisting of a style name, and one or more values.
###
class Property
    constructor: (@name, @values) ->

    toCSS: ->
        values = @values.map (value) ->
            value.toCSS()
        .join " "
        "#{@name}: #{values}"

###
Rep
###
class ValueList
    constructor: (@values) ->

    toCSS: ->

###
Represents a literal value.
###
class Literal
    constructor: (@value) ->

    toCSS : ->
        @value

# export the classes
exports.StyleSheet = StyleSheet
exports.Rule = Rule
exports.Property = Property
exports.Literal = Literal
exports.ValueList = ValueList
