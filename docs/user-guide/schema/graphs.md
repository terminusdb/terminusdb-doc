---
layout: default
title: Graphs
parent: Schema
nav_order: 5
---
# Graphs

1. TOC
{:toc}

---

## Introduction - Triples, Quads and (Named) Graphs

In RDF everything is a `subject - property - object` triple. The major benefit of this formulation is that we can achieve a naturally interlinked graph just by virtue of some triples having the same object as the subjects of other triples, and vice versa. The major drawback is that we naturally interlink everything without discrimination. In practice, it is often useful to divide up an RDF triple-store into separate chunks that can be managed seperately, interpreted differently, and can be selectively integrated - or not - with the rest of the triples in the database. The concept of an order Graph being internally divided into multiple `Graphs`, often known as `Named Graphs` has been developed to address this problem.  They are a very simple concept - they allow you to store triples in different buckets, each identified by a name. 

When a triple-store uses named graphs to store data, we can think of it as consisting of quads instead of triples - ` subject - predicate - object - graph ` as each triple is associated with a specific graph.  Thus, for example, if we wanted to query a specific graph, rather than the default one, we might write: `WOQL.quad("v:Person", "dob", today, 'instance/birthdays')` to query a specific graph for data rather rather than the triple form: `WOQL.triple("v:Person", "dob", today)`. 

TerminusDB places no limits on the number of named graphs that can be created within a datbase but adopts simple defaults that support the most common use cases without requiring users to understand the deep details of the internal graph structures. Most users will never have to worry about anything except the difference between the schema graph and the instance data graph. 

## TerminusDB - Graph Types

Internally, each TerminusDB database is divided into a number of different named graphs. While named graphs are in general just buckets in which we can store different types of data.  In TerminusDB there are three different types of graph which define how the data within the graph will be interpreted 

1. Instance Data Graph
2. Schema Graph
3. Inference Graph

By default, in the TerminusDB console, databases are created with a single instance graph `instance/main` and a single schema graph `schema/main`. However, there is nothing mandatory about this configuration - databases can have no instance graphs or no schema graphs or multiple of each and they can be given whatever identifiers are desired.  

### Instance Data Graph

The instance data graph is where ordinary data is stored as RDF triples. The default instance data graph is instance/main. Databases can be configured to have multiple instance graphs and updates and queries can be routed to any combination of these instance graphs. In the most common configuration, each database will have exactly one instance graph called main. 

### Schema Graph

Each database can have one or more schema graphs configured. The default schema graph is schema/main. Schema graphs are special, because any data written to an instance graph in the database must obey the rules defined in the schema graph(s) of the database. The schema is defined in OWL, interpreted in a closed world, unique name reasoning regime. In the most basic configuration, a database will have a single schema graph, defining the properties and classes used in that database. Adding extra schema graphs is most useful in supporting loaing of schemas as libraries for reuse. For example, we can load the xdd (extended datatypes library) in its own schema graph.   

### Inference Graph

TerminusDB databases can be configured to have one or more inference graphs. Inference graphs consist of a set of OWL statements which will be interepreted dynamically in an open world regime, to generate dynamic predicates. In most common configurations, there is no inference graph. The internal terminus administration database does have an inference graph consisting of a single predicate, which expresses resource inclusion.  

## Addressing Graphs in Queries

In TerminusDB all graphs within a database can be addressed from WOQL queries, the following function allow users to explicitly select the graph being queried: 

* .using() .from() and .quad() allow users to specify graph filters for queries
* .into() .detete_quad() and .add_quad() allow users to specify graph identifiers for updates. 

### Setting Graph Filters for Queries

Graph filters either identify a specific graph by id (`type/id`) or identify all of a specific type of graph with a wildcard `schema/*`.  So, for example, the Query ```WOQL.quad("v:A", "v:B", "v:C", "schema/*")``` 
Will find all triples in all schema graphs for the current database. 

We can achieve the same effect with the *from()* function: 
```WOQL.from("schema/*").triple("v:A", "v:B", "v:C")```

Or the *using()* function (which allows us to specify any graph on the server - in any branch or db)
```WOQL.using("account/dbid/master/main/graph/schema/*").triple("v:A", "v:B", "v:C")```

Note that the default usage of WOQL.triple() is in fact just `WOQL.from("instance/*").triple()` or `WOQL.quad(,,,"instance/*")` 

### Setting Graph Identifiers for Updates

Functions which update graphs need to provide a specific graph identifier (e.g. schema/main, instance/main) and cannot use wildcards (because we need to know which specific graph to update). Otherwise, the use of graph identifiers is identifical to graph filters: 

<div class="code-example" markdown="1">

```js
WOQL.into("schema/main").add_triple()
WOQL.add_quad("a", "p", "c", "schema/main")
WOQL.delete_quad("a", "p", "c", "schema/main")
```
</div>

## Creating and Deleting Graphs

The TerminusDB API has endpoints for creating and deleting instance, schema and inference graphs. The Schema Page of the TerminusDB Console also allows users to view, create and delete graphs.  

### WOQL.js

<div class="code-example" markdown="1">

```js
WOQLClient.createGraph("schema", "xdd", "Adding XDD Library Graph")
WOQLClient.createGraph("inference", "magic", "Creating Dynamic Properties")
WOQLClient.deleteGraph("inference", "magic", "Thought better of it")
```
</div>

## Special Internal Graphs
In addition to the schema, instance and inference graphs within each database, each TerminusDB database contains two special graphs that contain the metadata about the graph structure and can be queried just like any other graph. 

The two special graphs are the `commits` graph which contains a record of all commits and branches that have been created in the history of the database, and a `repository` graph which contains a record of the origin of the graph, most importantly local and remote repository metadata which enables controlled remote collaboration.  In almost all circumstances, these graphs should not be directly updated except by the databases internal processes. However it is often useful to be able to query these graphs.  

### Commits Graph

The commits graph is addressed as `<accountid>/<dbid>/<repoid>/_commits`
Where accountid/dbid identifies the specific database, <repoid> identifies the repository within the database (e.g. local | remote) as different repo versions can have different commit historiers. 
  
The below example queries the commits graph to find the first and last commit in the master branch. 

The ref ontology defines the schema for the commit graph.

<div class="code-example" markdown="1">

```js

WOQL.using("me/mydb/local/_commits").and(
    WOQL.triple("v:Branch", "ref:branch_name", "master"),
    WOQL.triple("v:Branch", "ref:branch_base_uri", "v:Base_URI"),
    WOQL.opt().triple("v:Branch", "ref:ref_commit", "v:Head"),
    WOQL.opt().triple("v:Head", "ref:commit_id", "v:HeadID"),
    WOQL.opt().triple("v:Head", "ref:commit_timestamp", "v:Last"),
    WOQL.opt().and(
        WOQL.path("v:Head", "ref:commit_parent+", "v:Tail", "v:Path"),
        WOQL.not().triple("v:Tail", "ref:commit_parent", "v:Any"),
        WOQL.triple("v:Tail", "ref:commit_id", "v:TailID"),
        WOQL.triple("v:Tail", "ref:commit_timestamp", "v:First")
    )
)
```
</div>

### Repository Graph

The Repository Graph contains details about the distributed nature of the database. Each database is stored as a local repository and zero or more remote repositories, which represent the state of the database as seen through the various different versions that track each other. This allows the definition of complex dependencies between distributed teams. 

