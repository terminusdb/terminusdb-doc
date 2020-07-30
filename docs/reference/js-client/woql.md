---
title: WOQL.js - the Definitive Guide
layout: default
parent: JS Client
grand_parent: Reference
nav_order: 1
---
## Table of contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

- - -

## Fluent Style

The TerminusDB query libraries make extensive use of the fluent style to simplify the expression of complex compound queries. Many WOQL query words accept a sub-query as an argument and, rather than using a functional (Lisp-like) style of capturing containment, a style where sub-queries are appended to the initial function as a new function is preferred. 

rather than using a functional style: 
    select(a, b, triple(c, d, e))
the fluent style would be:
    select(a, b).triple(c, d, e)

Both styles are legal WOQL and semantically equivalent, however the second 'fluent' style is preferred because it is easier to read and easier to write primarily becaue it greatly reduces the amount of vizual parameter matching that the reader and writer has to perform in order to verify that their query is correct. 

Fluent queries are parsed left to right - functions to the right of a given function are considered as sub-queries of the first, with one important exception - conjunction. 

the functional style of expresing conjunction using the WOQL and() function is straightforward and is often most useful for clarity: 
    
    and(triple(a, b, c), triple(d, e, f))

the fluent style allows us to use any of the following forumlations with the same semantics: 
    
    and(triple(a, b, c)).triple(d, e, f)
    triple(a, b, c).and().triple(d, e, f)
    triple(a, b, c).triple(d, e, f)
    
The third concise form is unambiguous in situations where the WOQL functions that are chained together do not take sub-clauses - and because conjunction is so frequently used, this short-hand form, where the and() is implicit, is convenient in many situations. However it should be used with care - the conjunction is always applied to the function immediately to the left of the '.' in the chain and not to any functions further up the chain.  If used improperly, with clauses that do take sub-clauses, it will produce improperly specified queries, in particular with negation (not) and optional functions (opt). 

So, for example, the following query:

    triple(a, b, c).opt().triple(d, e, f).triple(g, h, i) 

is equivalent to the following query in the functional style:

    and(
        triple(a, b, c), 
        opt( 
            and(
                triple(d, e, f), 
                triple(g, h, i)
            )
        )
    ) 

It is easy to misinterpret it when you mean to express:

    and(
        triple(a, b, c), 
        opt().triple(d, e, f), 
        triple(g, h, i)
    ) 

As a general rule, if in doubt, use the functional style explicitly with and() as this makes it clear and explicit which functions are sub-clauses of other functions 

## WOQL.js and JSON-LD

WOQL uses JSON-LD and a formally specified ontology to define the language and to transmit queries over the wire.  WOQL.js is designed primarily to be as easy as possible for programmers to write because JSON-LD is itself tedious for humans to read and write. All WOQL.js queries are translated into the equivalent JSON-LD format for transmission over the wire.  The WOQL.js json() function can be used to translate any WOQL query from its JSON-LD format to and from it's WOQL.js equivalent (a WOQLQuery() object). If passed a JSON-LD argument, it will generate the equivalent WOQLQuery() object, if passed no argument, it will return the JSON-LD equivalent of the WOQLQuery(), in general the following semantic identity should always hold:

let wjs = new WOQLQuery().json(json_ld)
json_ld == wjs.json()

### Embedding JSON-LD directly in WOQL.js

It is possible to use JSON-LD interchangably within WOQL.js - wherever a WOQL function or argument can be accepted directly in WOQL.js, the JSON-LD equivalent can alo be supplied. So, for example, the following two WOQL statements are identical: 

triple(a, b, 1) == triple(a, b, {"@type": "xsd:integer", "@value": 1})

There should never be a situation in which it is necessary to use JSON-LD directly - WOQL.js is sufficiently rich to express all queries that are expressible in the underlying JSON-LD, however it can be convenient to embed JSON-LD in queries in some cases. 

## WOQL Variables

With the exception of resource identifiers which are used to specify the graphs against which operations such as queries are carried out (functions: using, with, into, from), WOQL allows variables to be subtituted for any of the arguments to all WOQL functions. WOQL variables follow the logic of unification - borrowed from the Prolog engine which implements WOQL within TerminusDB.  That is to say that each valid value for a variable, as constrained by the totality of the query, will produce a new row in the results and when there are multiple variables, the rows that are returned will be the cartesian product of all the possible combinations of variables values in the query. 

In WOQL.js, there are 3 distinct wasy of expressing variables within queries, all are semantically equivalent, although the first is generally preferred as it is easier to type and it is easier to distinguish variables from constants at a glance due to the lack of quote marks around the variables

1   let [a, b, c] = vars('a', 'b', 'c')
    triple(a, b, c)

2   triple('v:a', 'v:b', 'v:c')

3   triple({'@type': 'woql:Variable', 'woql:variable_name': {"@type": 'xsd:string', '@value': 'a'}} ....)

## Prefixes in WOQL.js

* all identifiers and properties are represented by IRIs
* can use prefixed form as shorthand to address them where a standard prefix is defined
* default prefixes are applied 
    - "doc" applies to positions where instance data IRIs are required
    - "scm" applies to positions where schema elements are required
    - otherwise if no prefix is applied a string is assumed

## WOQL Primitives

WOQL primitives are WOQL.js functions which directly map onto words in the underlying JSON-LD language. All other WOQL.js functions are compound functions which translate into multiple WOQL primitives, or are helper functions which reduce the need to write verbose JSON-LD directly. 

