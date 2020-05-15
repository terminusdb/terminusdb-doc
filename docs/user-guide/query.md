---
layout: default
title: Query
parent: User guide
nav_order: 2
---

# Query
{: .no_toc }

WOQL is the query language that works with TerminusDB. With its Prolog like logic, it is an elegant way to query data when you get the hang of it.

WOQL’s primary syntax and interchange format is in JSON-LD. However, you can use WOQLjs and WOQLpy package which is included in their corresponding API client to construct WQOL queries. Query using WOQLjs and WOQLpy is also available in TerminusDB console.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# WOQL - Web Object Query Language

The WOQL query language is a unified model query language. It allows us to treat our database as a document store or a graph interchangeably, and provides powerful query features which make relationship traversals easy.

WOQL's interchange format is written in JSON-LD. This gives us a relatively straightforward human-readable format which can also be easily stored in TerminusDB itself.

For example a simple query which returns every source, predicate and object in a database:

```json
{"@context" : {"@import": "https://terminusdb/contexts/woql/syntax/context.jsonld",
               "@propagate": true},
 "@type" : "Triple",
 "subject" : {"@type" : "Variable",
              "variable_name" : {"@type" : "xsd:string",
                                 "@value" : "Subject"}},
 "predicate" : {"@type" : "Variable",
                "variable_name" : {"@type" : "xsd:string",
                                   "@value" : "Predicate"}},
 "object" : {"@type" : "Variable",
             "variable_name" : {"@type" : "xsd:string",
                               "@value" : "Object"}}}
```

This format is relatively verbose and inconvenient to write directly. However it is ideal for constructing programmatically in Python, Javascript or whatever your favourite language is. It's also possible to represent queries as graphs in Terminus, thereby allowing you to store and load queries which belong with your datasets.

---

# WOQL JSON-LD Encoding

