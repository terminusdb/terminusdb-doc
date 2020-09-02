---
layout: default
title: Import and Clean Data
parent: How Tos
nav_order: 7
---

# Import and Clean Data
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## CSV

In order to load data from CSV you need to map each column of interest
to a variable, and then insert triples with the data you are
interested in. If you have a database *without a schema* then you can
simply import the data on properties which are named appropriately.

If we take the following `roster.csv` CSV for instance:

```csv
Name,Registration_Date,Paid
George,2017-01-02,Yes
Willie,2017-01-02,No
```

We can load this into a graph as follows:

```javascript
and(get(as("Name","v:Name")
        .as("Date", "v:Date")
        .as("Paid", "v:Paid")).file('roster.csv'),
    idgen("doc:RosterRecord",["v:Name","v:Date","v:Paid"],"v:ID"),
    add_triple("v:ID","scm:name","v:Name"),
    add_triple("v:ID","scm:date","v:Date"),
    add_triple("v:ID","scm:paid","v:Paid"))
```

The first argument of the `as` is the column header name, the second
is the name of the variable which will carry this data.

We want to construct an URI identifier which carries a unique
representation of the record from the roster. We can do this with
`idgen` which will create a valid id from the *key* for us.

The final `add_triple` simply adds the information for this property
to the database.