### Basics


#### triple 

triple(Subject, Predicate, Object)

Status: Stable

Description: Generates a triple pattern matching rule to match any triples that meet the constraints

Arguments: 
    Subject (string*) - The IRI of a triple's subject or a variable 
    Predicate (string*) - The IRI of a property or a variable 
    Object (string*) - The IRI of a node or a variable, or a literal 

Returns: 
    A WOQLQuery object containing the triple pattern matching rule

Example: 
    let [subj, obj] = vars("subj", "obj")
    triple(s, "type", o)

#### quad     

quad(Subject, Predicate, Object, Graph)

Status: Stable

Description: Generates a quad pattern matching rule to match any triples that meet the constraints in the specified Graph

Arguments: 
    Subject (string*) - The IRI of a triple's subject or a variable 
    Predicate (string*) - The IRI of a property or a variable 
    Object (string*) - The IRI of a node or a variable, or a literal 
    Graph (string*) - The Resource String identifying the graph to be searched for the pattern 

Returns: 
    A WOQLQuery object containing the quad pattern matching rule

Example: 
    let [class, prop] = vars("class", "prop")
    quad(class, "domain", prop, "schema/main")

#### comment     

comment(Comment, Subq)

Status: Stable

Description: Inserts a textual comment into a query and optionally 'comments' out the contained subquery

Arguments: 
    Comment (string*) - The textual comment
    Subq (WOQLQuery) - An optional enclosed sub-query that is commented out 

Returns: 
    A WOQLQuery object containing the comment

Example: 
    comment("This has a bug").triple(a, b, c)

#### select     

select(...Vars, Subq)

Status: Stable

Description: Selects (filters) a list of variables from the enclosed sub-query and removes the rest

Arguments: 
    ...Vars (string*) - A list of one or more variables to select
    Subq (WOQLQuery*) - A query from which the variables will be filtered out 

Returns: 
    A WOQLQuery object containing the filtered variables and subquery

Example: 
    let [grouped, subject, class] = vars("grouped", "subject", "class")
    select(grouped).group_by(subject, class, grouped).triple(subject, "type", class)

#### and

select(...Subqueries)

Status: Stable

Description: Logical conjunction of the contained queries - all queries must match or the entire clause fails 

Arguments: 
    ...Subqueries (WOQLQuery*) - A list of one or more woql queries to execute as a conjunction

Returns: 
    A WOQLQuery object containing the conjunction of queries

Example: 
    let [subject, class, label] = vars("subject", "class", "label")
    and(
        triple(subject, 'type', class), 
        triple(subject, "label", label)
    )

#### or

or(...Subqueries)

Status: Stable

Description: Logical Or of the contained queries - the first subquery to match will cause subsequent subqueries to not be evaluated 

Arguments: 
    ...Subqueries (WOQLQuery*) - A list of one or more woql queries to execute as alternatives

Returns: 
    A WOQLQuery object containing the logical Or of the subqueries

Example: 
    let [subject] = vars("subject")
    or(
        triple(subject, 'label', "A"), 
        triple(subject, "label", "a")
    )

#### opt

opt(Subquery) ~ optional(Subquery) (alias)

Status: Stable

Description: Specifies that the Subquery is optional - if it does not match the query will not fail 

Arguments: 
    Subquery (WOQLQuery*) - A subquery which will be optionally matched 

Returns: 
    A WOQLQuery object containing the optional sub Query

Example: 
    let [subject] = vars("subject")
    opt().triple(subject, 'label', "A") 

#### not

not(Subquery) 

Status: Stable

Description: Logical negation of the contained subquery - if the subquery matches, the query will fail to match

Arguments: 
    Subquery (WOQLQuery*) - A subquery which will be negated 

Returns: 
    A WOQLQuery object containing the negated sub Query

Example: 
    let [subject, label] = vars("subject", "label")
    not().triple(subject, 'label', label) 

#### isa

isa(IRI, Class) 

Status: Stable

Description: Tests whether a given instance IRI has type Class

Arguments: 
    Instance_IRI (string*) - A string IRI or a variable 
    Class (string*) - A Class IRI or a variable 

Returns: 
    A WOQLQuery object containing the type test

Example: 
    let [subject] = vars("subject")
    isa(subject, "Person") 

#### sub

sub(ClassA, ClassB) ~ subsumption(ClassA, ClassB) (Alias)

Status: Stable

Description: Tests whether a given Class subsumes another class

Arguments: 
    ClassA (string*) - A Class IRI or a variable representing the subsuming (parent) class
    Class (string*) - A Class IRI or a variable representing the subsumed (child) class 

Returns: 
    A WOQLQuery object containing the subsumption test

Example: 
    let [class] = vars("class")
    sub("Vegetable", class) 

#### unique

unique(Prefix, Vars, NewIRI)

Status: Stable

Description: Generate a new IRI from the prefix and a hash of the variables which will be unique for any given combination of variables

Arguments: 
    Prefix (string*) - A prefix for the IRI - typically formed of the doc prefix and the classtype of the entity ("doc:Person")
    Vars ([string*]) - An array of variables and / or strings from which the unique hash will be generated
    NewIRI (string*) - Variable in which the unique ID is stored

Returns: 
    A WOQLQuery object containing the unique ID generating function

