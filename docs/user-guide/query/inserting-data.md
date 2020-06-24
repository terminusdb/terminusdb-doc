---
layout: default
title: Inserting Data
parent: Query
nav_order: 2
---

# Inserting Data
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


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

To complete loading in the data, the previous steps need to be join together with `inserts` using a `WOQL.and()`. For example loading data from csv:

```js
WOQL.and(csv, ...wrangles, inserts)
```

---
