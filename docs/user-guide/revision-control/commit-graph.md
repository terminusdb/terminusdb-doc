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
In TerminusDB every database has an internal graph called the _commit_ graph which TerminusDB uses to keep track of all operations which modify the state of the database, along with timestamps, comments and designation of authorship. In TerminusDB every transaction produces a commit, as does every api call which changes the state of the database (such as creating a new graph).  Just like everything else in TerminusDB, this commit data is exposed as a graph which can be queried just like any other graph. .

There are three things that make the _commit_ graph special and different from normal TerminusDB data and schema graphs: 

1. In normal usage it is immutable and append only and never written directly to by the user, but only by the internal database engine (*) 
1. Unlike normal data and schema graphs, it is not itself versioned because it contains it's full history within it.
1. It has a very simple, pre-defined schema consisting of two principle object types (Branch & Commit) and 5 main properties (timestamp, parent, author, message, head)

While it is not absolutely necessary to understand the structure of the commit graph to use the various revision control operations, it
can be helpful to have a mental model, and very helpful to query the graph itself to understand what actually happened in these operations.

TerminusDB provides a simple history query library, covered in the next section on time-travelling which provides simple-pre-rolled queries which will extract all of the important information needed to support revision control operations for you, and a simple time-slider UI in the console which does all the work for you, so in the vast majority of use-cases, you will never have to look inside the commits graph or worry about its structure.  

However, for those who are curious, or who want more complex custom ways of accessing revision history metadata, this section provides full details of the data structures and queries that are used with enough detail that you should be able to construct your own custom revision control queries from scratch. 

## Commit Chains - the basic data structure

# Diagram Explanation

[ Picture: diagram shows commit parent and branch and how they point at commit ]

Table shows all properties that exist in the commit graph

---


# Revision Control Queries

To carry out revision control operations, we first query the _commit_ graph to find the ID of the branch or transaction that we are interested in. This ID is then used to parameterise the revision control operation we are interested in. 

So, for example, the following operations can be parameterised by results from queries to the _commit_ graph:

### Setting Head in WOQL client: 

woqlClient.ref(CommitID)
woqlClient.checkout(branch)

1. Branch() => defines the starting point of a new branch (new branches can start from either the head of a branch or from any specific commit (commit ID)

2. Merge(...)

### Forming Resource String Manually

(using)

## Other Contents of Commit Graph - Database Level Meta-data

(stored here because some things have to have global database scope and we don't want to change them on branches etc as it makes things too complicated

* prefixes
* graph structure

### Notes
* Administrators can choose to active the write_to_commit_graph capability which will allow them to manually rewrite the commit graph, however, direct updates of the commit graph are completely unsupported and highly inadvisable as the chance of breaking 
the internal delicate datastructures that lie beneath is extremely high. If you choose to do so, proceed with caution and assume that you will destroy everything. 