The default imported JSON-LD context at [https://terminusdb/contexts/woql/syntax/context.jsonld](https://terminusdb/contexts/woql/syntax/context.jsonld) allows the syntax to be less verbose by automatically adding "@base", assuming that bare words are in the WOQL namespace. In addition some parameters of keywords are assumed to be identifiers and not strings.

```json
{"@context" :
 {"@version": 1.0,
  "@base": "http://terminusdb.com/schema/woql",
  "@vocab" : "#",
  "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
  "tcs" : "http://terminusdb.com/schema/tcs#",
  "owl" : "http://www.w3.org/2002/07/owl#",
  "xsd" : "http://www.w3.org/2001/XMLSchema#",
  "v" : "http://terminusdb.com/schema/woql/variable/",
  "terminus" : "http://terminusdb.com/schema/terminus#",
  "query_list" : {"@type" : "@id"},
  "query" : {"@type" : "@id"},
    ...
 }
}
```

---

# WOQLjs and WOQLpy

JSON, through an elegant way to pass queries to the database, it is not the most coding friendly. WOQLjs and WOQLpy provide a tool to construct WOQL queries with JavaScript and Python. They are included in their corresponding API client to construct WQOL queries. Query using WOQLjs and WOQLpy is also available in TerminusDB console. For details about WOQLjs and WOQLpy calls, please see the documentation of the API clients:

[JavaScript Client](https://terminusdb.github.io/terminusdb-client/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }[Python Client](https://terminusdb.github.io/terminusdb-client-python/){: .btn .fs-5 .mb-4 .mb-md-0 }

We assume most users will use WOQLjs or WOQLpy when constructing queries, hence most examples in this documentation will be in WOQLjs and/or WOQLpy.

---

# Resources

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
update. You can, however, search a commit.

### References

References are (currently) either branches or commits. For some
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

The Commit graph stores information about all commits that have been
made in a given branch. You can query this to find information about
historical updates, the author and time of these updates as well as
which branches exist.

### Repository Metadata

```
<account>/<dbid>/_meta
```

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

# Creating Schema

When creating a schema with WOQL, a `when` cause is used, it takes two arguments: the first argument is the condition that need to full fill to execute the second argument. With WOQLjs and WOQLpy, you may chain the executable query following `WOQL.when()` (in WOQLjs) or `WOQLQuery.when()` (in WQQLpy). In most cases in creating a schema, a condition is not required and thus the first argument will be `true`. for example in WOQLjs:

```js
WOQL.when(true).and(
    WOQL.doctype("Station")
        .label("Bike Station")
        .description("A station where bicycles are deposited"),
    WOQL.doctype("Bicycle")
        .label("Bicycle"),
    WOQL.doctype("Journey")
        .label("Journey")
        .property("start_station", "Station")
            .label("Start Station")
        .property("end_station", "Station")
            .label("End Station")
        .property("duration", "integer")
            .label("Journey Duration")
        .property("start_time", "dateTime")
            .label("Time Started")
        .property("end_time", "dateTime")
            .label("Time Ended")
        .property("journey_bicycle", "Bicycle")
            .label("Bicycle Used")
)
```

### Document objects

The executable queries can be constructed with the help of the WOQL query objects. Usually there document objects with labels and descriptions can be easily constructed with a chain of call like:

``` js
WOQL.doctype("Station")
    .label("Bike Station")
    .description("A station where bicycles are deposited")
```

However, labels and descriptions are optional. The minimum way of creating a document object would be `WOQL.doctype("idOfObj")`

### Properties

Properties can also be chained to the document objects in WOQLjs and WOQLpy, for example in WOQLjs:

``` js
WOQL.doctype("Journey")
    .label("Journey")
    .property("start_station", "Station")
        .label("Start Station")
```

Properties will take an extra argument for the range of the property - it could be a datatype e.g. dateTime, string, integer, double, etc; or an other document object. label and descriptions can also be added to properties in similar manner as doctype objects.

### Subclases

To created a subclass structure in TerminusDB graph,`add_quad` can be used. For example:

``` js
WOQL.add_quad("child", "subClassOf", "parent", "schema")
```

For details regarding WOQL query objects in API clients, please refer to [API Reference](/docs/api-reference/)

---

# Loading Data into Database

Loading data into a graph, usually involve in two stages:

* loading data into a temporary graph
* insert the data into the graph according to the schema

Though using the WOQLjs or WOQLpy programatically to insert data is also possible.

## Loading Data into a Temporary Graph

### loading data from csv

Loading data form csv involve in getting the data from the csv and wrangling the data. First, read in the data form the csv and assign variables corresponding to each column.

```js
csv = WOQL.get(
        WOQL.as("Start station","v:Start_Station")
        .as("End station", "v:End_Station")
        .as("Start date", "v:Start_Time")
        .as("End date", "v:End_Time")
        .as("Duration", "v:Duration")
        .as("Start station number", "v:Start_ID")
        .as("End station number", "v:End_ID")
        .as("Bike number", "v:Bike")
        .as("Member type", "v:Member_Type")
    ).remote(url);
```

The above will read a csv form a remote destination `url` (e.g. a file hosted online) and assigning variable to each column. The variables will be is used in the data wrangling:

```js
wrangles = [
    WOQL.idgen("doc:Journey",["v:Start_ID","v:Start_Time","v:Bike"],"v:Journey_ID"),
    WOQL.idgen("doc:Station",["v:Start_ID"],"v:Start_Station_URL"),
    WOQL.cast("v:Duration", "xsd:integer", "v:Duration_Cast"),
    WOQL.cast("v:Bike", "xsd:string", "v:Bike_Label"),
    WOQL.cast("v:Start_Time", "xsd:dateTime", "v:Start_Time_Cast"),
    WOQL.cast("v:End_Time", "xsd:dateTime", "v:End_Time_Cast"),
    WOQL.cast("v:Start_Station", "xsd:string", "v:Start_Station_Label"),
    WOQL.cast("v:End_Station", "xsd:string", "v:End_Station_Label"),
    WOQL.idgen("doc:Station",["v:End_ID"],"v:End_Station_URL"),
    WOQL.idgen("doc:Bicycle",["v:Bike_Label"],"v:Bike_URL"),
    WOQL.concat("v:Start_ID to v:End_ID at v:Start_Time","v:Journey_Label"),
    WOQL.concat("Bike v:Bike from v:Start_Station to v:End_Station at v:Start_Time until v:End_Time","v:Journey_Description")
];
```

Three common data wrangling methods are: `idgen()`, `cast()` and `concat()`:

* `idgen` creates unique identifier for each data object, there are 3 arguments needed: 1. the prefix; 2. the list of columns to generate the identifier, and; 3. the variable to store the identifier.
* `cast` is used to change the datatype, for data that are not strings, it is needed to convert the incoming data to their correct datatypes.
* `concat` is used to create new strings with the variables, just like formatted strings in JavaScript and Python.

Then the two steps can be combined with a `WOQL.and()`:

```js
inputs = WOQL.and(csv, ...wrangles);
```

### loading data from RDF

Instead of data wrangling, data form RDF can be loaded directly to a temporary graph:

```js
WOQL.with("graph://temp",
          WOQL.remote("my_url",
                      {"type":"turtle"}),
          WOQL.quad("v:Subject",
                    "v:Predicate",
                    "v:Object",
                    "graph://temp")
)
```
from the temporary graph, we can insert the data according to the schema of the designated graph database. See [this blog post](https://terminusdb.com/blog/2020/01/30/loading-data-in-turtle-rdf-format-to-terminusdb/) for more details/

### loading data from local file

In the above example, we assume the data source is hosted online with a url to pass in for `WOQL.remote()`. For a local file, we use `WOQL.file()` instead. Refer to [this blog post](https://terminusdb.com/blog/2020/01/21/loading-your-local-files-in-terminusdb/) for using local files with TerminusDB Docker images.

## Insert Data into Graph Database

Either the data is in the temporary graph or is processed by JavaScript or Python program, eventually it has to be insert into the graph database. It is done with `WOQL.insert()`, usage could be:

```js
inserts = WOQL.and(
    WOQL.insert("v:Journey_ID", "Journey")
        .label("v:Journey_Label")
        .description("v:Journey_Description")
        .property("start_time", "v:Start_Time_Cast")
        .property("end_time", "v:End_Time_Cast")
        .property("duration", "v:Duration_Cast")
        .property("start_station", "v:Start_Station_URL")
        .property("end_station", "v:End_Station_URL")
        .property("journey_bicycle", "v:Bike_URL"),
    WOQL.insert("v:Start_Station_URL", "Station")
        .label("v:Start_Station_Label"),
    WOQL.insert("v:End_Station_URL", "Station")
        .label("v:End_Station_Label"),
    WOQL.insert("v:Bike_URL", "Bicycle")
        .label("v:Bike_Label")
);
```

`WOQL.insert()` takes two arguments: 1. the id for the object, could be the variables from data wrangles or a string generated form your program; 2. the type of the object, it should be the doctype form the schema. `label`, `description` and `property` can be added to the object in a similar manor as creating schema.

Example of using WOQLjs and WOQLpy to load the insert data form csvs can be found in [this GitHub repo](https://github.com/terminusdb/terminusdb-tutorials/tree/master/bike-tutorial). Example of programatically creating schema and inserting data directly from WOQLpy can be found in [this GitHub repo](https://github.com/terminusdb/terminusdb-tutorials/tree/master/schema.org).

---

# Querying Database

You can use both WOQLjs or WOQLpy to Query the data from the database. The following describe a few ways to do that and with the result presented in the console or as a Pandas DataFrame (WOQLpy)

## Query at Console

Queries can be done within the console, just click on the `Query` button on the left for the queries windows:

(pictures to be added)

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

If `dataframe` option is chosen when installing `terminusdb-client-python` ([details here]()) after executing the query with `query.execute(client)` a result binding is returned and it could be convert as a Pandas DataFrame by `woql.query_to_df(result)`. See [tutorial]() as example.

---
