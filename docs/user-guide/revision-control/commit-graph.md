---
layout: default
title: The Commit Graph
parent: Revision Control
grand_parent: User guide
nav_order: 1
---

# The Commit Graph
{: .no_toc }

The commit graph stores all of the metadata about our revision
history. TerminusDB will keep track of all operations which modify the
state of the database here, along with timestamps, comments and
designation of authorship.

While it is not absolutely necessary to understand the structure of
the commit graph to use the various revision control operations, it
can be helpful to have a mental model, and very helpful to query the
graph itself to understand what actually happened in these operations.

When an update is made to the database, TerminusDB will create a *delta layer* which is i

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Usage Example

## Sequence of WOQL queries

Sequence of WOQL queries that updates new WOQL database and populates the commit graph with all the commits necessary to illustrate all of the examples in the sections.

---

# Diagram Explanation

pictorial and tubular representations

[ Picture: diagram shows commit parent and branch and how they point at commit ]

Table shows all properties that exist in the commit graph

---

# Revision Control Queries

Using the commit graph for revision control queries

## forming resource string with using

## setting the internal state
