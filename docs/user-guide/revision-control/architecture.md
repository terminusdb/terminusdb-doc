---
layout: default
title: Full Architecture
parent: Revision Control
grand_parent: User guide
nav_order: 8
---

# Full Architecture
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---


TerminusDB is architected as a revision controlled database from the
ground up. In TerminusDB, revision control is based on a model quite
similar to the one used in git. However, where git uses *lines of
code* added or deleted, TerminusDB uses *triples* added or deleted.

*picture of delta here*

Each collection of additions and deletions is called a *delta* or
*delta layer*. These *deltas* are then appended together in a chain
(or tree) to form what is the current state of our *graph*. This
approach of always giving the changed information as a *delta* makes
TerminusDB an *append only* database.

When we query for data, we start at the top of the stack, and search
downwards looking for triples added, which have not been deleted.

Each graph represents *sets* of triples. That is, a triple is either
there, or it is not. There is no notion of it being in the graph
multiple times. This simplifies our model of changes, merges and
updates.

## Architecture

![](/docs/assets/images/architecture.png)

TerminusDB is structured as a hierarchy of graphs. Each level of the
hierarchy is itself a graph which can be queried and which stores
information about the graphs below it.

At the heighest level is the TerminusCore graph. This stores the
records concerning all users and databases in the system.

For each database there is corresponding "_meta" graph which
stores information about which repositories are present for a
datbase. This includes *at least* the "local" repository.  However it
may also contain any number of remote repositories as well. These
remotes represent other TerminuDB installations, and can be used to
push or pull changes and collaborate with others.

Each of these repositories consists of a "_commit" graph which stores
information about the branchs that we have, commit chains, and the
graphs associated with each commit.

Finally commits point to the instance and schema graphs associated
with a commit. This is important since schema and instance graphs
have to move in lock-step to maintain consistency.

We will look more closely at the commit graph and then move on to the
various operations which TerminusDB can perform.
