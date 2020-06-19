---
layout: default
title: From RDBMS databases to TerminusDB
parent: Comparison with other tools
grand_parent: Getting started
nav_order: 1
---

# From RDBMS databases to TerminusDB
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

Most of your applications need to store data somewhere and probably relational databases like MySQL, PostgreSQL etc.. are  the most commonly used for this purpose.

Passing from a relational database to TerminusDB requires some effort and a shift in your state of mind, but it can be done relatively fast. In this tutorial we’ll show you some parallels with how TerminusDB handles tasks compared to relational databases and the goals you can achieve with TerminusDB that are difficult to do with others databases.

if you have never used TerminusDB before, this article includes everything you need to get started with TerminusDB.
[My First TerminusDB Graph Visualisation — Bike Share Data](https://terminusdb.com/blog/2020/01/14/my-first-terminusdb-graph-visualisation-bike-share-data/).

*Note: We are assuming you have knowledge of relational database concepts and you already know how to write a simple sql (Structured Query Language) statement.*

--------------------

## The Dataset

In our examples we use the collection of data about the bike journeys between stations in Washington D.C., USA.

![](/docs/assets/images/bike_table.png)

The CSV data used this tutorial is available at [https://terminusdb.com/t/data/bike_tutorial.csv](https://terminusdb.com/t/data/bike_tutorial.csv)

--------------------

## Query language

As you already know **SQL** is a standard language for accessing and manipulating relational databases.

In TerminusDB we use [**WOQL** (Web Object Query Language)](https://terminusdb.com/docs/woql). It is a unified model query language, WOQL's primary syntax and interchange format is in JSON-LD.
All our example are writing using woql.js a javascript layer that help you to compose WOQL query.

--------------------

## Create Schema

*A conceptual database schema is a description of a database structure, data types, and the constraints on the database.*

We can consider a relational database as a collection, or a set of tables. For storing our dataset we need three tables: bikes, stations and journeys. [Here the complete schema](/docs/assets/bike_journey.sql)

Each table consists of rows and columns, in very simple way the columns specify the type of data, where the rows contain the actual data itself and the tables are related to each other.

Let’s see a fragment of schema:
```sql

 CREATE TABLE `journeys` (
  `idJourney` int(11) NOT NULL AUTO_INCREMENT,
  `bikeId` int(11) NOT NULL,
  ......),
 FOREIGN KEY (bikeId) REFERENCES bikes(idBike),
```
Here our logical relationship from tables: *The **bikeId** column is a FOREIGN KEY to the table **bikes** (idBike column).*

In terminusDB instead of tables we have documents, so for our dataset we need to create three different documents: Station, Journey and Bicycle, every document have a label and a description and is identified by an unique URL.
In our documents we have properties to describe the type of data and the documents are related to each other as interlinked concepts.

An example of relationship between documents written in woql.js

```js

WOQL.when(true).and(        
   WOQL.doctype("Station")            
       .label("Bike Station")            
       .description("A station where bicycles are deposited"),        
   WOQL.doctype("Bicycle")            
       .label("Bicycle"),        
   WOQL.doctype("Journey")            
       .label("Journey")
       .property("journey_bicycle", "Bicycle").label("Bicycle Used")
       .property("start_time", "dateTime")
   .....)        

```
In the **Journey** document the range data type of the **journey_bicycle** property (ObjectProperty) is the **Bicycle** document.

--------------------

## Load Data

What we wish to do now is load the data from our .csv file inside our relational database, but which road map follows to save the integrity of the data relationship, you can use an external tool or you can implement your sql statement.  

You could write an sql statement like this to import the csv file inside bikes or stations

```sql

LOAD DATA LOCAL INFILE 'bike_tutorial.csv' INTO TABLE bikes
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'  IGNORE 1 LINES
(@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8) set bikeNumber=@col8;

```

But populating the journeys table could be more complicated because you have to get bikeId and stationId from the preview table, maybe you can use a temporary table to load all the CSV data and after, you can move the data from the temporary table to bikes, stations, journeys.

In TerminusDB we have a very cleaner solution to import csv files into the database, with a data integrity check for any newly imported records.

TerminusDB is accessible in very easy with JavaScript using the woql.js layer
A fragment of an import query.
```js

const csv = WOQL.get(
    WOQL.as("Start station","v:Start_Station")
        .as("End station", "v:End_Station")
  		......     
        .as("End station number", "v:End_ID")
        .as("Bike number", "v:Bike")
        .as("Member type", "v:Member_Type")
).remote("https://terminusdb.com/t/data/bike_tutorial.csv")

```
We refer the first row of our file that contain the column headers in our variables, for example the field **"Bike number"** refers the variable **"v:Bike"**

```js

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
    WOQL.idgen("doc:Bicycle",["v:Bike_Label"],"v:Bike_URL"),    
    WOQL.concat("v:Start_ID - v:End_ID @ v:Start_Time","v:J_Label"),
    WOQL.concat("Bike v:Bike from v:Start_Station to v:End_Station at v:Start_Time until v:End_Time","v:Journey_Description")
];

```

We cast (WOQL.typecast(a,b,c) method) the variable **"V:Bike"** as string ("xsd:string") and refer it in a new variable "V:Bike_Label"

We create an unique id (WOQL.idgen(a,b,c) to every document. Example for "doc:Bicycle" document we create an id from the  “v:Bike_Label” and refer it in the “v:Bike_Url”

```js

const inserts = WOQL.and(
    WOQL.insert("v:Journey_ID", "Journey").label("v:J_Label")
        .description("v:Journey_Description")
     	.....
        .property("journey_bicycle", "v:Bike_URL"),
   		.....
    WOQL.insert("v:Bike_URL", "Bicycle")
        .label("v:Bike_Label")
);

```

Now we can insert the data inside our database. We create a **"Bicycle"** document for every **"v:Bike_URL"** value and we link this value inside the **"journey_bicycle"** property in **Journey** document. Our relationship link between document has been created ❗
In this article the complete example [My First TerminusDB Graph Visualisation — Bike Share Data](https://terminusdb.com/blog/2020/01/14/my-first-terminusdb-graph-visualisation-bike-share-data/).

--------------------

## Query the Data

Now, how we write our query for getting all the information about the bike journeys.

Here an Sql example

```sql

SELECT journeys.startTime, journeys.endTime, bikes.bikeNumber, journeys.memberType, journeys.duration, startStation.address as startStation, startStation.stationNumber as startStationNumber, endStation.address as endStation, endStation.stationNumber as endStationNumber
FROM journeys
INNER JOIN stations as startStation ON journeys.startStation = startStation.idStation
INNER JOIN stations as endStation ON journeys.endStation = endStation.idStation
INNER JOIN bikes ON journeys.bikeId=bikes.idbike;

```

Let's see the TerminusDB woql query  
```js

  WOQL.select("v:Bike_Number", "v:End_Time", "v:Start_Time","v:Start_Label", "v:End_Label","v:Duration").and(
    WOQL.triple("v:Journey", "type", "scm:Journey"),
    WOQL.triple("v:Journey", "duration", "v:Duration"),
    WOQL.triple("v:Journey", "end_time", "v:End_Time"),
    WOQL.triple("v:Journey", "start_time", "v:Start_Time"),

    WOQL.triple("v:Journey", "start_station", "v:Start"),
    WOQL.opt().triple("v:Start", "label", "v:Start_Label"),

    WOQL.triple("v:Journey", "end_station", "v:End"),
    WOQL.opt().triple("v:End", "label", "v:End_Label"),

    WOQL.triple("v:Journey", "journey_bicycle", "v:Bike"),
    WOQL.opt().triple("v:Bike", "label", "v:Bike_Number")
  )

```


Could you guess that the TerminusDB schema model is an ontology (OWL) ? It is extremely difficult to express queries against graph structured ontology, but with our query language we are shielded from the complexity of interfacing with the ontology keeping the power of an ontology data model. ❗
You can not query an ontology with sql.


Let’s keep to practise ❗
