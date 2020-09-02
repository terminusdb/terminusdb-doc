---
layout: default
title: WOQL Query Guide in Python
parent: Python How Tos
grand_parent: How Tos
nav_order: 1
---

# WOQL Query Guide in Python
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Get an Edge

TerminusDB is a graph database, so we represent all data as edges. An
edge is either a link from one node to another, or a link from a
node to some data.

In order to query data we need to first have some data to query. You
can get a *fairly big* database by running the following database by
cloning using the following script (Note: this might take a few
minutes as DBPedia is quite large!)

```python
from terminusdb_client import WOQLClient
from terminusdb_client import WOQLQuery as WQ

server_url = "https://127.0.0.1:6363"
db = "dbpedia"
user = "admin"
account = "admin"
key = "root"
remote_database = "https://hub.terminusdb.com/gavin/dbpedia"
client = WOQLClient(server_url)
client.connect(user=user, account=account, key=key, db=db)

new_db = "dbpedia_copy"
client.remote_auth({ "type" : "basic",
                     "user" : user,
                     "key" : key})
client.clonedb({ "remote_url" : f"{remote_database}",
                 "comment" : "DBpedia",
                 "label" : "DBpedia"},
               new_db)
```
If you've managed to get this downloaded, you can use the same same client for
the remaining queries.

In the python SDK, you can get a single edge as follows:

```python
result = WQ().limit(4).triple("v:X", "v:P", "v:Y").execute(client)
```
This query asks for *every* edge in the graph, limiting to the first 10 results.

The `v:` means that `X`, `P`, and `Y` are considered to be variables.

As it turns out, the first results are edges that have to do with the
American punk band "chk-chk-chk" (or `!!!`).

The result of the query is the following *typical* binding return form:

```python
{'@type': 'api:WoqlResponse',
 'api:status': 'api:success',
 'api:variable_names': ['X', 'P', 'Y'],
 'bindings': [{'P': 'http://dbpedia.org/ontology/activeYearsStartYear',
               'X': 'http://dbpedia.org/resource/!!!',
               'Y': {'@type': 'http://www.w3.org/2001/XMLSchema#gYear',
                     '@value': '1996'}},
              {'P': 'http://dbpedia.org/ontology/alias',
               'X': 'http://dbpedia.org/resource/!!!',
               'Y': {'@language': 'en', '@value': 'Chk Chk Chk'}},
              {'P': 'http://dbpedia.org/ontology/associatedBand',
               'X': 'http://dbpedia.org/resource/!!!',
               'Y': 'http://dbpedia.org/resource/Maserati_(band)'},
              {'P': 'http://dbpedia.org/ontology/associatedBand',
               'X': 'http://dbpedia.org/resource/!!!',
               'Y': 'http://dbpedia.org/resource/Out_Hud'}],
    'deletes': 0,
    'inserts': 0,
    'transaction_retry_count': 0}
```

This object has a number of features. The first is the `@type` which
states that this is the result of a WOQL query. The second is that it
was successful (rather than an error).

The third field is where it starts to get interesting. Here we have
the variables which were bound in the query. These variables are
*in-order*, in a way that can be fixed with the `WQ().select` call or
simply by the in-order use in the query.

The next field is the most important. The `bindings` hold the variable
values for each solution to the query. If you are familiar with SQL
you can think of this as the rows of the query solution.

Finally you find `deletes`, `inserts` and `transaction_retry_count`,
all of which have to do with *updates* to the graph.

The bindings are of two different types. Those that end with a *node*
and those that end with a *literal*. Nodes are represented by URIs,
such as the final result:
`'http://dbpedia.org/resource/Out_Hud'`. Values are represented by a
dictionary that give the *type* as `@type` and the *value* as
`@value`.

## Connect the dots

Nodes can appear at either the beginning of an edge, or at the end of
an edge. We can chain such edges together as follows:

```python
result2 = WQ().limit(1).woql_and(
  WQ().triple("v:Original_Band","scm:associatedBand","v:Associated_Band"),
  WQ().triple("v:Associated_Band","scm:associatedBand","v:Two_Hop_Band")
).execute(client)
```

