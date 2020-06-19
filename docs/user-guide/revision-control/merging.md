---
layout: default
title: Merging
parent: Revision Control
grand_parent: User guide
nav_order: 4
---

# Merging
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Merge Strategies

Currently we have only implemented a single strategy for merging
branches. This strategy is called _rebase_. We intend to include other
approaches to merge in the near future.

## Rebase

![Diagram of rebase]()

Rebase is a merge style which takes the commits from a source branch
and places all new commits (those which follow from the common history
of it exists) on the top of the current head. This allows users to
create a common view of history which plays new work on top of that
which has already been commited by others. This can be convenient when
collaborating with other users.

