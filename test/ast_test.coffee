assert = require 'assert'
parser = require('../lib/parser').parser
ast = require '../lib/ast'

describe 'Generate an Abstract Syntax Tree', ->
    it 'parses an empty rule', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [])
        ]
        assert.deepEqual parser.parse('p{}'), styleSheet

    it 'parses two empty rules', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', []),
            new ast.Rule('ol', [])
        ]
        assert.deepEqual parser.parse('p{} ol{}'), styleSheet

    it 'parses a rule with a property', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.Literal('12px')
                ])
            ])
        ]
        css = "p{
            font-size: 12px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a property and an empty property', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.Literal('12px')
                ])
            ])
        ]
        css = "p{
            font-size: 12px;
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'ignores comments', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.Literal('12px')
                ])
            ])
        ]
        css = "p{
            font-size: 12px;
            /* this is a multiline comment */
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses properties with lists of name values', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-family', new ast.ValueList([
                    new ast.Literal('Calibri')
                    new ast.Literal('Helvetica')
                    new ast.Literal('Arial')
                    new ast.Literal('sans-serif')
                ]))
            ])
        ]
        css = 'p {
            font-family: Calibri, Helvetica, Arial, sans-serif;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses properties with lists of string and name values', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-family', new ast.ValueList([
                    new ast.Literal('"Helvetica Neue Light"')
                    new ast.Literal('"HelveticaNeue-Light"')
                    new ast.Literal('"Helvetica Neue"')
                    new ast.Literal('Calibri')
                    new ast.Literal('Helvetica')
                    new ast.Literal('Arial')
                    new ast.Literal('sans-serif')
                ]))
            ])
        ]
        css = 'p {
            font-family: "Helvetica Neue Light", "HelveticaNeue-Light", "Helvetica Neue", Calibri, Helvetica, Arial, sans-serif;
        }'
        assert.deepEqual parser.parse(css), styleSheet
