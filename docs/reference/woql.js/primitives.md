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
    Subq (WOQLQuery*) - The query whose results will be grouped 

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
    //trimmed contains "hello"

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
    //upper contains "ABCE"

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
    //lower contains "abce"

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
    A WOQLQuery which contains the Join pattern matching expression

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
    A WOQLQuery which contains the Regular Expression pattern matching expression

Example: 
    let [e, llo] = vars('e', 'ello')
    WOQL.re("h(.).*", "hello", [e, llo])
    //e contains 'e', llo contains 'llo'

#### like 

like(StringA, StringB, Distance) 

Status: Stable

Description: Generates a string Leverstein distance measure between StringA and StringB

Arguments: 
    StringA (string*) - string literal or variable representing a string to be compared 
    StringA (string*) - string literal or variable representing the other string to be compared 
    Distance (string / [float]*) - variable representing the distance between the variables

Returns: 
    A WOQLQuery which contains the Like pattern matching expression

Example: 
    let [dist] = vars('dist')
    like("hello", "hallo", dist)
    //dist contains 0.7265420560747664

### Updates / Transactions

#### add_triple 

add_triple(Subject, Predicate, Object) 

Status: Stable

Description: Adds a single triple to the database

Arguments: 
    Subject (string*) - The IRI of a triple's subject or a variable 
    Predicate (string*) - The IRI of a property or a variable 
    Object (string*) - The IRI of a node or a variable, or a literal 

Returns: 
    A WOQLQuery which contains the add_triple insert statement

Example: 
    add_triple("john", "age", 42)

#### add_quad 

add_quad(Subject, Predicate, Object, Graph) 

Status: Stable

Description: Adds a single triple to the specified graph in the database

Arguments: 
    Subject (string*) - The IRI of a triple's subject or a variable 
    Predicate (string*) - The IRI of a property or a variable 
    Object (string*) - The IRI of a node or a variable, or a literal 
    Graph (string*) - The resource identifier of a graph  

Returns: 
    A WOQLQuery which contains the add_quad insert statement

Example: 
    add_quad("Person", "type", "owl:Class", "schema/main")

#### delete_triple 

delete_triple(Subject, Predicate, Object) 

Status: Stable

Description: Deletes a single triple from the default graph of the database

Arguments: 
    Subject (string*) - The IRI of a triple's subject or a variable 
    Predicate (string*) - The IRI of a property or a variable 
    Object (string*) - The IRI of a node or a variable, or a literal 

Returns: 
    A WOQLQuery which contains the Triple Deletion statement

Example: 
    delete_triple("john", "age", 42)

#### delete_quad 

delete_quad(Subject, Predicate, Object, Graph) 

Status: Stable

Description: Deletes a single triple from the default graph of the database  

Arguments: 
    Subject (string*) - The IRI of a triple's subject or a variable 
    Predicate (string*) - The IRI of a property or a variable 
    Object (string*) - The IRI of a node or a variable, or a literal 
    Graph (string*) - The resource identifier of a graph  

Returns: 
    A WOQLQuery which contains the Delete Quad Statement

Example: 
    delete_quad("Person", "type", "owl:Class", "schema/main")

#### when 

when(Condition, Consequent) 

Status: Stable

Description: Generates a transaction which encompasses all situations in which the Condition is true, the Consequent will be executed - the when block encapsulates a single transaction and allows a single query to express multiple transactions (by including multiple when blocks)  

Arguments: 
    Condition (WOQLQuery*) - The query which, for each match, will cause the associated consequent to execute
    Consequent (WOQLQuery*) - The query which, for each match of the Condition, will be executed

Returns: 
    A WOQLQuery which contains the conditional transactional statement

Example: 
    when(true).add_triple("doc:john", "type", "scm:Person")

### Arithmetic Operators

Arithmetic Operators can be arbitrarily composed through the construction of Arithmetic Expressions and passed to the eval function which returns a variable containing the calculated result. This provides a general, stand-alone scientific calculator function, into which variables and constants from larger queries can be injected into mathematical functions. Used in isolation it is a calculator.   

#### evaluate

