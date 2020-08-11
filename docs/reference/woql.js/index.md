---
layout: default
title: WOQL Primitives
parent: WOQL.js - the Definitive Guide
grand_parent: Reference
nav_order: 5
permalink: /reference/woql/primitives
---
## WOQL Primitives

WOQL primitives are WOQL.js functions which directly map onto words in the underlying JSON-LD language. All other WOQL.js functions are compound functions which translate into multiple WOQL primitives, or are helper functions which reduce the need to write verbose JSON-LD directly.


### Basics

<!-- triple -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">triple</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generates a triple pattern matching rule to match any triples that meet the constraints

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

triple(Subject, Predicate, Object)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>         | (string*) - The IRI of a triple's subject or a variable              | Mandatory                  |
| <span class="param-type">Predicate </span>        | (string*) - The IRI of a property or a variable                      | Mandatory                  |
| <span class="param-type">Object </span>           | (string*) - The IRI of a node or a variable, or a literal            | Mandatory                  |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the triple pattern matching rule

<div class="anchor-sub-parts">Example</div>


<div class="code-example" markdown="1">
```js

let [subj, obj] = vars("subj", "obj")

triple(s, "type", o)
```
</div>

<hr class="section-separator"/>
<!----------------------------------------------------------------------------------------->

<!-- quad -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">quad</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generates a quad pattern matching rule to match any triples that meet the constraints in the specified Graph

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

quad(Subject, Predicate, Object, Graph)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>         | (string*) - The IRI of a triple's subject or a variable              | Mandatory                  |
| <span class="param-type">Predicate </span>        | (string*) - The IRI of a property or a variable                      | Mandatory                  |
| <span class="param-type">Object </span>           | (string*) - The IRI of a node or a variable, or a literal            | Mandatory                  |
| <span class="param-type">Graph </span>            | (string*) - The Resource String identifying the graph to be searched for the pattern| Mandatory   |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the quad pattern matching rule


<div class="anchor-sub-parts">Example</div>


<div class="code-example" markdown="1">
```js
let [class, prop] = vars("class", "prop")

quad(class, "domain", prop, "schema/main")
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->

<!-- comment -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">comment</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Inserts a textual comment into a query and optionally 'comments' out the contained subquery

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

comment(Comment, Subq)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Comment  </span>         | (string*) - The textual comment                                      | Mandatory                  |
| <span class="param-type">Subq </span>             | (string*) - (WOQLQuery) - An optional enclosed sub-query that is commented out <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query | Mandatory                  |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the comment


<div class="anchor-sub-parts">Example</div>


<div class="code-example" markdown="1">
```js
comment("This has a bug").triple(a, b, c)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->    

<!--select-->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">select</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Selects (filters) a list of variables from the enclosed sub-query and removes the rest

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

select(...Vars, Subq)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">...Vars  </span>         | (string*) - A list of one or more variables to select                | Mandatory                  |
| <span class="param-type">Subq </span>             | (string*) - (WOQLQuery) - A query from which the variables will be filtered out <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the filtered variables and subquery

<div class="anchor-sub-parts">Example</div>