Example: 
    let [newid] = vars("newid")
    unique("doc:Person", ["John", "Smith"], newid) 

#### idgen

idgen(Prefix, Vars, NewIRI) ~ idgenerator(Prefix, Vars, NewIRI) (Alias) 

Status: Stable

Description: Generate a new IRI from the prefix and concatention of the variables 

Arguments: 
    Prefix (string*) - A prefix for the IRI - typically formed of the doc prefix and the classtype of the entity ("doc:Person")
    Vars ([string*]) - An array of variables and / or strings from which the id will be generated
    NewIRI (string*) - Variable in which the new ID is stored

Returns: 
    A WOQLQuery object containing the ID generating function

Example: 
    let [newid] = vars("newid")
    idgen("doc:Person", ["John", "Smith"], newid) 

#### true

true() 

Status: Stable

Description: a function that always matches, always returns true 

Arguments: None

Returns: 
    A WOQLQuery object containing the true value that will match any pattern

Example: 
    when(true()).triple("a", "b", "c") 

#### eq

eq(A, B) ~ equal(A, B) (Alias) 

Status: Stable

Description: Tests whether the two arguments are equal 

Arguments: 
    A (literal*) - A variable or IRI or any literal (e.g. number, string)
    B (literal*) - An array of variables and / or strings from which the id will be generated

Returns: 
    A WOQLQuery object containing the ID generating function

Example: 
    let [newid] = vars("newid")
    idgen("doc:Person", ["John", "Smith"], newid) 

#### start 

start(Start, Subq)  

Status: Stable

Description: Specifies an offset position in the results to start listing results from 

Arguments: 
    Start (integer*) - A variable that refers to an interger or an integer literal (e.g. number, string)
    Subq (WOQLQuery*) - An array of variables and / or strings from which the id will be generated

Returns: 
    A WOQLQuery whose results will be returned starting from the specified offset

Example: 
    let [a, b, c] = vars("a", "b", "c")
    start(100).triple(a, b, c) 

#### limit 

limit(Limit, Subq)  

Status: Stable

Description: Specifies a maximum number of results that will be returned from the subquery 

Arguments: 
    Limit (integer/string*) - A variable that refers to an non-negative integer or a non-negative integer 
    Subq (WOQLQuery*) - A subquery whose results will be limited

Returns: 
    A WOQLQuery whose results will be returned starting from the specified offset

Example: 
    let [a, b, c] = vars("a", "b", "c")
    limit(100).triple(a, b, c) 

#### path 

limit(Subject, Pattern, Object, Path)  

Status: Stable

Description: Performs a path regular expression match on the graph  

Arguments: 
    Subject (string*) - An IRI or variable that refers to an IRI representing the subject, i.e. the starting point of the path
    Pattern (string*) - A path regular expression describing a pattern through multiple edges of the graph
        Path regular expressions consist of a sequence of predicates and / or a set of alternatives, with quantification operators 
        The characters that are interpreted specially are the following: 
            | - representing alternative choices
            , - representing a sequence of predcitates
            + - Representing a quantification of 1 or more of the preceding pattern in a sequence
            {min, max} - Representing at least min examples and at most max examples of the preceding pattern
            * - Representing any predicate 
            () - Parentheses, interpreted in the normal way to group clauses
    Object (string*) - An IRI or variable that refers to an IRI representing the object, i.e. ending point of the path
    Path (string*) - A variable in which the actual paths traversed will be stored 

Returns: 
    A WOQLQuery which contains the path regular expression matching expression

