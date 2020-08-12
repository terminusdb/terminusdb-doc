---
layout: default
title: WOQL Primitives
parent: WOQL.js - the Definitive Guide
grand_parent: Reference
nav_order: 5
permalink: /reference/woql/primitives
---
<i class=" js-toggle-dark-mode fa fa-toggle-on"/>

<script>
const toggleDarkMode = document.querySelector('.js-toggle-dark-mode');

jtd.addEvent(toggleDarkMode, 'click', function(){
  if (jtd.getTheme() === 'dark-mode-preview') {
    jtd.setTheme('just-the-docs');
    toggleDarkMode.textContent = 'Default';
  } else {
    jtd.setTheme('dark-mode-preview');
    toggleDarkMode.textContent = 'Dark Mode';
  }
});
</script>


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



### List Processing

<!--member-->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">member</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Matches if List includes Element

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
member(Element, List)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Element  </span>    | (string or literal*) - Either a variable, IRI or any simple datatype | Mandatory       |
| <span class="param-type">List  </span>       | List ([string, literal] or string*) Either a variable representing a list or a list of variables or literals | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the List inclusion pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [name] = vars("name")

member(name, ["john", "joe", "frank"])

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->
<!-- length -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">length</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Matches or generates the length of a list  

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
length(List, Len)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">List  </span>       |([string, literal] or string*) Either a variable representing a list or a list of variables or literals | Mandatory       |
| <span class="param-type">Len  </span>       |(string or integer) A variable in which the length of the list is stored or the length of the list as a non-negative integer | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Length pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [count] = vars("count")

length(["john", "joe", "frank"], count)  

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->
### String Processing

<!-- concat -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">concat</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Concatenates the List into a string and matches / stores the result in Concatenated


<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
concat(List, Concatenated)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">List  </span>       |([string] string*) - a variable representing a list or a list of variables or strings - variables can be embedded in the string if they do not contain spaces| Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Concatenation pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [first_name, last_name, full_name] = vars("first", "last", "full")

concat([first_name, " ", last_name], full_name)  

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->
<!-- trim -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">trim</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

A trimmed version of Untrimmed (with leading and trailing whitespace removed) is stored in Trimmed   


<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
trim(Untrimmed, Trimmed)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Untrimmed  </span>  |(string*) - A string or variable containing the untrimmed version of the string| Mandatory       |
| <span class="param-type">Trimmed  </span>    |(string*) - A string or variable containing the trimmed version of the string| Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Trim pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [trimmed] = vars['trimmed']

trim("hello   ", trimmed)
//trimmed contains "hello"

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->     
<!-- substr -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">substr</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generates a Substring From String, starting from Begin offset, of length Length, with After Number of characters after the substring

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
substr(String, Before, Length, After, SubString) ~ substring(String, Before, Length, After, SubString) (Alias)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">String  </span>     |(string*) - String or variable representing the full string           | Mandatory       |
| <span class="param-type">Before  </span>     |(string or integer*) Integer or variable representing the number of characters from the start to start the substring from| Mandatory       |
| <span class="param-type">Length  </span>     |(string or integer*) Integer or variable representing the number of characters in the substring| Mandatory       |
| <span class="param-type">After  </span>      |(string or integer*) Integer or variable representing the number of characters from the end to end the substring from| Mandatory       |
| <span class="param-type">SubString  </span>  |(string*) - The substring matched according to the values specified in the other arguments| Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Substring pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [trimmed] = ['trimmed']

substr("helloIAmTerminusDb", 8, 8, 2, )
//trimmed contains "hello"