evaluate(ArithmeticExpression, Result)  ~ eval(ArithmeticExpression, Result) (note eval does not work without a preceding WOQL. - you must use evaluate to avoid clashing with javascripts eval() function)

Status: Stable

Description: Evaluates the passed arithmetic expression and generates or matches the result value

Arguments: 
    ArithmeticExpression (WOQLQuery*) - A WOQL query containing a valid WOQL Arithmetic Expression, which is evaluated by the function
    Result (string or decimal or integer*) - Either a variable, in which the result of the expression will be stored, or a numeric literal which will be used as a test of result of the evaluated expression

Returns: 
    A WOQLQuery which contains the Arithmetic function

Example:
    let [result] = vars("result")
    evaluate(plus(2, minus(3, 1)), result)
    //result contains 4

#### sum 

sum(List, Total) 

Status: Stable

Description: computes the sum of the List of values passed. In contrast to other arithmetic functions, sum self-evaluates - it does not have to be passed to evaluate()

Arguments: 
    List ([string or numeric*]) - a list variable, or a list of variables or numeric literals
    Total - a variable or numeric containing the sum of the values in List

Returns: 
    A WOQLQuery which contains the Sum expression

Example: 
    let [result] = vars("result")
    sum([2, 3, 4, 5], result)
    //result contains 14

#### plus 

plus(Number1, Number2) 

Status: Stable

Description: adds two numbers together 

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the first value to add
    Number2 (string or numeric*) - a variable or numeric containing the second value to add

Returns: 
    A WOQLQuery which contains the addition expression

Example: 
    let [result] = vars("result")
    evaluate(plus(2, plus(3, 1)), result)
    //result contains 6

#### minus 

minus(Number1, Number2) 

Status: Stable

Description: subtracts Number2 from Number1  

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the value that will be subtracted from
    Number2 (string or numeric*) - a variable or numeric containing the value to be subtracted

Returns: 
    A WOQLQuery which contains the subtraction expression

Example: 
    let [result] = vars("result")
    evaluate(minus(2.1, plus(0.2, 1)), result)
    //result contains 0.9000000000000001 - note floating point inaccuracy

#### times 

times(Number1, Number2) 

Status: Stable

Description: multiples Number1 and Number2

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the first value to multiply
    Number2 (string or numeric*) - a variable or numeric containing the second value to multiply

Returns: 
    A WOQLQuery which contains the multiplication expression

Example: 
    let [result] = vars("result")
    evaluate(times(10, minus(2.1, plus(0.2, 1))), result)
    //result contains 9.000000000000002

#### divide

divide(Number1, Number2) 

Status: Stable

Description: divides Number1 by Number2

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the number to be divided
    Number2 (string or numeric*) - a variable or numeric containing the divisor

Returns: 
    A WOQLQuery which contains the division expression

Example: 
    let [result] = vars("result")
    evaluate(divide(times(10, minus(2.1, plus(0.2, 1))), 10), result)
    //result contains 0.9000000000000001

#### floor

floor(Number1) 

Status: Stable

Description: generates the nearest lower integer to the passed number

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the number to be floored

Returns: 
    A WOQLQuery which contains the floor expression

Example: 
    let [result] = vars("result")
    evaluate(divide(floor(times(10, minus(2.1, plus(0.2, 1)))), 10), result)
    //result contains 0.9 - floating point error removed

#### div 

div(Number1, Number2) 

Status: Stable

Description: integer division: divides Number1 by Number2 to return an integer value

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the number to be divided
    Number2 (string or numeric*) - a variable or numeric containing the divisor

Returns: 
    A WOQLQuery which contains the integer division expression

Example: 
    let [result] = vars("result")
    evaluate(div(10, 3), result)
    //result contains 3

#### exp 

exp(Number1, Number2) 

Status: Stable

Description: exponent - raises Number1 to the power of Number2

Arguments: 
    Number1 (string or numeric*) - a variable or numeric containing the number to be raised to the power of the second number
    Number2 (string or numeric*) - a variable or numeric containing the exponent

Returns: 
    A WOQLQuery which contains the exponent expression

