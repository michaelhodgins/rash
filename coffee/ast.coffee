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

class MediaQuery
    constructor: (@query, @rules) ->

    toCSS: ->

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
        if @values instanceof Array
            values = @values.map (value) ->
                value.toCSS()
            .join " "
            "#{@name}: #{values}"
        else
            values = @values.toCSS()

        "#{@name}: #{values}"
###
Represents a comma separated list of values.
###
class ValueList
    constructor: (@values) ->

    toCSS: ->
        @values.map (value) ->
            value.toCSS()
        .join(',')

###
Represents a literal value.
###
class Literal
    constructor: (@value) ->

    toCSS : ->
        @value

# export the classes
exports.StyleSheet = StyleSheet
exports.MediaQuery = MediaQuery
exports.Rule = Rule
exports.Property = Property
exports.Literal = Literal
exports.ValueList = ValueList