```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->     


<!-- upper -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">upper</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generates or matches an upper-case version of String in Capitalized

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
upper(String, Capitalized)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">String  </span>     |((string*) - string or variable representing the uncapitalized string         | Mandatory       |
| <span class="param-type">Capitalized  </span>     |(string*) - string or variable representing the capitalized string| Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Upper case pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [allcaps] = vars("caps")

upper("aBCe", allcaps)
//upper contains "ABCE"
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->     

<!--lower-->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">lower</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generates or matches a lower-case version of String in LowerCased

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
lower(String, LowerCased)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">String  </span>     |(string*) - string or variable representing the non-lowercased string | Mandatory       |
| <span class="param-type">LowerCased  </span> |(string*) - string or variable representing the lowercased string     | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Lower Case pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [lower] = var("l")

lower("aBCe", lower)
//lower contains "abce"
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->     

<!-- pad -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">pad</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Pads out the string Input to be exactly Len long by appending the Pad character the necessary number of times to form Output

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
pad(Input, Pad, Len, Output)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Input  </span>     |(string*) - The input string or variable in unpadded state | Mandatory       |
| <span class="param-type">Pad  </span>       |(string*) - The characters to use to pad the string or a variable representing them     | Mandatory       |
| <span class="param-type">Len  </span>       |(string or integer*) - The variable or integer value representing the length of the output string | Mandatory       |
| <span class="param-type">Output  </span>    |(string*) - The variable or string representing the padded version of the input string | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Pad pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [fixed] = vars("fixed length")

pad("joe", " ", 8, fixed)
//fixed contains "joe     "
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->    

<!-- split -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">split</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Splits a string (Input) into a list strings (Output) by removing separator  

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
split(Input, Separator, Output)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Input  </span>     |(string*) - A string or variable representing the unsplit string | Mandatory       |
| <span class="param-type">Separator  </span> | (string*) - A string or variable containing a sequence of charatcters to use as a separator | Mandatory       |
| <span class="param-type">Output  </span>    |(string, [string]) - A variable representing a list, or a list of variables and / or strings | Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Split pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [words] = vars("words")

split("joe has a hat", " ", words)
//words contains ["joe", "has", "a", "hat"]
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->    
<!--- join -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">join</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Joins a list variable together (Input) into a string variable (Output) by glueing the strings together with Glue

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
join(Input, Glue, Output)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Input  </span>     | (string / [string]*) - a variable representing a list or a list of strings and / or variables | Mandatory       |
| <span class="param-type">Glue  </span> | (string*) - A variable or string representing the characters to put in between the joined strings in input | Mandatory       |
| <span class="param-type">Output  </span>    |(string*) - A variable or string containing the output string | Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Join pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [sentence] = vars("sentence")

join(["joe", "has", "a", "hat", " ", sentence)
//sentence contains ["joe has a hat"]
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->   

<!-- re -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">re</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Matches the regular expression defined in Patern against the Test string, to produce the matched patterns in Matches

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
re(Pattern, Test, Matches) ~ regexp(Pattern, Test, Matches) (Alias)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Pattern  </span>     | (string*) - string or variable using normal PCRE regular expression syntax with the exception that special characters have to be escaped twice (to enable transport in JSONLD) | Mandatory       |
| <span class="param-type">Test  </span> |(string*) - string or variable containing the string to be tested for patterns with the regex | Mandatory       |
| <span class="param-type">Matches  </span>    |(string / [string]) - variable representing the list of matches or a list of strings or variables
| Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Regular Expression pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [e, llo] = vars('e', 'ello')

WOQL.re("h(.).*", "hello", [e, llo])
//e contains 'e', llo contains 'llo'
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->   

<!-- like -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">like</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Generates a string Leverstein distance measure between StringA and StringB

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
like(StringA, StringB, Distance)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">StringA  </span>     | (string*) - string literal or variable representing a string to be compared | Mandatory       |
| <span class="param-type">StringA  </span> |(string*) - string literal or variable representing the other string to be compared | Mandatory       |
| <span class="param-type">Distance  </span>    |(string / [float]*) - variable representing the distance between the variables
| Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Like pattern matching expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
let [dist] = vars('dist')

like("hello", "hallo", dist)
//dist contains 0.7265420560747664
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->   


### Updates / Transactions

<!-- add_triple -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">add triple</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Adds a single triple to the database

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
add_triple(Subject, Predicate, Object)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>     | (string*) - The IRI of a triple's subject or a variable             | Mandatory       |
| <span class="param-type">Predicate  </span>   |(string*) - The IRI of a property or a variable                      | Mandatory       |
| <span class="param-type">Object  </span>      |(string*) - The IRI of a node or a variable, or a literal            | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the add_triple insert statement

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
add_triple("john", "age", 42)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->   

<!-- add_quad -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">add quad</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Adds a single triple to the specified graph in the database

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
add_quad(Subject, Predicate, Object, Graph)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>     | (string*) - The IRI of a triple's subject or a variable             | Mandatory       |
| <span class="param-type">Predicate  </span>   |(string*) - The IRI of a property or a variable                      | Mandatory       |
| <span class="param-type">Object  </span>      |(string*) - The IRI of a node or a variable, or a literal            | Mandatory       |
| <span class="param-type">Graph  </span>       |(string*) - The resource identifier of a graph                       | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the add_quad insert statement

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
add_quad("Person", "type", "owl:Class", "schema/main")
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->   

<!-- delete_triple -->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">delete triple</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Deletes a single triple from the default graph of the database

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
delete_triple(Subject, Predicate, Object)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>     | (string*) - The IRI of a triple's subject or a variable             | Mandatory       |
| <span class="param-type">Predicate  </span>   |(string*) - The IRI of a property or a variable                      | Mandatory       |
| <span class="param-type">Object  </span>      |(string*) - The IRI of a node or a variable, or a literal            | Mandatory       |


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Triple Deletion statement

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
delete_triple("john", "age", 42)
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->   
<!--  delete_quad -->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">delete quad</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Deletes a single triple from the default graph of the database  

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js
delete_quad(Subject, Predicate, Object, Graph)
```
</div>


<div class="anchor-sub-parts">Arguments</div>  

| Arguments                                    | Types                                                                | Requirement                |
|----------------------------------------------|----------------------------------------------------------------------|----------------------------|
| <span class="param-type">Subject  </span>     | (string*) - The IRI of a triple's subject or a variable             | Mandatory       |
| <span class="param-type">Predicate  </span>   |(string*) - The IRI of a property or a variable                      | Mandatory       |
| <span class="param-type">Object  </span>      |(string*) - The IRI of a node or a variable, or a literal            | Mandatory       |
| <span class="param-type">Graph  </span>       |(string*) - The resource identifier of a graph                       | Mandatory       |

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the Delete Quad Statement

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js
delete_quad("Person", "type", "owl:Class", "schema/main")
```
</div>

<hr class="section-separator"/>

<!----------------------------------------------------------------------------------------->  
    