Example: 
    let [result] = vars("result")
    evaluate(exp(3, 2), result)
    //result contains 9

#### less 

less(Val1, Val2) 

Status: Stable

Description: Matches when Val1 is less than Val2

Arguments: 
    Val1 (string or numeric*) - a variable or numeric containing the number to be compared
    Val2 (string or numeric*) - a variable or numeric containing the second comporator

Returns: 
    A WOQLQuery which contains the comparison expression

Example: 
    let [result] = vars("result")
    less(1, 1.1).eq(result, literal(true, "boolean"))
    //result contains true


#### greater 

greater(Val1, Val2) 

Status: Stable

Description: Matches when Val1 is greater than Val2

Arguments: 
    Val1 (string or numeric*) - a variable or numeric containing the number to be compared
    Val2 (string or numeric*) - a variable or numeric containing the second comporator

Returns: 
    A WOQLQuery which contains the comparison expression

Example: 
    let [result] = vars("result")
    greater(1.2, 1.1).eq(result, literal(true, "boolean"))
    //result contains true


### Importing & Exporting 

#### get 

get(AsVArs, QueryResource) 

Status: Stable

Description: retrieves the exernal resource defined by QueryResource and copies values from it into variables defined in AsVars

Arguments: 
    AsVArs ([string]*) an array of AsVar variable mappings (see as for format below)
    QueryResource (string*) an external resource (remote, file, post) to query 

Returns: 
    A WOQLQuery which contains the get expression

Example: 
    let [a, b] = vars("a", "b")
    get(as("a", a).as("b", b)).remote("http://my.url.com/x.csv")
    //copies the values from column headed "a" into a variable a and from column "b" into a variable b from remote CSV  

#### put 

put(AsVArs, Subq, FileResource) 

Status: Stable

Description: outputs the results of a query to a file

Arguments: 
    AsVArs ([string]*) an array of AsVar variable mappings (see as for format below)
    Subq (WOQLQuery*) - The query which will be executed to produce the results 
    FileResource (string*) an file resource local to the server 

Returns: 
    A WOQLQuery which contains the put expression

Example: 
    let [s, p, o] = vars("Subject", "Predicate", "Object")
    put(as("s", s).as("p", p).as("o", o), all()).file("/app/local_files/dump.csv")

#### as 

as(SourceLocator, VarName, Type) 

Status: Stable

Description:  Maps data from an imported source to a WOQL variable and optionally sets its type

Arguments: 
    SourceLocator (string) - an optional string containing the CSV column header, or a variable containing the string (if it is omitted when extracting data from a CSV, the CSV will be indexed by column number) 
    VarName (string*) - the name of the variable into which the data from the external resource will be copied
    Type (string) - an optional type to which the data will be automatically mapped on import

Returns: 
    A WOQLQuery which contains the variable mapping expression

Example:
    let [date] = vars("Date")
    get(as("Date.From", date)).remote("http://seshatdatabank.info/wp-content/uploads/2020/01/Iron-Updated.csv")

#### remote 

remote(URL, Opts)

Status: Stable

Description: identifies a remote resource by URL and specifies the format of the resource through the options   

Arguments: 
    URL (string*) The URL at which the remote resource can be accessed
    Opts (object) A option json which can have the following keys: 
        type: csv|turtle

Returns: 
    A WOQLQuery which contains the remote resource identifier

Example: 
    remote("http://url.of.resource", {type: "csv"})

#### file 

file(Path, Opts)

Status: Stable

Description: identifies a file resource as a path on the server and specifies the format through the options   

Arguments: 
    Path (string*) The Path on the server at which the file resource can be accessed
    Opts (object) A option json which can have the following keys: 
        type: csv|turtle

Returns: 
    A WOQLQuery which contains the file resource identifier

Example: 
    file("/path/to/file", {type: 'turtle'} )

#### post 

post(Path, opts) 

Status: Stable

Description: identifies a resource as a local path on the client, to be sent to the server through a HTTP POST request, with the format defined through the options  

Arguments: 
    Path (string*) The Path on the server at which the file resource can be accessed
    Opts (object) A option json which can have the following keys: 
        type: csv|turtle

