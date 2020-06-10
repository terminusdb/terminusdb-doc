---
layout: default
title: Resources
parent: Query
grand_parent: User guide
nav_order: 4
---

# Resources
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction

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
