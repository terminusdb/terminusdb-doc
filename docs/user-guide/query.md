---
layout: default
title: Query
parent: User guide
nav_order: 2
---

# Query
{: .no_toc }

WOQL is the query language that works with TerminusDB. With its Prolog like logic, it is an elegant way to query data when you get the hang of it.

WOQL’s primary syntax and interchange format is in JSON-LD. However, you can use WOQLjs and WOQLpy package which is included in their corresponding API client to construct WQOL queries. Query using WOQLjs and WOQLpy is also available in TerminusDB console.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# WOQL - Web Object Query Language

The WOQL query language is a unified model query language. It allows us to treat our database as a document store or a graph interchangeably, and provides powerful query features which make relationship traversals easy.

WOQL's interchange format is written in JSON-LD. This gives us a relatively straightforward human-readable format which can also be easily stored in TerminusDB itself.

For example a simple query which returns every source, predicate and object in a database:

```json
{"@context" : {"@import": "https://terminusdb/contexts/woql/syntax/context.jsonld",
               "@propagate": true},
 "@type" : "Triple",
 "subject" : {"@type" : "Variable",
              "variable_name" : {"@type" : "xsd:string",
                                 "@value" : "Subject"}},
 "predicate" : {"@type" : "Variable",
                "variable_name" : {"@type" : "xsd:string",
                                   "@value" : "Predicate"}},
 "object" : {"@type" : "Variable",
             "variable_name : {"@type" : "xsd:string",
                               "@value" : "Object"}}}
```

This format is relatively verbose and inconvenient to write directly. However it is ideal for constructing programmatically in Python, Javascript or whatever your favourite language is. It's also possible to represent queries as graphs in Terminus, thereby allowing you to store and load queries which belong with your datasets.

---

# WOQL JSON-LD Encoding