Returns: 
    A WOQLQuery which contains the Post resource identifier

Example: 
    post("/.../.../", {})

### Resource Specification

#### using 

using(GraphResource, Subq) 

Status: Stable

Description: specifies the resource to use as default in the contained query 

Arguments: 
    GraphResource (string*) - A valid graph resource identifier string 
    Subq (WOQLQuery*) - The query which will be executed against the resource identified above 

Returns: 
    A WOQLQuery which is defined to run against the resource

Example: 
    using("admin/minecraft").all()
    //retrieves all triples in the minecraft db of the admin organization

#### into 

into(GraphResource, Subq) 

Status: Stable

Description: specifies the graph resource to write the contained query into

Arguments: 
    GraphResource (string*) - A valid graph resource identifier string 
    Subq (WOQLQuery*) - The query which will be written into the graph 

Returns: 
    A WOQLQuery which will be written into the graph in question

Example: 
    using("admin/minecraft").into("instance/main").add_triple("a", "type", "scm:X")
    //writes a single tripe (doc:a, rdf:type, scm:X) into the main instance graph

### Database Size 

#### size 

size(ResourceID, Size) 

Status: Stable

Description: calculates the size in bytes of the contents of the resource identified in ResourceID

Arguments: 
    ResourceID (string*) - A valid resource identifier string (can refer to any graph / branch / commit / db)
    Size (string or integer*) - An integer literal with the size in bytes or a variable containing that integer  

Returns: 
    A WOQLQuery which contains the size expression

Example: 
    let [sz] = vars("s")
    size("admin/minecraft/local/branch/main/instance/main", sz)
    //returns the number of bytes in the main instance graph on the main branch

#### triple_count 

triple_count(ResourceID, Count) 

Status: Stable

Description: calculates the size in bytes of the contents of the resource identified in ResourceID

Arguments: 
    ResourceID (string*) - A valid resource identifier string (can refer to any graph / branch / commit / db)
    Count (string or integer*) - An integer literal with the size in bytes or a variable containing that integer  

Returns: 
    A WOQLQuery which contains the size expression

Example: 
    let [tc] = vars("s")
    triple_count("admin/minecraft/local/_commits", tc)
    //returns the number of bytes in the local commit graph

### Document Queries (Experimental / Unstable)

Document queries take or return entire JSON-LD document as arguments. This relies upon the internal frame-generation capabilities of the database and requires the user to have defined discrete document classes to dictate at what points the graph traversal is truncated - a document is considered to contain all objects within it, with the exception of predicates and classes that belong to other documents. This takes some care - improperly defined it can lead to very slow queries which contain the whole database unrolled into a single document - not normally what we require.   

#### update_object 

update_object(JSONLD) 

Status: Experimental / Unstable

Description: Updates a document (or any object) in the db with the passed json-ld - replaces the current version

Arguments: 
    JSONLD (string*) the document's JSON-LD form which will be written to the DB

Returns: 
    A WOQLQuery which contains the update object expression

Example: 
    update_object({"@id": "doc:joe", "@type": "scm:Person", "rdfs:label": {"@type": "xsd:string", "@value": "Joe"}})

#### delete_object 

delete_object(JSON_or_IRI) 

Status: Stable

Description: Deletes the entire refered document and all references to it

Arguments: 
    JSON_or_IRI (string*) either a full JSON-LD document, an IRI literal or a variable containing either 

Returns: 
    A WOQLQuery which object deletion expression

Example: 
    delete_object("doc:mydoc")

#### read_object 

read_object(DocumentIRI, JSONLD)

Description: saves the entire document with IRI DocumentIRI into the JSONLD variable 

Arguments: 
    DocumentIRI (string*) either an IRI literal or a variable containing an IRI  
    JSONLD (string*) a varialbe into which the document's JSON-LD form will be saved

Returns: 
    A WOQLQuery which contains the document retrieval expression

Example: 
    let [mydoc] = vars("mydoc")
    read_object("doc:a", mydoc)
    //mydoc will have the json-ld document with ID doc:x stored in it
