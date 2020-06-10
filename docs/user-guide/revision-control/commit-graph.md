---
layout: default
title: The Commit Graph
parent: Revision Control
grand_parent: User guide
nav_order: 1
---

# The Commit Graph
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Introduction
In TerminusDB, every operation that updates the state of a database generates a _commit_ record which allows us to recreate the state of the database exactly as it was at the time that the update was completed. Commit records and their associated metadata (timestamps, comments and designation of authorship) can be accessed through a special internal graph called the commit graph within each database.   Just like everything else in TerminusDB, this commit data is exposed as a graph which can be queried just like any other graph.

There are three things that make the _commit_ graph special and different from normal TerminusDB data and schema graphs: 

1. In normal usage it is immutable and append only and never written directly to by the user, but only by the internal database engine (*) 
1. Unlike normal data and schema graphs, it is not itself versioned because it contains it's full history within it.
1. It has a very simple, pre-defined schema consisting of two principle object types (Branch & Commit) and 5 main properties (timestamp, parent, author, message, head)

TerminusDB provides a simple history query library, covered in the next section on time-travelling which provides simple-pre-rolled queries which will extract all of the important information needed to support revision control operations for you, and a simple time-slider UI in the console which does all the work for you, so in the vast majority of use-cases, you will never have to look inside the commits graph or worry about its structure.  

So, while it is not absolutely necessary to understand the structure of the commit graph to use the various revision control operations, itcan be helpful to have a mental model, and very helpful to query the graph itself to understand what actually happened in these operations. This section provides full details of the data structures and queries that are used in the _commit_ graph with enough detail that you should be able to construct your own custom revision control queries from scratch. 

## Commit Chains - the basic data structure

# Diagram Explanation

[ Picture: diagram shows commit parent and branch and how they point at commit ]

Table shows all properties that exist in the commit graph

---


# Revision Control Queries

Translating results from _commit_ graph queries into actual revision control operations is very simple. 
We first query the _commit_ graph to find the ID of the specific commit that we are interested in (maybe by a certain author or at a certain time). This ID can then used to parameterise the revision control operation we are interested in. 

So, for example, the following operations can be parameterised by results from queries to the _commit_ graph:

### Setting Head in WOQL client: 

woqlClient.ref(CommitID)
woqlClient.checkout(branch)

1. Branch() => defines the starting point of a new branch (new branches can start from either the head of a branch or from any specific commit (commit ID)

2. Merge(...)

### Forming Resource String Manually

(using)

It should be noted that internally in TerminusDB, a commit ID refers to a very complex structure which actually contains all of the relevant historical data, if you are interested in the internal data structures, they are fully documented in the Full Architecture section and associated papers. However from a user point of view, all you have to know is Commit IDs allow you to set the state of the database to exactly the state that it was when the related update completed and queries to the _commit graph_ allow you to find the Commit IDs that you are interested in.  

## Other Contents of Commit Graph - Database Level Meta-data

(stored here because some things have to have global database scope and we don't want to change them on branches etc as it makes things too complicated

* prefixes
* graph structure

### Notes
* Administrators can choose to active the write_to_commit_graph capability which will allow them to manually rewrite the commit graph, however, direct updates of the commit graph are completely unsupported and highly inadvisable as the chance of breaking 
the internal delicate datastructures that lie beneath is extremely high. If you choose to do so, proceed with caution and assume that you will destroy everything. 



