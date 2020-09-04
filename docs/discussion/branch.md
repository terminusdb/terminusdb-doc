---
title: Branching and Merging
layout: default
parent: Discussion
nav_order: 3
---
# Branching and Merging

{: .no_toc }

Branching means you diverge from the mainline of the database and can continue to do work without messing with that mainline. This, with merge, is a killer feature for TerminusDB and TerminusHub.

A branch in TerminusDB is simply a lightweight movable pointer to a commit. The default database name in TerminusDB is `main`. 

When you make a commit,  stores a commit object that contains a pointer to the snapshot of the content you staged. 



# Merge Strategies

Currently, we have only implemented a single strategy for merging branches. This strategy is called *rebase*. We intend to include other approaches to merge in the near future.

## [](https://terminusdb.com/docs/user-guide/revision-control/merging/#rebase)Rebase

Rebase is a merge style which takes the commits from a source branch and places all new commits (those which follow from the common history of it exists) on the top of the current head. This allows users to create a common view of history which plays new work on top of that which has already been commited by others. This can be convenient when collaborating with other users.

Here are some posts:

1. [Branch and Merge Functionality in TerminusDB and Hub](https://www.youtube.com/watch?v=YY1usMBuNSU)

