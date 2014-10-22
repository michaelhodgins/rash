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

###
class Rule
    constructor: (@selector, @properties) ->

    toCSS: ->
        properties = @properties.map (property) ->
            property.toCSS()
        .join ";"
        "#{@selector} {#{properties}}"

###

###
class Property
    constructor: (@name, @values) ->

    toCSS: ->
        values = @values.map (value) ->
            value.toCSS()
        .join " "
        "#{@name}: #{values}"

###

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