<div class="code-example" markdown="1">
```js
let [grouped, subject, class] = vars("grouped", "subject", "class")

select(grouped).group_by(subject, class, grouped).triple(subject, "type", class)   
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->    

<!-- and -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">and</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Logical conjunction of the contained queries - all queries must match or the entire clause fails

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

and(...Subqueries)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">...Subqueries  </span>   | (WOQLQuery*) - A list of one or more woql queries to execute as a conjunction  | Mandatory        |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the conjunction of queries

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [subject, class, label] = vars("subject", "class", "label")

and(
    triple(subject, 'type', class),
    triple(subject, "label", label)
)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->    
<!-- or -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">or</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Logical Or of the contained queries - the first subquery to match will cause subsequent subqueries to not be evaluated

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

or(...Subqueries)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">...Subqueries  </span>   | (WOQLQuery*) - A list of one or more woql queries to execute as alternatives  | Mandatory        |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the logical Or of the subqueries

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [subject] = vars("subject")

or(
    triple(subject, 'label', "A"),
    triple(subject, "label", "a")
)

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->    
<!-- opt -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">opt</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Specifies that the Subquery is optional - if it does not match the query will not fail

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
opt(Subquery) ~ optional(Subquery) (alias))
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subquery  </span>      | (WOQLQuery*) - A subquery which will be optionally matched <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query           | Mandatory        |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the optional sub Query

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [subject] = vars("subject")

opt().triple(subject, 'label', "A")
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  

<!-- not -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">not</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Logical negation of the contained subquery - if the subquery matches, the query will fail to match

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
not(Subquery)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subquery  </span>        | (WOQLQuery*) - A subquery which will be negated   <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query                    | Mandatory        |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the negated sub Query

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [subject, label] = vars("subject", "label")

not().triple(subject, 'label', label)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  

<!-- isa -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">isa</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Tests whether a given instance IRI has type Class

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
isa(IRI, Class)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Instance_IRI  </span>    | (string*) - A string IRI or a variable                               | Mandatory                  |
| <span class="param-type">Class  </span>           | (string*) - A Class IRI or a variable                                | Mandatory                  |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the type test

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [subject] = vars("subject")

isa(subject, "Person")
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  
<!-- sub -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">sub</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Tests whether a given Class subsumes another class

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
sub(ClassA, ClassB) ~ subsumption(ClassA, ClassB) (Alias)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">ClassA  </span>          | (string*) - A Class IRI or a variable representing the subsuming (parent) class | Mandatory       |
| <span class="param-type">Class  </span>           | (string*) - A Class IRI or a variable representing the subsumed (child) class   | Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the subsumption test

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [class] = vars("class")

sub("Vegetable", class)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  

<!-- unique -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">unique</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generate a new IRI from the prefix and a hash of the variables which will be unique for any given combination of variables

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
unique(Prefix, Vars, NewIRI)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Prefix  </span>          | (string*) - A prefix for the IRI - typically formed of the doc prefix and the classtype of the entity ("doc:Person") | Mandatory       |
| <span class="param-type">Vars  </span>           | ([string*]) - An array of variables and / or strings from which the unique hash will be generated   | Mandatory       |
| <span class="param-type">NewIRI  </span>           | (string*) - Variable in which the unique ID is stored   | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the unique ID generating function

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [newid] = vars("newid")

unique("doc:Person", ["John", "Smith"], newid)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  
<!-- idgen -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">idgen</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generate a new IRI from the prefix and concatention of the variables

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
idgen(Prefix, Vars, NewIRI) ~ idgenerator(Prefix, Vars, NewIRI) (Alias)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                         | Types                                                                | Requirement                |
|---------------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Prefix  </span>          | (string*) - A prefix for the IRI - typically formed of the doc prefix and the classtype of the entity ("doc:Person") | Mandatory       |
| <span class="param-type">Vars  </span>           | ([string*]) - An array of variables and / or strings from which the id will be generated   | Mandatory       |
| <span class="param-type">NewIRI  </span>           | (string*) - Variable in which the unique ID is stored   | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the ID generating function

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [newid] = vars("newid")

idgen("doc:Person", ["John", "Smith"], newid)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  

<!-- true -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">true</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

A function that always matches, always returns true

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
true()
```
</div>

<div class="anchor-sub-parts">Arguments</div>  
None

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the true value that will match any pattern

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
when(true()).triple("a", "b", "c")
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  
<!-- eq -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">eq</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Tests whether the two arguments are equal

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
eq(A, B) ~ equal(A, B) (Alias)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">A  </span>          | ([string] or literal*) - A variable or IRI or any literal (e.g. number, string) or basic datatype | Mandatory       |
| <span class="param-type">B  </span>          | ([string] or literal*) - A variable or IRI or any literal (e.g. number, string) or basic datatype  | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery object containing the ID that matches

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [nid] = vars("mike")
idgen("doc:mike", nid)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  
<!-- start -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">start</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Specifies an offset position in the results to start listing results from

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
start(Start, Subq)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  


| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Start  </span>      | (integer*) - A variable that refers to an interger or an integer literal (e.g. number, string) | Mandatory       |
| <span class="param-type">Subq  </span>       | (WOQLQuery*) - An array of variables and / or strings from which the id will be generated <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query
  | Mandatory       |



<div class="anchor-sub-parts">Returns</div>
A WOQLQuery whose results will be returned starting from the specified offset

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [a, b, c] = vars("a", "b", "c")

