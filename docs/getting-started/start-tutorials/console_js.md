---
layout: default
title: Create TerminusDB Graph with Console
parent: Getting started tutorials
grand_parent: Getting started
nav_order: 1
---

# Create TerminusDB Graph with Console
{: .no_toc }

In here you will see a step-by-step guide to create your first knowledge with Terminus DB with TerminusDB console using WOQLjs.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Create a database

Open up the Terminus DB console ( default: http://localhost:6363/console ). Click on `Create Database` to start with.

![Create Database](https://miro.medium.com/max/1400/1*Npdm3Q71Vt3lupDR9quKsw.png)

Click the `Create Local Database`

![Create Local Database](https://miro.medium.com/max/1400/1*NCbwmytJKyKSQoIOaxvukQ.png)

You have to specify an id for the database, to make it memorable, let’s make it `1stdb` (note that Terminus’ IDs are URLs and they cannot have spaces). As a title, enter the name you want to give your Database, something meaningful like `My First Database`. Then you can add a short description to your database, like `It is my first database using TerminusDB 2.0.`

![Fill in info for Database](https://miro.medium.com/max/1400/1*groaLJ3uIJHJ5nW-0h_X4A.png)

Click the `Create New Database` button at the top right, and you’ll automatically go to the main database page. Something like this:

![After Created Database](https://miro.medium.com/max/1400/1*9EPD3ICI4NTfUh1Cs2rv_A.png)

---

## Create a Schema

The schema allows you to organise data into meaningful objects, and it ensures data integrity — nothing goes into your database that is not in the schema. This is a TerminusDB super power — and ensures you derive long term value from your data.

The TerminusDB Console provides a schema editor using WOQL.js. Remaining on the query page, copy this WOQL.js query into the text box (remember to delete the previous query before entering this one):

```js
WOQL.and(
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

add a commit message in the box below (e.g. "creating schema") and click `Run Query`

Let’s stop to review this schema-building WOQL query:

We perform all operations within the and.

So here’s the operations we have performed:

1. We created three different document types (given by the `doctype` function): `Station` , `Journey` and `Bicycle`
2. We added `label` (names) or `description` (short descriptions) to them.
3. We created properties for `Journey`, we do that by using the `property` function after `Journey` with the first argument as the name of the property and the second argument as the type (or range) of the property.
4. For each property, you have to provide an id and the type of that property in `property`, as with class you can add a `label` to it as well.

---

## Load in the Data

Now load the data from the CSV. We’re going to progressively extend the query to import the data, cleaning it and matching it as we go. WOQL is a highly composable language, you can combine queries arbitrarily using logical ANDs and ORs.

**Let’s build the next query in steps and only hit `Run Query` at the end of the query (full query is available at the bottom of the section)**

Go back to the Query page, and copy in the following query:

```js
//Read data from CSV
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

If we hit `Run Query` for this section and you should see the following in the `Results Viewer` tab:

![Result of import / clean data query](https://miro.medium.com/max/1400/1*J90xWiEM0T1SDzPwd2_4DA.png)

Click on the `table` drop down menu in the top left of the results and switch to `graph` view:

![Result of import / clean data query in graph](https://miro.medium.com/max/1400/1*INPkkOcVBTUea88xwqbr6w.png)

Now you can see your results in graph form.

We’ll explain each of the steps in this query in turn. As a first step, we saved the part of the query that imports the data from CSV in a `const` variable named `csv`. Then we create a list of WOQL operators and save it in another constvariable called `wrangles`, we combine the two parts of the query with a `WOQL.and` operator.

The `wrangles` clause uses 3 WOQL functions to transform the data into the correct form for input. In each case, the function creates a new variable as output — the last argument in each case. The `idgen` function generates IDs for our three document types `Journey`, `Station`, and `Bicycle`. The first argument is the prefix that will be used, the second is a list of variables which combine to give a unique identity for the id. For example, in `Journey` we use 3 fields in the `csv` (`Start_ID`, `Start_Time` and `Bike`) to generate a unique id `Journey_ID`.

Besides generating IDs, we also create new fields with new data types, for example, we use `typecast` to cast `Duration` into `integer` and store it as `Duration_Cast`. We can also use `concat` to contract new text formatted with variables in the fields — for example, to create `Journey_Label`.

We’ll insert them in the graph by adding `triples`! Triples are the atomic data entity in the RDF data model. We add the following to the query:

```js
const inputs = WOQL.and(csv, ...wrangles)
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
```

This is the clause that actually inserts the data into the structure that we defined on our schema.

* The `insert` function inserts a new node into the database with the id `Journey_ID` and type `Journey` we add properties like `start_time`, `end_time`, `duration`, `start_station`, `end_station` and `label` and put the variables produced above in their correct spots.
* For `Start_Station_URL`, `End_Station_URL` and `Bike_URL`, we assign a `type` and `label` for each of them.

Finally, we have to put all of the above together and create the query that reads the data from the csv, do the data wrangling and add them in the graph as triples. We add this to complete the query:

```js
WOQL.and(inputs, inserts);
```

write some commit message again (e.g. "inserting data") and click `Run Query`. Remember, this is getting the data in to our graph so you won’t have a query output just yet. It should look something like this:

![query result](https://miro.medium.com/max/1400/1*yAGqDFbnvi9vp2gNJyMOsw.png)

The full query in all it’s glory and in easy to copy format:

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
WOQL.when(inputs, inserts);
```

don't forget to put in the commit message, then click `Run Query`.

---

## Query The Data

Back to the query page — again input into the WOQL.js query builder:

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

click `Run Query`

You should see the query returning a table:

![query returns a table](https://miro.medium.com/max/1400/1*9UuFcy8EHCJlm4qojSxqAw.png)

Here we used `select` to filter out the variables (those starting with `v:`) that appear in our output. Then we used `and` to link all the conditions we want to include, as you can see there are lot's of `triples` to be conditioned. The ones with `opt()` means that they are optional — it will be ignored if that data is missing (instead of returning an error — very handy).

The query can be translated as below:

1. select all the `Journeys`
2. and all the `start_stations` of all the `Journeys` (let's call them `Start`)
3. and, if any, all the `labels` of the `start_stations` (let's call them `Start_Label`)
4. and all the `end_stations` of all the `Journeys` (let's call them `End`)
5. and, if any, all the `labels` of the `end_stations` (let's call them `End_Label`)
6. and all the `journey_bicycles` of all the `Journeys` (let's call them `Bike`)

---

## Graph Visualisation

We can click the table drop down menu in the top right and get a graph view of the results:

![result as graph](https://miro.medium.com/max/1400/1*XNMYRFv1XkXu7Tpsb1i-2Q.png)

You can experiment with the query to find different things in the data.
