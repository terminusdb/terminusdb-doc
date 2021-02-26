---
title: Basic Ideas
layout: default
parent: Discussion
nav_order: 1
---
# Basic Ideas

{: .no_toc }

TerminusDB is an open-source model driven RDF graph database for knowledge graph representation designed specifically for the web-age.

TerminusDB Server provides TerminusDB with a RESTful API for interacting with knowledge graphs via the JSON-LD exchange format. This means you can easily compose applications within your own toolchain which utilize the powerful features of graph search and graph storage.

We use an advanced git-like model, storing append only changes to graphs represented in succinct data structures. You can read a description of the architecture in our [Succinct Data Structures and Delta Encoding for Modern Databases](https://github.com/terminusdb/terminusdb-server/blob/master/docs/terminushub/whitepaper/terminusdb.pdf) whitepaper.

TerminusDB's *delta-encoding* approach makes possible branch, merge, push, pull, clone, time-travel and other git-like operations on a fully-featured graph database.

Here are some posts:

1. [Technical history of the development of TerminusDB](https://terminusdb.com/blog/2020/04/14/terminusdb-a-technical-history/)
2. [Continuous Everything as Code](https://terminusdb.com/blog/2020/05/29/continuous-everything-as-code/)

   ![TerminusDB Basic ideas ](/docs/terminushub/assets/uploads/code.jpg)