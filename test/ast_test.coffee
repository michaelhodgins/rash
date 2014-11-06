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
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
                ])
            ])
        ]
        css = "p{
            font-size: 12px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with an important property', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
                ], true)
            ])
        ]
        css = "p{
            font-size: 12px !important
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a property and an empty property', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
                ])
            ])
        ]
        css = "p{
            font-size: 12px;
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a property with a function value', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('html', [
                new ast.Property('-webkit-tap-highlight-color', [
                    new ast.ValueGroup([
                        new ast.Function('rgba', new ast.ParameterList([
                            new ast.Literal('0')
                            new ast.Literal('0')
                            new ast.Literal('0')
                            new ast.Literal('0')
                        ]))
                    ])
                ])
            ])
        ]
        css = 'html {
            -webkit-tap-highlight-color: rgba(0, 0, 0, 0)
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a property with a function value containing a named parameter', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('.btn.disabled', [
                new ast.Property('filter', [
                    new ast.ValueGroup([
                        new ast.Function('alpha', new ast.ParameterList([
                            new ast.Literal('opacity=65')
                        ]))
                    ])
                ])
            ])
        ]
        css = '.btn.disabled {
            filter: alpha(opacity=65)
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'ignores comments', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
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
                new ast.Property('font-family', [
                    new ast.ValueGroup([
                        new ast.Literal('Calibri')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('Helvetica')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('Arial')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('sans-serif')
                    ])
                ])
            ])
        ]
        css = 'p {
            font-family: Calibri, Helvetica, Arial, sans-serif;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses properties with lists of string and name values', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-family', [
                    new ast.ValueGroup([
                        new ast.Literal('"Helvetica Neue Light"')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('"HelveticaNeue-Light"')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('"Helvetica Neue"')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('Calibri')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('Helvetica')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('Arial')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('sans-serif')
                    ])
                ])
            ])
        ]
        css = 'p {
            font-family: "Helvetica Neue Light", "HelveticaNeue-Light", "Helvetica Neue", Calibri, Helvetica, Arial, sans-serif;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses properties with lists of related values', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('.form-control', [
                new ast.Property('-webkit-transition', [
                    new ast.ValueGroup([
                        new ast.Literal('border-color')
                        new ast.Literal('ease-in-out')
                        new ast.Literal('.15s')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('box-shadow')
                        new ast.Literal('ease-in-out')
                        new ast.Literal('.15s')
                    ])
                ])

                new ast.Property('transition', [
                    new ast.ValueGroup([
                        new ast.Literal('border-color')
                        new ast.Literal('ease-in-out')
                        new ast.Literal('.15s')
                    ])
                    new ast.ValueGroup([
                        new ast.Literal('box-shadow')
                        new ast.Literal('ease-in-out')
                        new ast.Literal('.15s')
                    ])
                ])
            ])
        ]
        css = ".form-control {
            -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a nested selector', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p strong', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
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
                    new ast.ValueGroup([
                        new ast.Literal('24px')
                    ])
                ])
            ])
        ]
        css = "p.well {
            font-size: 24px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a multiple compound selectors', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p.well.standout', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('36px')
                    ])
                ])
            ])
        ]
        css = "p.well.standout {
            font-size: 36px
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a nested compound selector', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p.well strong', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('24px')
                    ])
                ])
                new ast.Property('font-weight', [
                    new ast.ValueGroup([
                        new ast.Literal('600')
                    ])
                ])
            ])
        ]
        css = "p.well strong {
            font-size: 24px;
            font-weight: 600
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a rule with a list of selectors', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('#block-search-form .form-submit, .page-search .search-form input.form-submit, .page-taxonomy-term .search-form input.form-submit', [
                new ast.Property('background-color', [
                    new ast.ValueGroup([
                        new ast.Literal('#060608')
                    ])
                ])
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('#eae827')
                    ])
                ])
                new ast.Property('border', [
                    new ast.ValueGroup([
                        new ast.Literal('none')
                    ])
                ])
            ])
        ]
        css = '#block-search-form .form-submit, .page-search .search-form input.form-submit, .page-taxonomy-term .search-form input.form-submit {
            background-color: #060608;
            color: #eae827;
            border: none
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses a selector with the child combinator', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('#container > .box', [
                new ast.Property('float', [
                    new ast.ValueGroup([
                        new ast.Literal('left')
                    ])
                ])
                new ast.Property('padding-bottom', [
                    new ast.ValueGroup([
                        new ast.Literal('15px')
                    ])
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
                    new ast.ValueGroup([
                        new ast.Literal('20px')
                    ])
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
                    new ast.ValueGroup([
                        new ast.Literal('1.5em')
                    ])
                ])
                new ast.Property('margin-bottom', [
                    new ast.ValueGroup([
                        new ast.Literal('0')
                    ])
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
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
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
                    new ast.ValueGroup([
                        new ast.Literal('""')
                    ])
                ])
                new ast.Property('display', [
                    new ast.ValueGroup([
                        new ast.Literal('block')
                    ])
                ])
                new ast.Property('background-color', [
                    new ast.ValueGroup([
                        new ast.Literal('#141414')
                    ])
                ])
            ])
        ]
        css = '.container::before {
            content: "";
            display: block;
            background-color: #141414
        }'
        assert.deepEqual parser.parse(css), styleSheet


    it 'parses exact attribute match', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('input[type="text"]', [
                new ast.Property('background-color', [
                    new ast.ValueGroup([
                        new ast.Literal('#444')
                    ])
                ])
                new ast.Property('width', [
                    new ast.ValueGroup([
                        new ast.Literal('200px')
                    ])
                ])
            ])
        ]
        css = 'input[type="text"] {
            background-color: #444;
            width: 200px;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attribute contains', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('div[id*="post"]', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'div[id*="post"] {
            color: red;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attribute begins', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel^="external"]', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel^="external"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attribute ends', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel$="external"]', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel$="external"] {
            color: red;
        }'
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attribute space delimited list contains', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel~="external"]', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel~="external"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attribute hash delimited list contains', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel|="friend"]', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel|="friend"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses multiple attributes', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel="handsome"][title^="Important"]', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel="handsome"][title^="Important"] {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attributes with classes', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel|="friend"].well', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel|="friend"].well {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses attributes with classes and nested selectors', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1[rel|="friend"].well em', [
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('red')
                    ])
                ])
            ])
        ]
        css = 'h1[rel|="friend"].well em {
            color: red;
        }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses media queries', ->
        styleSheet = new ast.StyleSheet [
            new ast.MediaQuery('@media screen and (min-width: 400px) and (max-width: 700px)', [
                new ast.Rule('h1', [
                    new ast.Property('font-size', [
                        new ast.ValueGroup([
                            new ast.Literal('12px')
                        ])
                    ])
                ])
            ])
        ]
        css = '@media screen and (min-width: 400px) and (max-width: 700px) {
                h1 {
                    font-size: 12px;
                }
            }'

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses @charset', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('h1', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
                ])
            ])
        ], '"UTF-8"'
        css = "@charset \"UTF-8\";\n
        h1 {
            font-size: 12px;
        }\n"

        assert.deepEqual parser.parse(css), styleSheet

    it 'parses @import', ->
        styleSheet = new ast.StyleSheet [
            new ast.Import "@import 'custom.css'"
            new ast.Import "@import url('landscape.css') screen and (orientation:landscape)"
        ]

        css ="@import 'custom.css';\n
            @import url('landscape.css') screen and (orientation:landscape);\n
        "
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses @namespace', ->
        styleSheet = new ast.StyleSheet [
            new ast.Namespace "@namespace url(http://www.w3.org/1999/xhtml)"
            new ast.Namespace "@namespace svg url(http://www.w3.org/2000/svg)"
            new ast.Rule('svg|a', [])
            new ast.Rule('*|a', [])
        ]

        css ="@namespace url(http://www.w3.org/1999/xhtml);
            @namespace svg url(http://www.w3.org/2000/svg);\n
            svg|a {}\n
            *|a {}\n
        "
        assert.deepEqual parser.parse(css), styleSheet

    it 'parses @page', ->
        styleSheet = new ast.StyleSheet [
            new ast.Page "@page :first", [
                new ast.Property('margin', [
                    new ast.ValueGroup([
                        new ast.Literal('20px')
                    ])
                ])
            ]
        ]

        css ="@page :first {\n
            margin: 20px\n
        }"
        assert.deepEqual parser.parse(css), styleSheet

    it 'rationalizes two selectors', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
                ])
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('#030303')
                    ])
                ])
            ])
        ]
        css = "p {
            font-size: 12px
        }
        p {
            color: #030303
        }"
        assert.deepEqual parser.parse(css).rash(), styleSheet

    it 'rationalizes two selectors with redundant property', ->
        styleSheet = new ast.StyleSheet [
            new ast.Rule('p', [
                new ast.Property('font-size', [
                    new ast.ValueGroup([
                        new ast.Literal('12px')
                    ])
                ])
                new ast.Property('color', [
                    new ast.ValueGroup([
                        new ast.Literal('#030303')
                    ])
                ])
            ])
        ]
        css = "p {
            font-size: 12px;
            color: #666
        }
        p {
            color: #030303
        }"
        assert.deepEqual parser.parse(css).rash(), styleSheet

    it 'rationalizes two media queries', ->
        styleSheet = new ast.StyleSheet [
            new ast.MediaQuery('@media screen and (min-width: 400px) and (max-width: 700px)', [
                new ast.Rule('h1', [
                    new ast.Property('font-size', [
                        new ast.ValueGroup([
                            new ast.Literal('12px')
                        ])
                    ])
                ])
                new ast.Rule('a', [
                    new ast.Property('color', [
                        new ast.ValueGroup([
                            new ast.Literal('white')
                        ])
                    ])
                ])
            ])
        ]
        css = '@media screen and (min-width: 400px) and (max-width: 700px) {
            h1 {
                font-size: 12px;
            }
        }
        @media screen and (min-width: 400px) and (max-width: 700px) {
            a {
                color: white
            }
        }'
        assert.deepEqual parser.parse(css).rash(), styleSheet

    it 'rationalizes two media queries and rules', ->
        styleSheet = new ast.StyleSheet [
            new ast.MediaQuery('@media screen and (min-width: 400px) and (max-width: 700px)', [
                new ast.Rule('h1', [
                    new ast.Property('font-size', [
                        new ast.ValueGroup([
                            new ast.Literal('11px')
                        ])
                    ])
                ])
                new ast.Rule('a', [
                    new ast.Property('color', [
                        new ast.ValueGroup([
                            new ast.Literal('white')
                        ])
                    ])
                ])
            ])
        ]
        css = '@media screen and (min-width: 400px) and (max-width: 700px) {
            h1 {
                font-size: 12px;
            }
        }
        @media screen and (min-width: 400px) and (max-width: 700px) {
            h1 {
                font-size: 11px;
            }
            a {
                color: white
            }
        }'
        assert.deepEqual parser.parse(css).rash(), styleSheet