The default imported JSON-LD context at [https://terminusdb/contexts/woql/syntax/context.jsonld](https://terminusdb/contexts/woql/syntax/context.jsonld) allows the syntax to be less verbose by automatically adding "@base", assuming that bare words are in the WOQL namespace. In addition some parameters of keywords are assumed to be identifiers and not strings.

```json
{"@context" :
 {"@version": 1.0,
  "@base": "http://terminusdb.com/schema/woql",
  "@vocab" : "#",
  "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
  "tcs" : "http://terminusdb.com/schema/tcs#",
  "owl" : "http://www.w3.org/2002/07/owl#",
  "xsd" : "http://www.w3.org/2001/XMLSchema#",
  "v" : "http://terminusdb.com/schema/woql/variable/",
  "terminus" : "http://terminusdb.com/schema/terminus#",
  "query_list" : {"@type" : "@id"},
  "query" : {"@type" : "@id"},
    ...
 }
}
```

---

# WOQLjs and WOQLpy

JSON, through an elegant way to pass queries to the database, it is not the most coding friendly. WOQLjs and WOQLpy provide a tool to construct WOQL queries with JavaScript and Python. They are included in their corresponding API client to construct WQOL queries. Query using WOQLjs and WOQLpy is also available in TerminusDB console. For details about WOQLjs and WOQLpy calls, please see the documentation of the API clients:

[JavaScript Client](https://terminusdb.github.io/terminus-client/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }[Python Client](https://terminusdb.github.io/terminus-client-python/){: .btn .fs-5 .mb-4 .mb-md-0 }

We assume most users will use WOQLjs or WOQLpy when constructing queries, hence most examples in this documentation will be in WOQLjs and/or WOQLpy.

---

# Resources

In TerminusDB there are a number of different resources which can be
refered to or manipulated by queries. These include the following:

- Collections
 - References
  - Branches
  - Commits
 - Commit Graphs
 - Repository Metadata
- Graphs
 - Graph Filters
 - Graph Objects

In many different contexts we will have to describe the absolute or
relative locations of these objects, and so we have resource
identifiers which disambiguate which type of object we are referring
to and where the system can find it.

## Collections

A collection is a queryable object. However, not all collections are
created equal. Some collections are read-only, and some are writable.

For instance, you can write to a branch, but it makes no sense to
write to a commit, as a commit itself refers to a particular
update. You can, however, search a commit.

### References

References are (currently) either branches or commits. For some
operations it is necessary to have a genuine branch (for instance, you
can not update a commit), but for other operations either a branch or
commit object will do.

#### Branches

```
<account>/<dbid>/<repository>/branch/<branch_name>
```

The following is the full name of a branch, including the account,
database and repository in which it resides.

#### Commits

```
<account>/<dbid>/<repository>/commit/<branch_name>
```

This is the full reference to a commit. Using this reference will
allow you to do things such as search at this commit, or rebase from
this commit onto your current branch.

### Commit Graphs

```
<account>/<dbid>/<repository>/_commits
```

The Commit graph stores information about all commits that have been
made in a given branch. You can query this to find information about
historical updates, the author and time of these updates as well as
which branches exist.

### Repository Metadata

```
<account>/<dbid>/_meta
```

## Graphs

In the creation and deletion of graphs, as well as in querying (and
especially inserting/deleting) it is necessary to refer to the precise
graph which the user wants to update. We do this by specifying either
graph filters or graph objects.

### Graph Filters

```
<type>/<name>
<type>/{<name1>,<name2>,...}
<type>/*
{<type1>,<type2>,...}/*
{<type1>,<type2>,...}
*/*
```

A graph filter is a relative reference which allows the user to specify a collection of graphs from a given collection resource (generally the current query collection). The `<type>` must be drawn from the set `{instance,schema,inference}` which specifies precisely which variety of graph we are referring to.

We can either refer directly to the name of a graph, or some list of names or even just use the `*` as a wildcard.

### Graph Objects

```
<account>/<dbid>/<repository>/branch/<branch_name>/<type>/<graph_name>
<account>/<dbid>/<repository>/commit/<commit_id>/<type>/<graph_name>
```
A fully qualified graph object is referred to with its source branch name or commit id together with its type and name.

---

# Creating Schema

When creating a schema with WOQL, a `when` cause is used, it takes two arguments: the first argument is the condition that need to full fill to execute the second argument. With WOQLjs and WOQLpy, you may chain the executable query following `WOQL.when()` (in WOQLjs) or `WOQLQuery.when()` (in WQQLpy). In most cases in creating a schema, a condition is not required and thus the first argument will be `true`. for example in WOQLjs:

```js
WOQL.when(true).and(
    WOQL.doctype("Station")
        .label("Bike Station")
        .description("A station where bicycles are deposited"),
    WOQL.doctype("Bicycle")
        .label("Bicycle"),
    WOQL.doctype("Journey")
        .label("Journey")
        .property("start_station", "Station")
            .label("Start Station")
        .property("end_station", "Station")
            .label("End Station")
        .property("duration", "integer")
            .label("Journey Duration")
        .property("start_time", "dateTime")
            .label("Time Started")
        .property("end_time", "dateTime")
            .label("Time Ended")
        .property("journey_bicycle", "Bicycle")
            .label("Bicycle Used")
)
```

### Document objects

The executable queries can be constructed with the help of the WOQL query objects. Usually there document objects with labels and descriptions can be easily constructed with a chain of call like:

``` js
WOQL.doctype("Station")
    .label("Bike Station")
    .description("A station where bicycles are deposited")
```

However, labels and descriptions are optional. The minimum way of creating a document object would be `WOQL.doctype("idOfObj")`

### Properties

Properties can also be chained to the document objects in WOQLjs and WOQLpy, for example in WOQLjs:

``` js
WOQL.doctype("Journey")
    .label("Journey")
    .property("start_station", "Station")
        .label("Start Station")
```

Properties will take an extra argument for the range of the property - it could be a datatype e.g. dateTime, string, integer, double, etc; or an other document object. label and descriptions can also be added to properties in similar manner as doctype objects.

### Subclases

To created a subclass structure in TerminusDB graph,`add_quad` can be used. For example:

``` js
WOQL.add_quad("child", "subClassOf", "parent", "schema")
```

For details regarding WOQL query objects in API clients, please refer to [API Reference](/docs/api-reference/)

---

# Loading Data into Database

---

# Querying Database

---
