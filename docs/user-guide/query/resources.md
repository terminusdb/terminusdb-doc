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
update. You can, however, query a commit to get back the data as it
was at the time of that commit.

Collections are referred to using a path string. Inside of a query,
you can use this string with the `using` keyword to query something
different from your context. Outside of queries, you use these strings
to set up your querying context, or refer to collections in any other
operation that needs them.

Collection resource strings come in two forms:
- absolute resource strings give an absolute path to the resource.
- relative paths give a path relative to your current context. This
  generally only makes sense while querying with the `using` keyword.
  
Let's now go over all the collection types, and the resource string
you'd use to refer to them.

### References

References are currently either branches or commits. For some
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

The commit graph stores information about all commits that have been
made in a given branch. You can query this to find information about
historical updates, the author and time of these updates as well as
which branches exist.

### Database Metadata

```
<account>/<dbid>/_meta
```

The database metadata graph holds metadata about the entire
database. This includes the default prefixes of this database, as well
as all the local and remote repositories linked to this database.

### Resource string autocompletion
Generally, incomplete resource strings will be autocompleted. The system generally assumes that you intend to access the master branch of the local repository of your database, so if you just specify an absolute resource string like

```
<acount>/<dbid>
```

The system will actually assume you meant

```
<account>/<dbid>/local/branch/master
```

Likewise, if you specify

```
<account>/<dbid>/origin
```

The system will assume you meant
```
<account>/<dbid>/origin/branch/master
```

### Relative resource strings
While querying, it is possible to query other collections than the one
in the current context with the `using` keyword. The `using` keyword
takes a relative resource string. Failing to parse that as a valid
relative string, it'll try to parse it as an absolute resource string.

#### The resource hierarchy
To understand relative resource strings, it is helpful to consider the paths as a hierarchy. In order, this hierarchy consists of
- the root
- A user namespace
- a database
- a repository
- a reference (branch or commit)

For those resources lower in the hierarchy, it is possible for us to easily refer to any of the elements higher up in the hierarchy and build a path off that. Just like with absolute resource strings, they will get auto-completed. Suppose for example that you are currently working in `joe/data/local/branch/work` and you wish to query `joe/data/origin/branch/master`, you can do so using the path
```
_database/origin
```
Which gets resolved to
```
joe/data/origin
```
and then autocompleted to
```
joe/data/origin/branch/master
```

The full list of such keywords are
- `_root`
- `_user`
- `_database`
- `_repository`

#### Building off the parent resource
In adition to the keywords described above, there's also a special
kind of path component, `..`. Just as in file paths, this path
component gets you in the scope of a parent resource. For example, if
your current context is `joe/data/origin/branch/master` and you
specify the relative resource `../work`, you'll get
`joe/dasta/origin/branch/work`.

Again, auto-completion applies. So if you are on
`joe/data/origin/branch/work` and you lookup `../`, it will
autocomplete to `joe/data/origin/branch/master`.

#### Special considerations for branches and commits
since branches and commits don't have any children of their own, as an
extra convenience, relative lookups aren't relative to the
branch/commit, but relative to their repository. So for example, if
you are currently on `joe/data/origin/branch/master`, you can specify
`branch/work` or `commit/commit_abcde` or `_commits`, and they'll be
resolved in the context of the repository.

The one exception, as mentioned above, is `..`, which will be relative
to the branch or commit, not relative to the repository.

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
