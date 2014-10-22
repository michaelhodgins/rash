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
