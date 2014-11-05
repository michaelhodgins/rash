###
Represents the root of the CSS AST.
###
class StyleSheet
    constructor: (@rules, @charset = null) ->

    toCSS: ->
        css = @rules.map (rule) ->
            rule.toCSS()
        .join  "\n"
        css = "@charset #{@charset};" + css if @charset
        css

    rash: ->
        #TODO there's a lot of duplicated code here
        #TODO at the moment, we're ignoring media queries
        # loop over each media query, and merge any that have the same selector
        numRules = @rules.length
        position = 0
        while position < numRules
            mediaQuery = @rules[position] # this is the media query we're working on
            if mediaQuery instanceof MediaQuery
                # loop over all the subsequent media queries, looking for ones with the same query
                subsequentPosition = position + 1
                while subsequentPosition < numRules
                    subsequentMediaQuery = @rules[subsequentPosition]
                    if subsequentMediaQuery instanceof MediaQuery and subsequentMediaQuery.query is mediaQuery.query
                        subsequentMediaQuery.merge mediaQuery
                        @rules.splice(position, position+1)
                        numRules-- # we have one less rule
                        break #the current rule has been removed, so break out of the inner loop
                    #move the inner loop onto the next subsequent rule
                    subsequentPosition++
            #move the outer loop onto the next rule
            position++



        # loop over each rule in the stylesheet
        position = 0
        while position < numRules
            rule = @rules[position] #this is the rule we're working on
            if rule instanceof Rule
                # loop over all the rules further down the stylesheet, looks to see this this rule can be merged.
                subsequentPosition = position + 1
                while subsequentPosition < numRules
                    subsequentRule = @rules[subsequentPosition]
                    #see if the rule further down the list has the same selector
                    if subsequentRule instanceof Rule and subsequentRule.selector is rule.selector
                        # the selector matches, so the current rule can be pushed down the stylesheet
                        subsequentRule.merge rule
                        # we need to remove the current rule from the AST
                        @rules.splice(position, position+1)
                        numRules-- # we have one less rule
                        break #the current rule has been removed, so break out of the inner loop
                    #move the inner loop onto the next subsequent rule
                    subsequentPosition++
            #move the outer loop onto the next rule
            position++
        @

###
Represents a media query section.
###
class MediaQuery
    constructor: (@query, @rules) ->

    toCSS: ->
        rules = @rules.map (rule) ->
            rule.toCSS()
        .join "\n"
        "#{@query} {#{rules}}"

    merge: (mediaQuery) ->
        @rules.unshift(rule) for rule in mediaQuery.rules.reverse()
        # loop over each rule in the stylesheet
        numRules = @rules.length
        position = 0
        while position < numRules
            rule = @rules[position] #this is the rule we're working on
            # loop over all the rules further down the stylesheet, looks to see this this rule can be merged.
            subsequentPosition = position + 1
            while subsequentPosition < numRules
                subsequentRule = @rules[subsequentPosition]
                #see if the rule further down the list has the same selector
                if subsequentRule.selector is rule.selector
                    # the selector matches, so the current rule can be pushed down the stylesheet
                    subsequentRule.merge rule
                    # we need to remove the current rule from the AST
                    @rules.splice(position, position+1)
                    numRules-- # we have one less rule
                    break #the current rule has been removed, so break out of the inner loop
                #move the inner loop onto the next subsequent rule
                subsequentPosition++
            #move the outer loop onto the next rule
            position++
        @

###
Represents an import statement.
###
class Import
    constructor: (@imports) ->

    toCSS: ->
        "#{@imports};"

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

    merge: (rule) ->
        for property in rule.properties
            @properties.unshift(property) if not @hasProperty(property)

    ###
    Returns true if the given property already has a value in this rule.
    ###
    hasProperty: (property) ->
        for existingProperty in @properties
            return true if existingProperty.name is property.name
        false

###
Represents a single CSS property, consisting of a style name, and one or more values.
###
class Property
    constructor: (@name, @values, @important = false) ->

    toCSS: ->
        if @values instanceof Array
            values = @values.map (value) ->
                value.toCSS()
            .join ','
        else
            values = @values.toCSS()
        "#{@name}: #{values}#{if @important then ' !important' else ''}"

###
Represents a list of values as parameters to a function.
###
class ParameterList
    constructor: (@values) ->

    toCSS: ->
        @values.map (value) ->
            value.toCSS()
        .join(',')

###
Represents a comma separated list of values.
###
class ValueGroup
    constructor: (@values) ->

    toCSS: ->
        @values.map (value) ->
            value.toCSS()
        .join(' ')


###
Represents a css function with a comma separated list of arguments.
###
class Function
    constructor: (@name, @values) ->

    toCSS: ->
        "#{@name}(#{@values.toCSS()})"

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
exports.Import = Import
exports.Rule = Rule
exports.Property = Property
exports.Function = Function
exports.Literal = Literal
exports.ParameterList = ParameterList
exports.ValueGroup = ValueGroup
