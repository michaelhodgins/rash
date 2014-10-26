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