start(100).triple(a, b, c)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  
<!-- limit -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">limit</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Specifies a maximum number of results that will be returned from the subquery

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
limit(Limit, Subq)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Limit  </span>      | (integer/string*) - A variable that refers to an non-negative integer or a non-negative integer | Mandatory       |
| <span class="param-type">Subq  </span>       | A subquery whose results will be limited  <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery whose results will be returned starting from the specified offset

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [a, b, c] = vars("a", "b", "c")

limit(100).triple(a, b, c)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  

<!--path -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">path</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Performs a path regular expression match on the graph  

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
path(Subject, Pattern, Object, Path)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>    |(string*) - An IRI or variable that refers to an IRI representing the subject, i.e. the starting point of the path| Mandatory       |
| <span class="param-type">Pattern  </span>    | (string*) - A path regular expression describing a pattern through multiple edges of the graph <br/> Path regular expressions consist of a sequence of predicates and / or a set of alternatives, with quantification operators <br/> The characters that are interpreted specially are the following: <br/>  - representing alternative choices <br/> , - representing a sequence of predcitates <br/> + - Representing a quantification of 1 or more of the preceding pattern in a sequence <br/> {min, max} - Representing at least min examples and at most max examples of the preceding pattern <br/>* - Representing any predicate<br/>() - Parentheses, interpreted in the normal way to group clauses <br/>| Mandatory       |
| <span class="param-type">Object  </span>    |(string*) - An IRI or variable that refers to an IRI representing the object, i.e. ending point of the path| Mandatory       |
| <span class="param-type">Path  </span>    |(string*) - A variable in which the actual paths traversed will be stored| Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the path regular expression matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [person, grand_uncle, lineage] = vars("person", "grand uncle", "lineage")

path(person, ((father|mother) {2,2}), brother), grand_uncle, lineage)  
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  

<!-- order_by -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">order by</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Orders the results of the contained subquery by a precedence list of variables

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
order_by(...Ordervars, Subq)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Ordervars  </span>  | (string*) - A sequence of variables, by which to order the results, each optionally followed by either "asc" or "desc" to represent order | Mandatory       |
| <span class="param-type">Subq  </span>       | (WOQLQuery*) - The query whose results will be ordered  <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query | Mandatory       |



<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the ordering expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [person, last_name, first_name] = vars("person", "last name", "first name")

order_by(last_name, "asc", first_name, "desc")
    .triple(person, "first_name", first_name)
    .triple(person, "last_name", last_name)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->
<!-- group_by -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">group by</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Groups the results of the contained subquery on the basis of identical values for Groupvars, extracts the patterns defined in PatternVars and stores the results in GroupedVar

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
group_by(GroupVars, PatternVars, GroupedVar, Subq)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">GroupVars  </span>  | ([string] or string*) - Either a single variable or an array of variables | Mandatory       |
| <span class="param-type">PatternVars  </span>       | ([string] or string*) Either a single variable or an array of variables | Mandatory       |
| <span class="param-type">GroupedVar  </span>       | (string*) A variable | Mandatory       |
| <span class="param-type">Subq  </span>       | (WOQLQuery*) - The query whose results will be grouped <br/> <span class="status-comment"> Note: </span> Subq is an argument or a chained query | Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the grouping expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [age, last_name, first_name, age_group, person] = vars("age", "last name", "first name", "age group", "person")

group_by(age, [last_name, first_name], age_group)
    .triple(person, "first_name", first_name)
    .triple(person, "last_name", last_name)
    .triple(person, "age", age)

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->
<!-- cast -->


<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">cast</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Casts the value of Input to a new value of type Type and stores the result in CastVar

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
cast(Input, Type, CastVar) ~ typecast(InputVar, Type, CastVar) (Alias)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Input  </span>  | ([string] or literal*) - Either a single variable or a literal of any basic type | Mandatory       |
| <span class="param-type">Type  </span>       | Type ([string] or string*) Either a variable or a basic datatype (xsd / xdd) | Mandatory       |
| <span class="param-type">CastVar  </span>       | CastVar (string*) A variable | Mandatory       |


<div class="anchor-sub-parts">Returns</div>
 A WOQLQuery which contains the casting expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [time] = vars("time")

cast("22/3/98", "xsd:dateTime", time)

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->































# WOQL.js - the Definitive Guide

## WOQL.js and JSON-LD

