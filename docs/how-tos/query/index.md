---
layout: default
title: Query
parent: How Tos
nav_order: 7
has_children: true
permalink: /how-tos/query
---

# Query
{: .no_toc }

TerminusDB allows you to query graphs in either Javascript or
Python. This tutorial is about using Javascript, which is the method
which is available in the console.

## Open a Database
{: .fs-6 .fw-300 }

First you'll need a database which you can query. You can get started
by opening TerminusDB and going to the clone page.

From there you should select WordNet, and clone it to your local
machine.

Once you've cloned it, you should be opened up into the WordNet
database automatically. Click on the Query button.

## First steps
{: .fs-6 .fw-300 }

Graph databases are made up out of edges in a graph. You can query
these edges by using the word `triple` (a triple is a source node, a
named edge and a target node).  Now, the WordNet graph is fairly
large, so we'll also need to limit our queries to make sure we get
something manageable to look at. We can do that with `limit`.

Try out the following query in the query box:

```javascript
let [subject, predicate, object] = vars('subject','predicate','object')
limit(1).triple(subject,predicate,object)
```

This query just gets back any random edge without any constraints. But
graphs are about connections, so we should make a query that goes more
than one hop in order to find something interesting.

```javascript
let [subject, predicate1, intermediate, predicate2, object] =
    vars('subject','predicate1','intermediate','predicate2','object')
limit(1).triple(subject,predicate1,intermediate)
        .triple(intermediate,predicate2,object)
```

This is a two-hop query, so now we are actually exploring the graph a
bit. ... Something here ...

First, let's do a little exploration to see what is in the
database. As it turns out, predicates are not as common as source or
target nodes (subjects or objects).

We can see all of the predicates using the following query:

```javascript
let [subject, predicate, object] = vars('subject','predicate','object')
distinct(predicate)
    .select(predicate)
    .triple(subject,predicate,object)
```

This query selects only the `predicate`s (it masks out the other
variables) and ensures that we only get distinct `predicate`s.

## Viewing the schema

If you click on the schema tab, you'll be able to peruse the object
types and predicates which are available to you in any database which
uses a schema.

[image here]

There are several tabs, Classes, Properties, Graphs, Triples and
Prefixes. The Triples tab will give you access to the raw OWL schema
information, which is also editable.

[image here]

But for our purposes we just need to know what properties are
available.

##

## Combining Queries
{: .fs-6 .fw-300 }

The basic building block of a query in TerminusDB is the triple. In
order to combine them we tend to build up graph fragments in which we
use the same variable at each node that we want to be the same. We
then combine these triples with `and`.  We call this repeated variable
use for matching *unification*.

First let us look at the `ontolex:writtenRep` predicate which gives us
the written representation of a word.

```javascript
let [subject, word] = vars('subject','word')
limit(10)
      .triple(subject,'ontolex:writtenRep',word)
```


```javascript
let [subject, predicate, object]
    = vars('subject','word', 'definition', 'x', 'lemma',
           'base_lemma',''
      )
limit(10).select(word,definition).and(
    triple("v:PWN", "wn:partOfSpeech", "v:Part_Of_Speech"),
    triple("v:_Blank2", "rdf:value", "v:Definition")
)
```


## More about queries
{: .fs-6 .fw-300 }