This query finds the first result of an associated band that also has
an associated band. This kind of query is where graph-databases really
shine - the multihop query.  We say that we want to follow one edge,
and then the next by reusing the variable name `"v:Associated_Band"`
twice.

Visually you might think of this as:

```
"V:Original_Band" - "scm:associatedBand"-> "v:Associated_Band" -scm:associatedBand"-> "v:Two_Hop_Band"
```

We say that the two `"v:Associated_Band"` variables *unify*. That is,
we treat the variables as the same element in every solution whenever
the same variable is used repeatedly.

But if you look at the results, you'll see that we've actually just
gone and found `!!!` again. This isn't surprising since one would
expect the notion of an "associated" band to be reflexive. Two
different variables are not required to have *different values*.

We can specify that we don't want to see the same value in the two
different variables with the following query:

```python
result2 = WQ().limit(1).woql_and(
  WQ().triple("v:Original_Band","scm:associatedBand","v:Associated_Band"),
  WQ().triple("v:Associated_Band","scm:associatedBand","v:Two_Hop_Band"),
  WQ().woql_not().eq("v:Two_Hop_Band", "v:Original_Band")
).execute(client)
```

This query asks for any two-hop-band which isn't the original band.

Now the result for our `"v:Two_Hop_Band"` is
`'http://dbpedia.org/resource/Headlights_(band)'` which is a less
degenerate answer.

## Paths

The above approach allows us to make arbitrary graph shapes by simply
naming various nodes of the graph with the same variable. However, we
can only specify shapes which we know completely.

What if we want to answer a general question, such as, what bands can
I reach in N hops. We could of course make a separate query for each
of the N hop solutions, but more convenient is to use a `path` query.

```python
result3 = WQ().limit(2).path(
            "v:Original_Band",
            "scm:associatedBand+",
            "v:Final_Band",
            "v:Path"
        ).execute(client)
```

This query will bind `Original_Band` and `Final_Band` to any bands
that are connected by any number of hops on `scm:associateBand`,
greater than 1. We follow a syntax which should be familiar to anyone
who has used regular expressions, and which includes grouping:
`(my_pattern)`, wildcards: `foo*` or `foo+` and disjunction `foo|bar`.

The path query also stores the result of the path in `Path`, the final
argument. This allows you not only to know that the nodes are
connected, but *how* they are connect.

## Updates and Inserts

No database query language is complete without the ability to change
the stored data. You can add yourself to the DBpedia database with a
query similar to the following:


```python
WQ().add_triple("doc:gavin_mendel_gleason", "scm:name", "Gavin Mendel-Gleason").execute(client)
```

This will create a resource on the default prefix base with the
default schema predicate named `name`, and having the concrete string
value "Gavin Mendel-Gleason".

But if you don't want it to be there anymore, you can remove it.

```python
WQ().delete_triple("doc:gavin_mendel_gleason", "scm:name", "Gavin Mendel-Gleason").execute(client)
```

And if you added `"doc:gavin_mendel_gleason"` and couldn't remember
what name he had, you could delete it as follows:

```python
WQ().woql_and(
   WQ().triple("doc:gavin_mendel_gleason", "scm:name", "v:X"),
   WQ().delete_triple("doc:gavin_mendel_gleason", "scm:name", "v:X")
).execute(client)
```

You can in fact search for arbitrary bindings, and delete or insert
based on them.

## String Matching

The python SDK for WOQL allows basical string manipulation as
well. You can search for an object which has a property with a given
string as follows:

```python
limit(1)
  .and(
    triple("v:X", "scm:name", "v:Y"),
    re(".*cholera.*", "v:Y", ["v:All"])
  )
```

This will let you search for an arbitrary regexp in the last value of
a string.  In the DBpedia dataset, this gives you back the node:
`http://dbpedia.org/resource/1817–1824_cholera_pandemic` which you can
then investigate further.

You can use arbitrary regular expressions, and the matching groups
will be bound to the variables in the final list of `re`.

## Mathematics

You can also do basic mathematical manipulations.

```python
WQ().eval(WQ().plus(1,2), "v:X").execute(client)
```

This binds "v:X" to the result of the addition of `1` and `2`. You can
use variables in place of `1` and `2` and re-use `"v:X"` in later
queries. The complete definiation of mathematical operators is in the
python-client reference documentation.


