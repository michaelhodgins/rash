assert = require 'assert'
parser = require('../lib/parser').parser
ast = require '../lib/ast'

describe 'Output valid CSS', ->
    it 'compiles one empty rule', ->
        code = "h1 {}"
        assert.equal parser.parse(code).toCSS(), code

    it 'compiles two empty rules', ->
        code = "h1 {}\nol {}"
        assert.equal parser.parse(code).toCSS(), code

    it 'compiles one rule with one property', ->
        code = "p {font-size: 12px}"
        assert.equal parser.parse(code).toCSS(), code

    it 'compiles one rule with one property and one empty property', ->
        code = "p {
            font-size: 12px;
        }\n"
        rashedCode = "p {font-size: 12px}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles one rule with two properties - double quoted string', ->
        code = """p {
            font-size: 12px;
            font-family: "Arial";
        }\n"""
        rashedCode = "p {font-size: 12px;font-family: \"Arial\"}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles one rule with two properties - single quoted string', ->
        code = "p {
            font-size: 12px;
            font-family: 'Arial';
        }\n"
        rashedCode = "p {font-size: 12px;font-family: 'Arial'}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'removes comments', ->
        code = "p {
            font-size: 12px;
            /* this is a multiline comment */
        }\n"
        rashedCode = "p {font-size: 12px}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles properties with lists of values', ->
        code = """p {
            font-family: "Helvetica Neue Light", "HelveticaNeue-Light", "Helvetica Neue", Calibri, Helvetica, Arial, sans-serif;
        }\n"""
        rashedCode = """p {font-family: "Helvetica Neue Light","HelveticaNeue-Light","Helvetica Neue",Calibri,Helvetica,Arial,sans-serif}"""
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles nested selectors', ->
        code = """p strong {
            font-weight: bold
        }\n"""
        rashedCode = "p strong {font-weight: bold}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles compound selectors', ->
        code = """p.well {
            font-size: 12px
        }\n"""
        rashedCode = "p.well {font-size: 12px}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles nested compound selectors', ->
        code = """p.well strong {
            font-weight: 600
        }\n"""
        rashedCode = "p.well strong {font-weight: 600}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles a child combinator', ->
        code = "#container > .box {
           float: left;
           padding-bottom: 15px
        }"
        rashedCode = "#container > .box {float: left;padding-bottom: 15px}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles a sibling combinator', ->
        code = "h2 ~ p {
            margin-bottom: 20px;
        }"
        rashedCode = "h2 ~ p {margin-bottom: 20px}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compilers a adjacent combinator', ->
        code = "p + p {
            text-indent: 1.5em;
            margin-bottom: 0;
        }"
        rashedCode = "p + p {text-indent: 1.5em;margin-bottom: 0}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles a pseudoclass', ->
        code = "a:hover {
            color: red;
        }"
        rashedCode = "a:hover {color: red}"
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles a pseudoelement', ->
        code = '.container::before {
            content: "";
            display: block;
            background-color: #141414
        }'
        rashedCode = '.container::before {content: "";display: block;background-color: #141414}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles exact attribute match', ->
        code = 'input[type="text"] {
            background-color: #444;
            width: 200px;
        }'
        rashedCode = 'input[type="text"] {background-color: #444;width: 200px}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attribute contains', ->
        code = 'div[id*="post"] {
            color: red;
        }'
        rashedCode = 'div[id*="post"] {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attribute begins', ->
        code = 'h1[rel^="external"] {
            color: red;
        }'
        rashedCode = 'h1[rel^="external"] {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attribute ends', ->
        code = 'h1[rel$="external"] {
            color: red;
        }'
        rashedCode = 'h1[rel$="external"] {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attribute space delimited list contains', ->
        code = 'h1[rel~="external"] {
            color: red;
        }'
        rashedCode = 'h1[rel~="external"] {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attribute hash delimited list contains', ->
        code = 'h1[rel|="friend"] {
            color: red;
        }'
        rashedCode = 'h1[rel|="friend"] {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles multiple attributes', ->
        code = 'h1[rel="handsome"][title^="Important"] {
            color: red;
        }'
        rashedCode = 'h1[rel="handsome"][title^="Important"] {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attributes with classes', ->
        code = 'h1[rel|="friend"].well {
            color: red;
        }'
        rashedCode = 'h1[rel|="friend"].well {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles attributes with classes and nested selectors', ->
        code = 'h1[rel|="friend"].well em {
            color: red;
        }'
        rashedCode = 'h1[rel|="friend"].well em {color: red}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles media queries', ->
        code = '@media screen and (min-width: 400px) and (max-width: 700px) {
                h1 {
                    font-size: 12px;
                }
            }'
        rashedCode = '@media screen and (min-width: 400px) and (max-width: 700px) {h1 {font-size: 12px}}'
        assert.equal parser.parse(code).toCSS(), rashedCode

    it 'compiles two rationalized selectors', ->
        code = 'p {
            font-size: 12px
        }
        p {
            color: #030303
        }'
        rashedCode = 'p {font-size: 12px;color: #030303}'
        assert.equal parser.parse(code).rash().toCSS(), rashedCode

    it 'compiles two rationalized selectors with a duplicated property', ->
        code = 'p {
            font-size: 12px;
            color: #666
        }
        p {
            color: #030303
        }'
        rashedCode = 'p {font-size: 12px;color: #030303}'
        assert.equal parser.parse(code).rash().toCSS(), rashedCode

    it 'compiles two rationalized media queries', ->
        code = '@media screen and (min-width: 400px) and (max-width: 700px) {
            h1 {
                font-size: 12px;
            }
        }
        @media screen and (min-width: 400px) and (max-width: 700px) {
            a {
                color: white
            }
        }'
        rashedCode = "@media screen and (min-width: 400px) and (max-width: 700px) {h1 {font-size: 12px}\na {color: white}}"
        assert.equal parser.parse(code).rash().toCSS(), rashedCode

    it 'compiles two rationalized media queries and rules', ->
        code = '@media screen and (min-width: 400px) and (max-width: 700px) {
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
        rashedCode = "@media screen and (min-width: 400px) and (max-width: 700px) {h1 {font-size: 11px}\na {color: white}}"
        assert.equal parser.parse(code).rash().toCSS(), rashedCode

