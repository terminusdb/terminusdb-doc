---
layout: default
title: Importing and Cleaning Data From CSVs
parent: Tutorials
nav_order: 6
---

# Importing and Cleaning Data From CSVs
{: .no_toc }

In this tutorial, we will learn how to load data from a CSV file then clean it up with some data wrangling, like changing the type of the data, combining strings and generate ids for objects.

## Jump to
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Step 1 - reading the csv columns

In our example, we will try to load data from this CSV: <https://terminusdb.com/t/data/bike_tutorial.csv>

This can be done by making woql queries. In this tutorial, we will be making queries in the TerminusDB console. However, you can also do it with TerminusDB clients.

To make a query in the console. Go to the query tab by clicking on `query` at the top.

![console query page](/docs/assets/images/tutorials/console-query-page.png)

Now it's time for the query. Our first step, is to load in each columns as a woql variable. This can be done with the following script:

```js
WOQL.get(
    WOQL.as("Start station","v:Start_Station")
        .as("End station", "v:End_Station")
        .as("Start date", "v:Start_Time")
        .as("End date", "v:End_Time")
        .as("Duration", "v:Duration")
        .as("Start station number", "v:Start_ID")
        .as("End station number", "v:End_ID")
        .as("Bike number", "v:Bike")
        .as("Member type", "v:Member_Type")
).remote("https://terminusdb.com/t/data/bike_tutorial.csv")
```

This script involved `get`, `as` and `remote` method. For more explanation about those methods, please see their reference in woql.

This is loading a remote CSV from the link. For loading a local file, please see the reference of `file` method.

If you click `run query` now, you will see the CSV is imported and the result is shown in a tabular format.

![read csv](/docs/assets/images/tutorials/read-csv.png)

You can switch back to the Query tab by clicking on `Query` next to `Result Viewer` on top of the results.

However, the data read in this step is not updated in any graphs. To save the data in the graph, we will assign this query to a variable and combine it with the following steps.

```js
const csv = WOQL.get(
    WOQL.as("Start station","v:Start_Station")
        .as("End station", "v:End_Station")
        .as("Start date", "v:Start_Time")
        .as("End date", "v:End_Time")
        .as("Duration", "v:Duration")
        .as("Start station number", "v:Start_ID")
        .as("End station number", "v:End_ID")
        .as("Bike number", "v:Bike")
        .as("Member type", "v:Member_Type")
).remote("https://terminusdb.com/t/data/bike_tutorial.csv")
```

## Step 2 - data wrangling

In the next step, we are going to prepare the data for step 3. The data that we have got in step 1 is not ready to be put in the graph. We will have to generate id for doctype objects, convert data into their correct data types and create strings for labels and descriptions.

To do that, we will expand our previous script as the following:

```js
const csv = WOQL.get(
    WOQL.as("Start station","v:Start_Station")
        .as("End station", "v:End_Station")
        .as("Start date", "v:Start_Time")
        .as("End date", "v:End_Time")
        .as("Duration", "v:Duration")
        .as("Start station number", "v:Start_ID")
        .as("End station number", "v:End_ID")
        .as("Bike number", "v:Bike")
        .as("Member type", "v:Member_Type")
).remote("https://terminusdb.com/t/data/bike_tutorial.csv")
//Transform data into correct shape for insert
const wrangles = [
    WOQL.typecast("v:Duration", "xsd:integer", "v:Duration_Cast"),
    WOQL.typecast("v:Bike", "xsd:string", "v:Bike_Label"),
    WOQL.typecast("v:Start_Time", "xsd:dateTime", "v:ST_Cast"),
    WOQL.typecast("v:End_Time", "xsd:dateTime", "v:ET_Cast"),
    WOQL.typecast("v:Start_Station", "xsd:string", "v:SS_Label"),
    WOQL.typecast("v:End_Station", "xsd:string", "v:ES_Label"),
    WOQL.idgen("doc:Journey",["v:Start_ID","v:Start_Time","v:Bike"],"v:Journey_ID"),       
    WOQL.idgen("doc:Station",["v:Start_ID"],"v:Start_Station_URL"),
    WOQL.idgen("doc:Station",["v:End_ID"],"v:End_Station_URL"),
    WOQL.idgen("doc:Bicycle",["v:Bike_Label"],"v:Bike_URL"),    WOQL.concat("v:Start_ID - v:End_ID @ v:Start_Time","v:J_Label"),
    WOQL.concat("Bike v:Bike from v:Start_Station to v:End_Station at v:Start_Time until v:End_Time","v:Journey_Description")
];
//Combine with logical and
WOQL.and(csv, ...wrangles)
```

