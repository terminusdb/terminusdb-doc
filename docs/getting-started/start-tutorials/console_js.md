---
layout: default
title: Create TerminusDB Graph with Console
parent: Getting started tutorials
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

You can specify an id for the database, to make it memorable, let’s make it `1stdb` (note that Terminus IDs are URLs and they cannot have spaces!). As a title, enter the name you want to give your Database, something meaningful like `My First Database`. Then you can add a short description to your database, like `It is my first database using TerminusDB`.

![Create Database](https://miro.medium.com/max/2232/1*_05f3gD0v45a-Xncpv1SUQ.png)

Click the `Create` button at the bottom, and you should see the `Successfully Created Database` 1stDB in green at the top. Something like this:

![Successfully created Database](https://miro.medium.com/max/2096/1*iDole0nJP9PpxQHCkzaUBw.png)

---

## Create a Schema

The schema allows you to organise data into meaningful objects, and it ensures data integrity — nothing goes into your database that is not in the schema. This is a TerminusDB super power — and ensures you derive long term value from your data.

The TerminusDB Console provides a schema editor using WOQL.js. Remaining on the query page, copy this WOQL.js query into the text box (remember to delete the previous query before entering this one):

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

and click `Submit`

To review this schema-building WOQL query:

1. The when will perform the operation for every time its first argument is true. In this case, exactly once.
2. We perform all operations within the and.

So here’s the operations we have performed:

1. We created three different document types (given by the `doctype` function): `Station` , `Journey` and `Bicycle`
2. We added `label` (names) or `description` (short descriptions) to them.
3. We created properties for `Journey`, we do that by using the `property` function after `Journey` with the first argument as the name of the property and the second argument as the type (or range) of the property.
4. For each property, you have to provide an id and the type of that property in `property`, as with class you can add a `label` to it as well.

Check that you have successfully created the schema by clicking the Schema button on the left. You should now be able to see the classes and properties in table format and get a graph representation by clicking the ‘graph’ button (circled in red):

![showing classes in schema](https://miro.medium.com/max/2756/1*1e2iw6CJnWm3NWTFuc9HKw.png)

![graph of the classes in schema](https://miro.medium.com/max/2780/1*x95n_XNGsO5-pNJci1iTJA.png)

![showing properties in schema](https://miro.medium.com/max/2754/1*ty448DHo8KcoUsFZGJ8n_Q.png)

![graph of the properties in schema](https://miro.medium.com/max/2736/1*xY5-Liid961dk1T-GfuE3g.png)

---

## Load in the Data

Now load the data from the CSV. We’re going to progressively extend the query to import the data, cleaning it and matching it as we go. WOQL is a highly composable language, you can combine queries arbitrarily using logical ANDs and ORs.

**Let’s build the next query in steps and only hit `Submit` at the end of the query (full query is available at the bottom of the section)**

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

![Result of import / clean data query](https://miro.medium.com/max/4478/1*MXJohHDXNIN6zuoBVjacnQ.png)

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
WOQL.when(inputs, inserts);
```

and click `submit`. Remember, this is getting the data in to our graph so you won’t have a query output just yet. It should look something like this:

![query result](https://miro.medium.com/max/2688/1*fKSEaLdiwPdpNH_QOOiStw.png)
We are working to make it prettier!

Or this if you have the view pane open:

![open view pane](https://miro.medium.com/max/2710/1*x-Pj1FTVVeVLqll7e3EGuw.png)
The little x closes the view pane and the button opens it (both circled in red)

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

and click `submit`.

> Extra: Check out how to [Load your local files in TerminusDB](http://blog.terminusdb.com/2020/01/21/loading-your-local-files-in-terminusdb/)

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

click `Submit`

You should see the query returning a table:

![query returns a table](https://miro.medium.com/max/2716/1*gv6sXsUvEjXteY0wZqgYfA.png)

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

Click the graph button and that gives us a basic graph:

![result as graph](https://miro.medium.com/max/2742/1*uKREL4NhiB3MdDAQQx9Iog.png)

We want to change the view and turn the query output into a graph visualisation that give us insights about bike journeys in Washington D.C.

Click on the view button beside the graph (circled in red):

![click on the view button](https://miro.medium.com/max/2742/1*T2kI7TkDtmjsbQLjKXarqw.png)

You should get this:

![start editing the view script](https://miro.medium.com/max/2730/1*1xr6zU_ezS5dpB5D2Pwk3w.png)

In the view text box (the query builder is still visible above) input the following (remembering to delete the text already in the box):

```js
view = View.graph();
view.node("Start_Label", "End_Label").hidden(true)
view.node("End").icon({color: [255,0,0], unicode: "\uf84a"})
    .text("v:End_Label").size(25).charge(-10)
view.node("Start").icon({color: [255,0,0], unicode: "\uf84a"})
    .text("v:Start_Label").size(25).collisionRadius(10)
view.edge("Start", "End").weight(100)
```

First we use `hidden(true)` to hide some nodes — too many nodes complicate the graph with information we don’t need to see right now.

Updating `color` and `unicode` changed the colours and inserted icons size set the icon `size`, making the nodes a little bigger so they pop, and `charge` pushes the nodes away from each other so the view isn’t too cluttered.

Setting `text` in the graph so when you hover over the node you get the label — in this case the names of bike stations in Washington D.C. We use `collisionRadius` to determine the radius of the node in terms of collisions. Finally, we use `view.edge` to create lines between nodes setting what the end points are and set the weight to determine how dark the edges are — we don’t want the edges to dominate the view.

Click on `Update View`, we have a graphical model of all the journeys in the dataset between bike station.

![graph showing all bike journeys](https://miro.medium.com/max/1640/1*cbF3mvAVCJAOS09F-FHMCw.png)
