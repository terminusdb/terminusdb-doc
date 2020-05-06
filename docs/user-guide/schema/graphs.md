---
layout: default
title: Graphs
parent: Schema
nav_order: 5
---

1. TOC
{:toc}

---

## Introduction

Internally, each TerminusDB database is divided into a number of different named graphs.Named graphs are just buckets in which we can store different types of data.  In TerminusDB there are three different types of graph: 

1. Instance Data Graph
2. Schema Graph
3. Inference Graph

## Instance Data Graph

The instance data graph is where ordinary data is stored as RDF triples. The default instance data graph is instance/main. Databases can be configured to have multiple instance graphs and updates and queries can be routed to any combination of these instance graphs. In the most common configuration, each database will have exactly one instance graph called main. 

## Schema Graph

Each database can have one or more schema graphs configured. The default schema graph is schema/main. Schema graphs are special, because any data written to an instance graph in the database must obey the rules defined in the schema graph(s) of the database. The schema is defined in OWL, interpreted in a closed world, unique name reasoning regime. In the most basic configuration, a database will have a single schema graph, defining the properties and classes used in that database. Adding extra schema graphs is most useful in supporting loaing of schemas as libraries for reuse. For example, we can load the xdd (extended datatypes library) in its own schema graph.   

## Inference Graph

TerminusDB databases can be configured to have one or more inference graphs. Inference graphs consist of a set of OWL statements which will be interepreted dynamically in an open world regime, to generate dynamic predicates. In most common configurations, there is no inference graph. The internal terminus administration database does have an inference graph consisting of a single predicate, which expresses resource inclusion.  

### Creating and Deleting Graphs

The TerminusDB API has endpoints for creating and deleting instance, schema and inference graphs. The Schema Page of the TerminusDB Console also allows users to view, create and delete graphs.  

### WOQL.js

<div class="code-example">

```js
WOQLClient.createGraph("schema", "xdd", "Adding XDD Library Graph")
WOQLClient.createGraph("inference", "magic", "Creating Dynamic Properties")
WOQLClient.deleteGraph("inference", "magic", "Thought better of it")
```
</div>