For explanations about the `idgen`, `typecast` and `concat` methods that are used in the data wrangling, please see their reference in woql.

If you click `run query` now, you will see that we have got new variables that are created with the data wrangling. However, the data is not loaded in the graph yet.

![data wrangling](/docs/assets/images/tutorials/data-wrangling.png)

## Step 3 - insert data

For the last step, we will insert the data that we prepared into the graph. The whole script that includes this step and the previous steps is here:

```js
const csv = WOQL.get(
    WOQL.as("Start station","v:Start_Station")
        .as("End station", "v:End_Station")
        .as("Start date", "v:Start_Time")
        .as("End date", "v:End_Time")
        .as("Duration", "v:Duration")
        .as("Start station number", "v:Start_ID")
        .as("End station number", "v:End_ID")
        .as("Bike number", "v:Bike")
        .as("Member type", "v:Member_Type")
).remote("https://terminusdb.com/t/data/bike_tutorial.csv")
//Clean data for insert
const wrangles = [
    WOQL.typecast("v:Duration", "xsd:integer", "v:Duration_Cast"),
    WOQL.typecast("v:Bike", "xsd:string", "v:Bike_Label"),
    WOQL.typecast("v:Start_Time", "xsd:dateTime", "v:ST_Cast"),
    WOQL.typecast("v:End_Time", "xsd:dateTime", "v:ET_Cast"),
    WOQL.typecast("v:Start_Station", "xsd:string", "v:SS_Label"),
    WOQL.typecast("v:End_Station", "xsd:string", "v:ES_Label"),
    WOQL.idgen("doc:Journey",["v:Start_ID","v:Start_Time","v:Bike"],"v:Journey_ID"),       
    WOQL.idgen("doc:Station",["v:Start_ID"],"v:Start_Station_URL"),
    WOQL.idgen("doc:Station",["v:End_ID"],"v:End_Station_URL"),
    WOQL.idgen("doc:Bicycle",["v:Bike_Label"],"v:Bike_URL"),    WOQL.concat("v:Start_ID - v:End_ID @ v:Start_Time","v:J_Label"),
    WOQL.concat("Bike v:Bike from v:Start_Station to v:End_Station at v:Start_Time until v:End_Time","v:Journey_Description")
];
//combine inputs
const inputs = WOQL.and(csv, ...wrangles)
//generate data to be inserted
const inserts = WOQL.and(
    WOQL.insert("v:Journey_ID", "Journey")
        .label("v:J_Label")
        .description("v:Journey_Description")
        .property("start_time", "v:ST_Cast")
        .property("end_time", "v:ET_Cast")
        .property("duration", "v:Duration_Cast")
        .property("start_station", "v:Start_Station_URL")
        .property("end_station", "v:End_Station_URL")
        .property("journey_bicycle", "v:Bike_URL"),
    WOQL.insert("v:Start_Station_URL", "Station")
        .label("v:SS_Label"),
    WOQL.insert("v:End_Station_URL", "Station")
        .label("v:ES_Label"),
    WOQL.insert("v:Bike_URL", "Bicycle")
        .label("v:Bike_Label")
);
//Combine inputs and inserts with when clause
WOQL.and(inputs, inserts);
```

For details about how `insert` works, please refer to the woql reference.

As this time we are updating the graph, we can put in a commit message (e.g. Insert data form CSV) in the box above the query which says "Enter reason for update here" before we hit `run query`. If there's no commit message given, a default message will be used as a commit message.

![commit message](/docs/assets/images/tutorials/commit-message.png)

After clicking `run query`, you will now see the message in the green box saying "Successfully updated database".

![update success](/docs/assets/images/tutorials/update-success.png)

Now you can check the data is added by clicking at the `Documents` on the top.

![documents](/docs/assets/images/tutorials/documents.png)
