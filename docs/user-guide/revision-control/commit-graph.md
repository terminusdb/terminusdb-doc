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

In TerminusDB, every operation that updates the state of a database generates a _Commit Record_ which allows us to recreate the state of the database exactly as it was at the time that the update was completed. Commit records and their associated metadata (timestamps, comments and designation of authorship) can be accessed through a special internal graph called the _commit graph_ within each database.   Just like everything else in TerminusDB, this commit data is exposed as a graph which can be queried just like any other graph.

There are three things that make the _commit_ graph special and different from normal TerminusDB graphs:

1. In normal usage it is immutable and append only and never written directly to by the user, but only by the internal database engine (*)
1. Unlike normal data and schema graphs, it is not itself versioned
1. It has a very simple, pre-defined schema consisting of two principle object types (Branch & Commit) and 5 main properties (timestamp, parent, author, message, head)

TerminusDB provides a simple query library, covered in the following sections, which provides simple-pre-rolled queries which will extract all of the important information from the _commit graph_ needed to support revision control operations for you, and a simple time-slider UI in the console which does all the work for you, so in the vast majority of use-cases, you will never have to look inside the graph yourself or worry about its structure.

Still, while it is not absolutely necessary to understand the structure of the commit graph to use the various revision control operations, it can be helpful to have a mental model, and being able to query the graph itself directly really helps understanding what actually happened in these operations. This section provides full details of the data structures and queries that are used in the _commit graph_ with enough detail that you should be able to construct your own custom revision control queries from scratch.

## Commit Chains - the basic data structure

# Diagram Explanation

![Diagram shows commit parent and branch and how they point at commit](/docs/assets/images/commit_graph.png)

As can be seen in the figure above, the commit graph consists of some number of branches, in this case "master" and "dev", which have a "head", that is, a current commit which they are looking at.

Each commit in the graph (here labelled "a", "b", "c", "d", "e", "f",
"i", "j") have some number of edges labelled "instance", "schema", or
"inference". This specifies which graphs are associated with a given
commit. In term, these graphs have a name, and an ID which associates
them with a unique database state (stored in the TerminusDB Layer
Store).

In addition each commit points at a parent commit if it has one. This
represents the previous state of the database, and allows us to time
travel, or branch from other points in history.

---


# Revision Control Queries

Translating results from _commit graph_ queries into actual revision control operations is very simple and almost always follows the same basic pattern.

1. We query the _commit graph_ with some pattern, involving time, commit author or commit message, to find the id of the specific commit (or branch) we are interested in
1. We take the Commit ID from this result and use it to parameterise subsequent calls to the database and the database behaves as if its contents were exactly as they were at the time that the commit in question completed.

The following sections contain many practical examples of querying the commit graph to perform revision control operations. Below we present the general pattern that all such operations take and the two principle ways in which we can plug commit ids into revision control operations. The names of function and the basic paradigm is closely based on the operations and paradigms supported by git, the revision control system for code.

## Setting Head of WOQL client:
The WOQL client libraries are designed in such a way that we they have an internal concept of a cursor or "head" which could be any branch or commit in the database. By setting the client head to a specific commit id or to a specific branch, we specify that all subsequent accesses to the Database API will be against that specific branch or historical state of the database rather than whatever the default (latest) version is.

Set "head" to a specific comit ID


```javascript
CommitID = dbClient.query(Commit_Graph_Query)
dbClient.ref(CommitID)
```

or

```javascript
Branch = dbClient.query(Commit_Graph_Query)
dbClient.checkout(Branch)
```

This sets the client's internal head state. All subsequent access will not be done from the commit associated with the commit id or the branch head.

Once we have set the client's head to point at a particular branch or commit, then subsequent api calls with that client will use that state in the following way:

1. `client.branch(new_branch_id)`

Creates a new branch with id _new_branch_id_ starting from the client head (branch or commit id that we set in ref/checkout above). This allows us to start a new branch from any point in the commit history.

2. `client.merge(target_branch)`

Merge starting from the client head (branch or commit id that we set in ref/checkout above) into the branch called _target_branch_. This allows us to merge differences between any commit in our history and any branch (note we can only ever write into the head of a branch because old commits are immutable)

### Forming Resource String Manually

`WOQL.using("_commits")`

It should be noted that internally in TerminusDB, a commit ID refers to a very complex structure which actually contains all of the relevant historical data, if you are interested in the internal data structures, they are fully documented in the [Full Architecture](../architecture/) section and associated papers. However from a user point of view, all you have to know is Commit IDs allow you to set the state of the database to exactly the state that it was when the related update completed and queries to the _commit graph_ allow you to find the Commit IDs that you are interested in.

## Other Contents of Commit Graph - Database Level Meta-data

* prefixes
* graph structure

Prefixes are also stored at the level of the commit graph. The reason for this is that it is useful to set prefixes which can be shared by collaborators. The commit graph is the graph which is transported when we do push/pull/clone and other collaboration operations so all data intended to be shared needs to be in the commit graph.

### Notes

* Administrators can choose to active the `write_to_commit_graph` capability which will allow them to manually rewrite the commit graph, however, direct updates of the commit graph are completely unsupported and highly inadvisable as the chance of breaking the internal delicate datastructures that lie beneath is extremely high. If you choose to do so, proceed with caution and assume that you will destroy everything.



