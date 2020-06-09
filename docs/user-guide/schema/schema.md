---
layout: default
title: Schema
parent: User guide
nav_order: 3
has_children: true
permalink: /user-guide/schema
---

# Code
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Introduction

Schemas are a very important part of TerminusDB. They allow you to define the shape that your data can take in such a way that TerminusDB will enforce the rules - preventing you from saving broken data to your database. 

Having to define a schema for your data does impose a certain amount of cost in advance for users. However, in the long run, the trade off is very much worth it. The earlier in the process that you identify errors in your data, the cheaper and easier it is to fix those errors. If your database allows you to write any old data to it, it becomes very difficult and expensive to clean it up subsequently. Many RDF based databases suffer terribly from the problem of not having adequate schemas defined in advance, meaning that they are in practice 'triple-soup' - an unmanageable mess of fragments of data which have no defined shape and are almost useless in practice. Thus we are strong advocates of defining schemas in advance. Without a schema it's not a real database, just a collection of random data fragments that have no defined interpretation. 

However, in certain cases, this can be overkill - for example, when you are first experimenting with a new project, it can be considerably offputting to have to nail things down in advance - you don't know what exact shape the data should take until you've tried out a few different options. Therefore, TerminusDB also supports schema-free databases which allow you to save any data without restrictions. This does limit the features of the system that you can use - for example, subsumption can only work if there is a defined class hierarchy in the schema. Thus, schema-free databases cannot use the more advanced features of the WOQL query language. Still they can be queried and written to using the basic structures of WOQL such as triple, path, etc.    

---

## Schema Definition Language

Under the hood, TerminusDB uses <a href="schema/advanced">OWL, the Web Ontology Language</a> for defining its schema.  OWL is a very rich and expressive language which allows you to encode a vast amount of business logic and rules in the schema itself. Furthermore, it has a solid mathematical basis, meaning that the definitions are precise and formally verifiable by reasoners. It is by some way, the most sophisticated data description standard that humankind has thus produced. However, it has a couple of major problems. Firstly, it lacks much in the way of tool support - using native OWL tools is a painful expreience. Secondly, it was defined as having only an 'open world' interpretation which is of limited use in practice. 

Therefore, although TerminusDB uses OWL under the hood, our interpretation is a standard, ordinary closed world one when using it for schema checking. We also support open world interpretations, via an inference graph - which supports almost all of the sophisticated reasoning capabilities of the language. Furthermore, rather than using OWL directly, in TerminusDB we typically use our programming language query composers WOQL.js and WOQL.py for actually defining schemas. These hide a lot of the syntactic complexity of the language and allow you to define your schema in familiar ways, using simple syntax. 

---

## Schema Constructs

### Classes

In the TerminusDB schema, classes are used to define the shapes of the data structures that we store in the database. Every fragment of data saved in the database is associated with a particular type and this type is defined by it's class definition in the schema. Classes are relatively simple structures - but they can be combined in a variety of ways to produce complex results. <a href="schema/classes"> More </a>

---

### Properties

In a TerminusDB schema, there are objects, defined by classes, and these objects can have attributes associated with them which are defined by proprties in the schema.  TerminusDB provides a wide range of prebuilt property types. <a href="./properties">See More</a>

---

### Datatypes

Not everything is an object. In addition to supporting sophisticated class and object hierarchies, TerminusDB also support a wide range of simple datatypes from the generic - strings, different types of numbers - to the advanced: built in coordinate data types, built-in uncertainty range primitive datatypes. <a href="schema/datatypes"> Read More </a>

---

### IRIs, URLs, IDs and Prefixes

If we want to easily integrate data from different sources, unique identifiers and namespaces are particularly useful - TerminusDB is based on OWL which uses RDF triples to store all data as IRIs. In most cases you won't need to know the details of these IRIs and URLs that are used under the hood, but it is always useful to put some thought into choosing identifiers wisely and TerminusDB offers a lot of support for solving this problem. <a href="schema/ids">Read More</a>

---

### Graphs - Schema - Instance & Inference

Graphs (or Named Graphs) are internal structures that TerminusDB can use to segregate different parts of the database from one another. At the most basic level, TerminusDB has three types of graphs - instance graphs which are where we store ordinary data as RDF triples. Schema graphs are where we store rules governing the shape of the data while inference graphs are where we can encode complex runtime inference rules - both schema and inference graphs speak OWL. <a href="schema/graphs">Read More </a>

---

### Advanced - OWL Unleashed

TerminusDB supports a large fragment of the OWL language as both a schema and inference language. This enables a large number of complex constraints to be expressed in a wide variety of different ways. For most users, simple class hierarchies and properties are more than enough for their data modelling requires, but for advanced users who wish to build complex business rules into their data flows, there is no substitute for pure logical axiom writing in OWL. <a href="schema/advanced">Read More</a>

