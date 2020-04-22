---
layout: default
title: Visualisation
parent: User guide
nav_order: 4
has_children: true
permalink: /docs/user-guide/visualisation
---

# Code
Visualization

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

Here we can define different views on attained results after firing woql queries. We take the help of Terminus View and rules provided here to alter the results according to whatever we want to see.

The different views made available are -
    1) Table View
    2) Graph View
    3) Chooser View   
    4) Document Frames View

Under the hood a view is defined as new TerminusView which is accessed at the console via a variable names View. In other words View represents a new TerminusView

Example:
```js
view = View.table()   // is a view which displays results in table format   
```
or

```js
view = View.graph()   // is a view which displays results in graph format   
```