Example: 
    let [person, grand_uncle, lineage] = vars("person", "grand uncle", "lineage")
    path(person, "((father|mother){2,2}),brother), grand_uncle, lineage)  

#### order_by 

order_by(...Ordervars, Subq)

Status: Stable

Description: Orders the results of the contained subquery by a precedence list of variables

Arguments: 
    Ordervars (string*) - A sequence of variables, by which to order the results, each optionally followed by either "asc" or "desc" to represent order 
    Subq (WOQLQuery*) - The query whose results will be ordered 

Returns: 
    A WOQLQuery which contains the ordering expression

Example: 
    let [person, last_name, first_name] = vars("person", "last name", "first name")
    order_by(last_name, "asc", first_name, "desc").triple(person, "first_name", first_name).triple(person, "last_name", last_name)

#### group_by 

order_by(GroupVars, PatternVars, GroupedVar, Subq)

Status: Stable

Description: Groups the results of the contained subquery on the basis of identical values for Groupvars, extracts the patterns defined in PatternVars and stores the results in GroupedVar

Arguments: 
    GroupVars ([string] or string*) - Either a single variable or an array of variables
    PatternVars ([string] or string*) Either a single variable or an array of variables 
    GroupedVar (string*) A variable
    Subq (WOQLQuery*) - The query whose results will be ordered 

Returns: 
    A WOQLQuery which contains the grouping expression

Example: 
    let [age, last_name, first_name, age_group, person] = vars("age", "last name", "first name", "age group", "person")
    group_by(age, [last_name, first_name], age_group).triple(person, "first_name", first_name).triple(person, "last_name", last_name).triple(person, "age", age)


#### cast 

cast(Input, Type, CastVar) ~ typecast(InputVar, Type, CastVar) (Alias)

Status: Stable

Description: Casts the value of Input to a new value of type Type and stores the result in CastVar

Arguments: 
    Input ([string] or literal*) - Either a single variable or a literal of any basic type
    Type ([string] or string*) Either a variable or a basic datatype (xsd / xdd) 
    CastVar (string*) A variable

Returns: 
    A WOQLQuery which contains the casting expression

Example: 
    let [time] = vars("time")
    cast("22/3/98", "xsd:dateTime", time)

### List Processing

#### member 

member(Element, List) 

Status: Stable

Description: Matches if List includes Element 

Arguments: 
    Element (string or literal*) - Either a variable, IRI or any simple datatype
    List ([string, literal] or string*) Either a variable representing a list or a list of variables or literals 

Returns: 
    A WOQLQuery which contains the List inclusion pattern matching expression

Example: 
    let [name] = vars("name")
    member(name, ["john", "joe", "frank"])

#### length 

length(List, Len) 

Status: Stable

Description: Matches or generates the length of a list  

Arguments: 
    List ([string, literal] or string*) Either a variable representing a list or a list of variables or literals 
    Len (string or integer) A variable in which the length of the list is stored or the length of the list as a non-negative integer

Returns: 
    A WOQLQuery which contains the Length pattern matching expression

Example: 
    let [count] = vars("count")
    length(["john", "joe", "frank"], count)


### String Processing

#### concat 

concat(List, Concatenated) 

Status: Stable

Description:  Concatenates the List into a string and matches / stores the result in Concatenated   

Arguments: 
    List ([string] string*) - a variable representing a list or a list of variables or strings - variables can be embedded in the string if they do not contain spaces 

Returns: 
    A WOQLQuery which contains the Concatenation pattern matching expression

Example: 
    let [first_name, last_name, full_name] = vars("first", "last", "full")
    concat([first_name, " ", last_name], full_name)

#### trim 

trim(Untrimmed, Trimmed) 

Status: Stable

Description: A trimmed version of Untrimmed (with leading and trailing whitespace removed) is stored in Trimmed   

Arguments: 
    Untrimmed (string*) - A string or variable containing the untrimmed version of the string
    Trimmed (string*) - A string or variable containing the trimmed version of the string
Returns: 
    A WOQLQuery which contains the Trim pattern matching expression

Example: 
    let [trimmed] = ['trimmed']
    trim("hello   ", trimmed)

#### substr 

substr(String, Before, Length, After, SubString) ~ substring(String, Before, Length, After, SubString) (Alias)

Status: Stable

Description: Generates a Substring From String, starting from Begin offset, of length Length, with After Number of characters after the substring

Arguments: 
    String (string*) - String or variable representing the full string 
    Before (string or integer*) Integer or variable representing the number of characters from the start to start the substring from
    Length (string or integer*) Integer or variable representing the number of characters in the substring
    After (string or integer*) Integer or variable representing the number of characters from the end to end the substring from 
    SubString (string*) - The substring matched according to the values specified in the other arguments

Returns: 
    A WOQLQuery which contains the Substring pattern matching expression

Example: 

#### upper 

upper(String, Capitalized) 

Status: Stable

Description: Generates or matches an upper-case version of String in Capitalized

Arguments: 
    String (string*) - string or variable representing the uncapitalized string
    Capitalized (string*) - string or variable representing the capitalized string

Returns: 
    A WOQLQuery which contains the Upper case pattern matching expression

Example: 
    let [allcaps] = var("caps")
    upper("aBCe", allcaps)

#### lower 

lower(String, LowerCased) 

Status: Stable

Description: Generates or matches a lower-case version of String in LowerCased

Arguments: 
    String (string*) - string or variable representing the non-lowercased string
    LowerCased (string*) - string or variable representing the lowercased string

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 
    let [lower] = var("l")
    lower("aBCe", lower)

#### pad 

pad(Input, Pad, Len, Output) 

Status: Stable

Description: Pads out the string Input to be exactly Len long by appending the Pad character the necessary number of times to form Output

Arguments: 
    Input (string*) - The input string or variable in unpadded state
    Pad (string*) - The characters to use to pad the string or a variable representing them
    Len (string or integer*) - The variable or integer value representing the length of the output string
    Output (string*) - The variable or string representing the padded version of the input string
Returns: 
    A WOQLQuery which contains the Pad pattern matching expression

Example: 
    let [fixed] = vars("fixed length")
    pad("joe", " ", 8, fixed) 
    //fixed contains "joe     "

#### split 

split(Input, Separator, Output) 

Status: Stable

Description: Splits a string (Input) into a list strings (Output) by removing separator  

Arguments: 
    Input (string*) - A string or variable representing the unsplit string
    Separator (string*) - A string or variable containing a sequence of charatcters to use as a separator
    Output (string, [string]) - A variable representing a list, or a list of variables and / or strings

Returns: 
    A WOQLQuery which contains the Split pattern matching expression

Example: 
    let [words] = vars("words")
    split("joe has a hat", " ", words) 
    //words contains ["joe", "has", "a", "hat"]

#### join 

join(Input, Glue, Output) 

Status: Stable

Description: Joins a list variable together (Input) into a string variable (Output) by glueing the strings together with Glue

Arguments: 
    Input (string / [string]*) - a variable representing a list or a list of strings and / or variables
    Glue (string*) - A variable or string representing the characters to put in between the joined strings in input
    Output (string*) - A variable or string containing the output string

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 
    let [sentence] = vars("sentence")
    join(["joe", "has", "a", "hat", " ", sentence) 
    //sentence contains ["joe has a hat"]

#### re 

re(Pattern, Test, Matches) ~ regexp(Pattern, Test, Matches) (Alias)

Status: Stable

Description: Matches the regular expression defined in Patern against the Test string, to produce the matched patterns in Matches 

Arguments: 
    Pattern (string*) - string or variable using normal PCRE regular expression syntax with the exception that special characters have to be escaped twice (to enable transport in JSONLD) 
    Test (string*) - string or variable containing the string to be tested for patterns with the regex 
    Matches (string / [string]) - variable representing the list of matches or a list of strings or variables

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 
    let [e, llo] = vars('e', 'ello')
    WOQL.re("h(.).*", "hello", [e, llo])
    //e contains 'e', llo contains 'llo'

#### like 

like(StringA, StringB, Distance) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Matches if a is similar to b (with distance dist)
 * @param {string} a - string a
 * @param {string} b - string b
 * @param {float} dist - distance 0-1.0
 * @return {boolean} WOQLQuery
 */
WOQL.like = function(a, b, dist) {
    return new WOQLQuery().like(a, b, dist)
}


## Updates / Transactions

#### add_triple 

add_triple(Subject, Predicate, Object) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Adds triples according to the the pattern [S,P,O]
 * @param {string} S - Subject
 * @param {string} P - Predicate
 * @param {string} O - Object
 * @return {object} WOQLQuery
 */
WOQL.add_triple = function(S, P, O) {
    return new WOQLQuery().add_triple(S, P, O)
}

#### add_quad 

add_quad(Subject, Predicate, Object, Graph) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Adds quads according to the pattern [S,P,O,G]
 * @param {string} S - Subject
 * @param {string} P - Predicate
 * @param {string} O - Object
 * @param {string} G - Graph
 * @return {object} WOQLQuery
 */
WOQL.add_quad = function(S, P, O, G) {
    return new WOQLQuery().add_quad(S, P, O, G)
}

#### delete_triple 

add_quad(Subject, Predicate, Object, Graph) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 



/**
 * Deletes any triples that match the rule [S,P,O]
 * @param {string} S - Subject
 * @param {string} P - Predicate
 * @param {string} O - Object
 * @return {object} WOQLQuery
 */
WOQL.delete_triple = function(S, P, O) {
    return new WOQLQuery().delete_triple(S, P, O)
}


#### delete_quad 

delete_quad(Subject, Predicate, Object, Graph) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Deletes any quads that match the rule [S, P, O, G] (Subject, Predicate, Object, Graph)
 * @param {string} S - Subject
 * @param {string} P - Predicate
 * @param {string} O - Object
 * @param {string} G - Graph
 * @return {object} WOQLQuery
 */
WOQL.delete_quad = function(S, P, O, G) {
    return new WOQLQuery().delete_quad(S, P, O, G)
}


#### when 

when(Condition, Consequent) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * When the sub-query in Condition is met, the Update query is executed
 * @param {object or boolean} Query - WOQL Query object or bool
 * @param {object} Update - WOQL Query object, optional
 * @return {object} WOQLQuery
 *
 * Functions which take a query as an argument advance the cursor to make the chaining of queries fall into the corrent place in the encompassing json.
 */
WOQL.when = function(Query, Update) {
    return new WOQLQuery().when(Query, Update)
}

## Arithmetic Operators

#### eval 

eval(ArithmeticExpression, Value) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Evaluates the Arithmetic Expression Arith and copies the output to variable V
 * @param {object} arith - query or JSON-LD representing the query
 * @param {string} v - output variable
 * @return {object} WOQLQuery
 */
WOQL.eval = function(arith, v) {
    return new WOQLQuery().eval(arith, v)
}

#### sum 

sum(List, Total) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Adds a list of numbers together
 * @param input - input list variable
 * @param output - output numeric
 * @return {object} WOQLQuery
 */
WOQL.sum = function(input, output) {
    return new WOQLQuery().sum(input, output)
}


#### plus 

sum(Number1, Number2, Total) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Adds numbers N1...Nn together
 * @param args - numbers to add together
 * @return {object} WOQLQuery
 */
WOQL.plus = function(...args) {
    return new WOQLQuery().plus(...args)
}

#### minus 

sum(Number1, Number2, Difference) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Subtracts Numbers N1..Nn
 * @param args - numbers to be subtracted
 * @return {object} WOQLQuery
 */
WOQL.minus = function(...args) {
    return new WOQLQuery().minus(...args)
}

#### times 

times(Number1, Number2, Total) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Multiplies numbers N1...Nn together
 * @param args - numbers to be multiplied
 * @return {object} WOQLQuery
 */
WOQL.times = function(...args) {
    return new WOQLQuery().times(...args)
}

#### divide

divide(Number1, Number2, Ratio) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Divides numbers N1...Nn by each other left, to right precedence
 * @param args - numbers to tbe divided
 * @return {object} WOQLQuery
 */
WOQL.divide = function(...args) {
    return new WOQLQuery().divide(...args)
}

#### div 

div(Number1, Number2, RatioFloor) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Division - integer division - args are divided left to right
 * @param args - numbers for division
 * @return {object} WOQLQuery
 */
WOQL.div = function(...args) {
    return new WOQLQuery().div(...args)
}

#### exp 

exp(Number1, Number2, Total) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Raises A to the power of B
 * @param {integer or double} a - base number
 * @param {integer or double} b - power of
 * @return {object} WOQLQuery
 */
WOQL.exp = function(a, b) {
    return new WOQLQuery().exp(a, b)
}

#### floor

floor(Number1, IntegerFloor) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Floor (closest lower integer)
 * @param {integer or double} a
 * @return {object} WOQLQuery
 */
WOQL.floor = function(a) {
    return new WOQLQuery().floor(a)
}

#### less 

less(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Compares the value of v1 against v2 and returns true if v1 is less than v2
 * @param {string} v1 - first variable to compare
 * @param {string} v2 - second variable to compare
 * @return {object} WOQLQuery
 */
WOQL.less = function(v1, v2) {
    return new WOQLQuery().less(v1, v2)
}

#### greater 

greater(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Compares the value of v1 against v2 and returns true if v1 is greater than v2
 * @param {string} v1 - first variable to compare
 * @param {string} v2 - second variable to compare
 * @return {object} WOQLQuery
 */
WOQL.greater = function(v1, v2) {
    return new WOQLQuery().greater(v1, v2)
}

### Importing Data

#### get 

greater(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Imports the Target Resource to the variables defined in vars
 * @param {object} asvars - An AS query (or json representation)
 * @param {object} query_resource - description of where the resource is to be got from (WOQL.file, WOQL.remote, WOQL.post)
 * @return {object} WOQLQuery
 */
WOQL.get = function(asvars, query_resource) {
    return new WOQLQuery().get(asvars, query_resource)
}

#### put 

put(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Exports the Target Resource to the file file, with the variables defined in as
 * @param {object} asvars - An AS query (or json representation)
 * @param {object} query - A sub-query to be dumpted out
 * @param {object} query_resource - description of where the resource is to be put
 * @return {object} WOQLQuery
 */
WOQL.put = function(asvars, query, query_resource) {
    return new WOQLQuery().put(asvars, query, query_resource)
}

#### as 

as(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Imports the value identified by Source to a Target variable
 * @param {string or integer} map - Source
 * @param {string} vari - Target
 * @param {string} [ty] - optional type to cast value to
 * @return {object} WOQLQuery
 */
WOQL.as = function(map, vari, ty) {
    return new WOQLQuery().as(map, vari, ty)
}

#### remote 

as(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Provides details of a remote data source in a JSON format that includes a URL property
 * @param {object} url - remote data source in a JSON format
 * @param {object} opts - imput options, optional
 * @return {object} WOQLQuery
 */
WOQL.remote = function(url, opts) {
    return new WOQLQuery().remote(url, opts)
}

#### file 

as(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Provides details of a file source in a JSON format that includes a URL property
 * @param {object} url - file data source in a JSON format
 * @param {object} opts - imput options, optional
 * @return {object} WOQLQuery
 */
WOQL.file = function(url, opts) {
    return new WOQLQuery().file(url, opts)
}

#### post 

post(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Provides details of a file source in a JSON format that includes a URL property
 * @param {object} url - file data source in a JSON format
 * @param {object} opts - imput options, optional
 * @return {object} WOQLQuery
 */
WOQL.post = function(url, opts) {
    return new WOQLQuery().post(url, opts)
}

### Resource Specification

#### using 

using(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * allow you to do a query against a specific commit point
 *
 * example WOQL.using("userName/dbName/local/commit|branch/commitID").triple("v:A", "v:B", "v:C")..
 *
 * @param {string}   		 - refPath  path to specific refId
 * @param {WOQLQuery object} - subquery for the specific commit point
 * @return WOQLQuery
 */

WOQL.using = function(refPath, Query) {
    return new WOQLQuery().using(refPath, Query)
}

#### into 

into(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Sets the current output graph for writing output to.
 * @param {string} graph_descriptor - a id of a specific graph (e.g. instance/main) that will be written to
 * @param {object} query - WOQL Query object, optional
 * @return {object} WOQLQuery
 */
WOQL.into = function(graph_descriptor, query) {
    return new WOQLQuery().into(graph_descriptor, query)
}

### Database Size 

#### size 

size(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Returns the size of the passed graph filter
 */
WOQL.size = function(Graph, Size) {
    return new WOQLQuery().size(Graph, Size)
}

#### triple_count 

triple_count(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Returns the count of triples in the passed graph filter
 */
WOQL.triple_count = function(Graph, TripleCount) {
    return new WOQLQuery().triple_count(Graph, TripleCount)
}


### Document Queries (Experimental / Unstable)

#### update_object 

update_object(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Updates a document (or any object) in the db with the passed copy
 * @param {string} JSON - JSON-LD document
 * @return {object} WOQLQuery
 */
WOQL.update_object = function(JSON) {
    return new WOQLQuery().update_object(JSON)
}


#### delete_object 

delete_object(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Deletes a node identified by an IRI or a JSON-LD document
 * @param {string} JSON_or_IRI - IRI or a JSON-LD document
 * @return {object} WOQLQuery
 */
WOQL.delete_object = function(JSON_or_IRI) {
    return new WOQLQuery().delete_object(JSON_or_IRI)
}

#### read_object 

read_object(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQL.read_object = function(IRI, Output, Format) {
    return new WOQLQuery().read_object(IRI, Output, Format)
}

## Non Primitive Functions

### WOQL Literals, Prefixes & IRI Constants

#### string 

string(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

#### literal 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQL.literal = function(s, t) {
    return new new WOQLQuery().literal(s, t)
}

#### iri 

iri(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQL.iri = function(s) {
    return new new WOQLQuery().iri(s)
}

### Basic Helper Functions

#### query 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Creates a new Empty Query object
 * @return {object} WOQLQuery
 */
WOQL.query = function() {
    return new WOQLQuery()
}

#### json 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

//loads query from json

/**
 * Generates a WOQLQuery object from the passed WOQL JSON
 * @param {object} json - JSON-LD object, optional
 * @return {object} WOQLQuery
 *
 * json version of query for passing to api
 */
WOQL.json = function(json) {
    return new WOQLQuery().json(json)
}

#### vars 

vars(...Varnames) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


WOQL.vars = function(...varray) {
    return varray.map((item) => 'v:' + item)
}

## Compound Functions

#### star 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * By default selects everything as triples ("v:Subject", "v:Predicate", "v:Object") in the graph identified by GraphIRI or in all the current terminusDB's graph
 *
 * example WOQL.star("schema/main") will give all triples in the main schema graph
 *
 * @param {string} graphRef 	- optional target graph 	false is the default value and get all the database's graphs, possible value are  | false | schema/{main - myschema - *} | instance/{main - myschema - *}  | inference/{main - myschema - *}
 * @param {string} Subj 		- optional target subject   default value "v:Subject"
 * @param {string} Pred 		- optional target predicate default value "v:Predicate"
 * @param {string} Obj 			- optional target object    default value "v:Object"
 * @return {object} WOQLQuery
 */
WOQL.star = function(graphRef, Subj, Pred, Obj) {
    return new WOQLQuery().star(graphRef, Subj, Pred, Obj)
}

#### all 

all(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


WOQL.all = function(Subj, Pred, Obj, graphRef) {
    return new WOQLQuery().star(graphRef, Subj, Pred, Obj)
}

### Builder Functions

#### node 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Selects nodes with the ID NodeID as the subject of subsequent sub-queries. The second argument PatternType specifies what type of sub-queries are being constructed, options are: triple, quad, update_triple, update_quad, delete_triple, delete_quad
 * @param {string} nodeid - node to be selected
 * @param {string} type - pattern type, optional (default is triple)
 * @return {object} WOQLQuery
 */
WOQL.node = function(nodeid, type) {
    return new WOQLQuery().node(nodeid, type)
}
WOQLQuery.prototype.node = function(node, type) {
    type = type || false
    if (type == 'add_quad') type = 'AddQuad'
    else if (type == 'delete_quad') type = 'DeleteQuad'
    else if (type == 'add_triple') type = 'AddTriple'
    else if (type == 'delete_triple') type = 'DeleteTriple'
    else if (type == 'quad') type = 'Quad'
    else if (type == 'triple') type = 'Triple'
    if (type && type.indexOf(':') == -1) type = 'woql:' + type
    let ctxt = {subject: node}
    if (type) ctxt.action = type
    this._set_context(ctxt)
    return this
}

#### insert 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


/**
 * Insert a node with a specific type in a graph // statement is used to insert new records in a table.
 * document type
 * @param {string} Node 		- node to be insert
 * @param {string} Type 		- type of the node (class/document name)
 * @param {string} graphRef 	- optional target graph if not setted it get all the database's graphs, possible value are  | schema/{main - myschema - *} | instance/{main - myschema - *}  | inference/{main - myschema - *}
 * @return {object} WOQLQuery
 */
WOQL.insert = function(Node, Type, graphRef) {
    return new WOQLQuery().insert(Node, Type, graphRef)
}

#### abstract 

abstract(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


WOQLQuery.prototype.abstract = function(graph, subj) {
    this._add_partial(subj, 'system:tag', 'system:abstract', graph)
    return this
}

#### property 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Add a property at the current class/document
 *
 * @param {string} proId - property ID
 * @param {string} type  - property type (range) (on class inserts) property value on data inserts
 * @returns WOQLQuery object
 *
 * A range could be another class/document or an "xsd":"http://www.w3.org/2001/XMLSchema#" type
 * like string|integer|datatime|nonNegativeInteger|positiveInteger etc ..
 * (you don't need the prefix xsd for specific a type)
 */

WOQLQuery.prototype.property = function(proId, type_or_value) {
    if (this._adding_class()) {
        let part = this.findLastSubject(this.cursor)
        let g = false
        let gpart
        if (part) gpart = part['woql:graph_filter'] || part['woql:graph']
        if (gpart) g = gpart['@value']
        let nprop = new WOQLSchema()
            .add_property(proId, type_or_value, g)
            .domain(this._adding_class())
        this.and(nprop)
    } else {
        this._add_partial(false, proId, type_or_value)
    }
    return this
}

#### insert 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQLQuery.prototype.insert = function(id, type, refGraph) {
    type = this.cleanType(type, true)
    if (refGraph) {
        return this.add_quad(id, 'type', type, refGraph)
    }
    return this.add_triple(id, 'type', type)
}

#### insert data

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


WOQLQuery.prototype.insert_data = function(data, refGraph) {
    if (data.type && data.id) {
        type = this.cleanType(data.type, true)
        this.insert(data.id, type, refGraph)
        if (data.label) {
            this.label(data.label)
        }
        if (data.description) {
            this.description(data.description)
        }
        for (var k in data) {
            if (['id', 'label', 'type', 'description'].indexOf(k) == -1) {
                this.property(k, data[k])
            }
        }
    }
    return this
}

#### graph 

literal(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


WOQLQuery.prototype.graph = function(g) {
    return this._set_context({graph: g})
}

#### domain 

domain(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQLQuery.prototype.domain = function(d) {
    d = this.cleanClass(d)
    return this._add_partial(false, 'rdfs:domain', d)
}

#### label 

label(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQLQuery.prototype.label = function(l, lang) {
    lang = lang ? lang : 'en'
    if (l.substring(0, 2) == 'v:') {
        var d = l
    } else {
        var d = {'@value': l, '@type': 'xsd:string', '@language': lang}
    }
    return this._add_partial(false, 'rdfs:label', d)
}

#### description 

description(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 


WOQLQuery.prototype.description = function(c, lang) {
    lang = lang ? lang : 'en'
    if (c.substring(0, 2) == 'v:') {
        var d = c
    } else {
        var d = {'@value': c, '@type': 'xsd:string', '@language': lang}
    }
    return this._add_partial(false, 'rdfs:comment', d)
}


#### parent 

parent(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Specifies that a new class should have parents class
 * @param {array} parentList the list of parent class []
 *
 */
WOQLQuery.prototype.parent = function(...parentList) {
    for (var i = 0; i < parentList.length; i++) {
        var pn = this.cleanClass(parentList[i])
        this._add_partial(false, 'rdfs:subClassOf', pn)
    }
    return this
}

#### max 

max(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQLQuery.prototype.max = function(m) {
    this._card(m, 'max')
    return this
}

#### min 

min(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQLQuery.prototype.min = function(m) {
    this._card(m, 'min')
    return this
}

#### cardinality 

cardinality(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQLQuery.prototype.cardinality = function(m) {
    this._card(m, 'cardinality')
    return this
}

### Schema Functions

#### schema 

cardinality(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

WOQL.schema = function(G) {
    return new WOQLSchema(G)
}

#### add_class 

add_class(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Generates a new Class with the given ClassID and writes it to the DB schema
 * @param {string} classid - class to be added
 * @param {string} graph - target graph
 * @return {object} WOQLQuery
 */
WOQL.add_class = function(classid, graph) {
    return new WOQLSchema().add_class(classid, graph)
}

#### add_property 

add_property(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Generates a new Property with the given PropertyID and a range of type and writes it to the DB schema
 * @param {string} propid - property id to be added
 * @param {string} type - type of the proerty
 * @param {string} graph - target graph, optional
 * @return {object} WOQLQuery
 */
WOQL.add_property = function(propid, type, graph) {
    return new WOQLSchema().add_property(propid, type, graph)
}

#### doctype 

add_property(Val1, Val2) 

Status: Stable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Creates a new document class in the schema - equivalent to: add_quad(type, "rdf:type", "owl:Class", graph), add_quad(type, subclassof, tcs:Document, graph)
 * @param {string} Type - type of the document
 * @param {string} Graph - target graph, optional
 * @return {object} WOQLQuery
 */
WOQL.doctype = function(Type, Graph) {
    return WOQL.add_class(Type, Graph).parent('Document')
}


#### delete_class 

delete_class(Val1, Val2) 

Status: Experimental / Unstable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Deletes the Class with the passed ID form the schema (and all references to it)
 * @param {string} classid - class to be added
 * @param {string} graph - target graph
 * @return {object} WOQLQuery
 */
WOQL.delete_class = function(classid, graph) {
    return new WOQLSchema().delete_class(classid, graph)
}

#### delete_property 

delete_property(Val1, Val2) 

Status: Experimental / Unstable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * Deletes the property with the passed ID from the schema (and all references to it)
 * @param {string} propid - property id to be added
 * @param {string} graph - target graph, optional
 * @return {object} WOQLQuery
 */
WOQL.delete_property = function(propid, graph) {
    return new WOQLSchema().delete_property(propid, graph)
}

#### insert_class_data 

insert_class_data(Val1, Val2) 

Status: Experimental / Unstable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * @param {object} data - json object which contains fields:
 * mandatory: id
 * optional: label, description, parent, [property] (valid property ids)
 * @param {string} refGraph - Graph Identifier
 */
WOQL.insert_class_data = function(data, refGraph) {
    return new WOQLSchema().insert_class_data(data, refGraph)
}

#### doctype_data 

doctype_data(Val1, Val2) 

Status: Experimental / Unstable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * @param {object} data - json object which contains fields:
 * mandatory: id
 * optional: label, description, parent, [property] (valid property ids)
 * @param {string} refGraph - Graph Identifier
 */
WOQL.doctype_data = function(data, refGraph) {
    return new WOQLSchema().doctype_data(data, refGraph)
}

#### insert_property_data 

doctype_data(Val1, Val2) 

Status: Experimental / Unstable

Description:   

Arguments: 

Returns: 
    A WOQLQuery which contains the Lower Case pattern matching expression

Example: 

/**
 * @param {object} data - json object which contains fields:
 * mandatory: id, range, domain
 * optional: label, description, min, max, cardinality
 */
WOQL.insert_property_data = function(data, refGraph) {
    return new WOQLSchema().insert_property_data(data, refGraph)
}

### Library Functions

WOQL.lib = function(mode) {
    return new new WOQLQuery().lib(mode)
}