WOQL uses JSON-LD and a formally specified ontology to define the language and to transmit queries over the wire.  WOQL.js is designed primarily to be as easy as possible for programmers to write because JSON-LD is itself tedious for humans to read and write. All WOQL.js queries are translated into the equivalent JSON-LD format for transmission over the wire.  The WOQL.js json() function can be used to translate any WOQL query from its JSON-LD format to and from it's WOQL.js equivalent (a WOQLQuery() object). If passed a JSON-LD argument, it will generate the equivalent WOQLQuery() object, if passed no argument, it will return the JSON-LD equivalent of the WOQLQuery(), in general the following semantic identity should always hold:

let wjs = new WOQLQuery().json(json_ld)
json_ld == wjs.json()

<hr class="section-separator"/>

<!--insert_class_data-->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">insert class data</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Inserts data about a class as a json object - enabling a class and all its properties to be specified in a single function

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

insert_class_data(Data, Graph)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

<table cellspacing="0" cellpadding="0">
  <tr><th>Arguments</th><th>Types</th><th>Requirement</th></tr><tr>
    <td class="param-type">Data</td>
    <td>
        (object*) a json object containing - an id and keys <br/>
        <span class="param-object">id (string*),</span> IRI or variable containing IRI of the class to be inserted <br/>
        <span class="param-object">*key* (string*), </span> keys representing properties that the class has (label, description, parent and any properties that the class has)
    </td>
    <td>Mandatory</td>
  </tr>
  <tr>
    <td class="param-type">Graph</td>
    <td>(string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)</td>
    <td>Optional</td>
  </tr>
</table>


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the insertion expression

<div class="anchor-sub-parts">Example</div>


<div class="code-example" markdown="1">
```js

let data = {
    id: "Robot",
    label: "Robot",
    parent: ["X", "MyClass"]
}


insert_class_data(data)
```
</div>

<hr class="section-separator"/>
<!--insert_doctype_data-->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">insert doctype data</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable</span>
</div>

<i class="fa fa-check status-stable"/>

Inserts data about a document class as a json object - enabling a document class and all its properties to be specified in a single function


<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

insert_doctype_data(Data, Graph)
```
</div>

<div class="anchor-sub-parts">Arguments</div>


<table cellspacing="0" cellpadding="0">
  <tr><th>Arguments</th><th>Types</th><th>Requirement</th></tr>
  <tr>
    <td class="param-type">Data</td>
    <td>
        (object*) a json object containing - an id and keys <br/>
        <span class="param-object">id (string*),</span> IRI or variable containing IRI of the class to be inserted <br/>
        <span class="param-object">*key* (string*), </span> keys representing properties that the class has (label, description, parent and any properties that the class has)
    </td>
    <td>Mandatory</td>
  </tr>
  <tr>
    <td class="param-type">Graph</td>
    <td>(string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)</td>
    <td>Optional</td>
  </tr>
</table>


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the insertion expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js

let data = {
    id: "Person",
    label: "Person",  
    age: {
        label: "Age",
        range: "xsd:integer",
        max: 1
    }
}
insert_doctype_data(data)
```
</div>














## Document Queries (Experimental / Unstable)

Document queries take or return entire JSON-LD document as arguments. This relies upon the internal frame-generation capabilities of the database and requires the user to have defined discrete document classes to dictate at what points the graph traversal is truncated - a document is considered to contain all objects within it, with the exception of predicates and classes that belong to other documents. This takes some care - improperly defined it can lead to very slow queries which contain the whole database unrolled into a single document - not normally what we require.   

<hr class="section-separator"/>
<!--update_object-->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">update object</span>
    <span class="anchor-status anchor-status-experimental"> Status: Experimental / Unstable </span>
</div>

<i class="fa fa-flask status-experimental"/>

Updates a document (or any object) in the db with the passed json-ld - replaces the current version

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

update_object(JSONLD)
```
</div>


<div class="anchor-sub-parts">Arguments</div>
<table cellspacing="0" cellpadding="0">
  <tr><th>Arguments</th><th>Types</th><th>Requirement</th></tr>
  <tr>
    <td class="param-type">JSONLD</td>
    <td>
        (string*) the document's JSON-LD form which will be written to the DB
    </td>
    <td>Mandatory</td>
  </tr>
</table>

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the update object expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js

let data = {
    "@id": "doc:joe",
    "@type": "scm:Person",
    "rdfs:label": {
        "@type": "xsd:string",
        "@value": "Joe"
    }
}

update_object(data)
```
</div>
