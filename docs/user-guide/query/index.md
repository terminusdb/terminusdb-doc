---
layout: default
title: Query
parent: User guide
nav_order: 2
has_children: true
permalink: /user-guide/query
---

# Query
{: .no_toc }

WOQL is the query language that works with TerminusDB. With its Prolog like logic, it is an elegant way to query data when you get the hang of it.

WOQL’s primary syntax and interchange format is in JSON-LD. However, you can use WOQLjs and WOQLpy package which is included in their corresponding API client to construct WQOL queries. Query using WOQLjs is also available in TerminusDB console.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# WOQLjs and WOQLpy

JSON, through an elegant way to pass queries to the database, it is not the most coding friendly. WOQLjs and WOQLpy provide a tool to construct WOQL queries with JavaScript and Python. They are included in their corresponding API client to construct WQOL queries. Query using WOQLjs and WOQLpy is also available in TerminusDB console. For details about WOQLjs and WOQLpy calls, please see the documentation of the API clients:

[JavaScript Client](https://terminusdb.github.io/terminusdb-client/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }[Python Client](https://terminusdb.github.io/terminusdb-client-python/){: .btn .fs-5 .mb-4 .mb-md-0 }

We assume most users will use WOQLjs or WOQLpy when constructing queries, hence most examples in this documentation will be in WOQLjs and/or WOQLpy.

---


# Querying Database

You can use both WOQLjs or WOQLpy to Query the data from the database. The following describe a few ways to do that and with the result presented in the console or as a Pandas DataFrame (WOQLpy)

## Querying with the TerminusDB Console

Queries can be done within the console, just enter your query into the box provided and click on the `Query` button at the top of the Query screen windows:

![Query at Console](../assets/images/console/query_at_console.png)

An example of Query in WOQLjs would be:

```js
WOQL.select("v:Start", "v:Start_Label", "v:End", "v:End_Label").and(
	WOQL.triple("v:Journey", "type", "scm:Journey"),
	WOQL.triple("v:Journey", "start_station", "v:Start"),
	WOQL.opt().triple("v:Start", "label", "v:Start_Label"),
	WOQL.triple("v:Journey", "end_station", "v:End"),
	WOQL.opt().triple("v:End", "label", "v:End_Label"),
	WOQL.triple("v:Journey", "journey_bicycle", "v:Bike")
)
```

Multiple `WOQL.triple`s are used to describe the relations of the objects in the graph. They are combined with a `WOQL.and`. `WOQL.quad` can be used in similar way if the graph of that triple needed to be specified.

Without the `WOQL.select`, all the variables, described with prefix `v:`, that matches with the relations will be returned as result. However, using `WOQL.select` can limit which variable are returned in the result. This can be used if some of the variables are intermediate links in the relations and not needed in the result. The result can be presented in wither table view or graph view.

`WOQL.opt` is used if that conditional is optional. In this example, both `label`s for the Start Station and End Stations are not required. Using `opt` would avoid getting an error if any `label`s are missing.


## WOQLpy - Getting Result as a Pandas DataFrame

**Only in python client for TerminusDB v1.0**

If `dataframe` option is chosen when installing `terminusdb-client-python` ([details here]()) after executing the query with `query.execute(client)` a result binding is returned and it could be convert as a Pandas DataFrame by `woql.query_to_df(result)`. See [tutorial]() as example.

---
