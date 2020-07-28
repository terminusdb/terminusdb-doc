---
title: WOQL 
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

Fluent Style

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
    

WOQL.js and JSON-LD


Primitives
Compound Functions
Schema Functions
Library Functions
