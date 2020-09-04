---
title: Collaboration
layout: default
parent: Discussion
nav_order: 2
---
# Collaboration

{: .no_toc }

TerminusDB contains a powerful query engine and API, but what makes it most unique, is its revision control capabilities which were built into the very core of how TerminusDB works. In the most technical terms, TerminusDB uses an immutable append-only layered storage model where only state differences are stored, using a succinct delta-encoding mechanism. In simple terms, TerminusDB never changes anything - whenever you update the database, new values are created which shadow the old ones but you can always look behind the shadow and see what everything looked like before each and every update. The entire history of everything that has ever been in the database is retained and readily accessible.

Once you have a database engine that works like this, it becomes relatively easy and lightweight to provide the core revision control operations - branch, merge, push and pull (or some variation thereof) that practical revision control systems must provide.

This basic idea and much of the revision control functionality has been shamelessly borrowed from Git - the version control tool that has improved all of our lives immeasurably as software engineers. Where we have gone beyond git is that TerminusDB is designed for data not code - specifically and most importantly, in addition to providing all of the revision control functionality that git provides, TerminusDB also supports fast queries over very large (multi-billion node) highly complex datasets with an extremely expressive and formally correct query and schema language.

By marrying the scale and querying capabilities of a modern in-memory graph database with the revision control functionality of git, we hope to provide relief to every engineer who ever looked at a pile of huge CSVs and said to themselves, “there *must* be a better way of doing this, if only there was a git for data”.

Here are some posts:

1. [Continuous Everything as Code](https://terminusdb.com/blog/2020/05/29/continuous-everything-as-code/)
2. [My First Shared TerminusDB with TerminusHub](https://www.youtube.com/watch?v=pCLgW3bhSCw)
