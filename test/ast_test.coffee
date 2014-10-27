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

    it 'parses a rule with a nested selector', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p strong', [
                new ast.Property('font-size', [
                    new ast.Literal('12px')
                ])
            ])
        ]
        css = "p strong {
            font-size: 12px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a compound selector', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p.well', [
                new ast.Property('font-size', [
                    new ast.Literal('24px')
                ])
            ])
        ]
        css = "p.well {
            font-size: 24px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a nested compound selector', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p.well strong', [
                new ast.Property('font-size', [
                    new ast.Literal('24px')
                ])
                new ast.Property('font-weight', [
                    new ast.Literal('600')
                ])
            ])
        ]
        css = "p.well strong {
            font-size: 24px;
            font-weight: 600
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a selector with the child combinator', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('#container > .box', [
                new ast.Property('float', [
                    new ast.Literal('left')
                ])
                new ast.Property('padding-bottom', [
                    new ast.Literal('15px')
                ])
            ])
        ]
        css = "#container > .box {
           float: left;
           padding-bottom: 15px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a selector with the sibling combinator', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h2 ~ p', [
                new ast.Property('margin-bottom', [
                    new ast.Literal('20px')
                ])
            ])
        ]
        css = "h2 ~ p {
            margin-bottom: 20px;
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a selector with the adjacent combinator', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p + p', [
                new ast.Property('text-indent', [
                    new ast.Literal('1.5em')
                ])
                new ast.Property('margin-bottom', [
                    new ast.Literal('0')
                ])
            ])
        ]
        css = "p + p {
            text-indent: 1.5em;
            margin-bottom: 0;
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a selector with a pseudoclass', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('a:hover', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = "a:hover {
            color: red;
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a selector with a pseudoelement', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('.container::before', [
                new ast.Property('content', [
                    new ast.Literal('""')
                ])
                new ast.Property('display', [
                    new ast.Literal('block')
                ])
                new ast.Property('background-color', [
                    new ast.Literal('#141414')
                ])
            ])
        ]
        css = '.container::before {
            content: "";
            display: block;
            background-color: #141414
        }'
        assert.deepEqual parser.parse(css), styleSheet


    xit 'parses exact attribute match', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('input[type="text"]', [
                new ast.Property('background-color', [
                    new ast.Literal('#444')
                ])
                new ast.Property('width', [
                    new ast.Literal('200px')
                ])
            ])
        ]
        css = 'input[type="text"] {
            background-color: #444;
            width: 200px;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    xit 'parses attribute contains', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('div[id*="post"]', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = 'div[id*="post"] {
            color: red;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    xit 'parses attribute begins', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel^="external"]', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = 'h1[rel^="external"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    xit 'parses attribute ends', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel$="external"]', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = 'h1[rel$="external"] {
            color: red;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    xit 'parses attribute space delimited list contains', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel~="external"]', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = 'h1[rel~="external"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    xit 'parses attribute hash delimited list contains', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel|="friend"]', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = 'h1[rel|="friend"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    xit 'parses multiple attributes', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel="handsome"][title^="Important"]', [
                new ast.Property('color', [
                    new ast.Literal('red')
                ])
            ])
        ]
        css = 'h1[rel="handsome"][title^="Important"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

