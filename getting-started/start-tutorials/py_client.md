---
layout: default
title: Create TerminusDB Graph with Python Client
parent: Getting started tutorials
grand_parent: Getting started
nav_order: 2
---

# Create TerminusDB Graph with Python Client
{: .no_toc }

**Note that this tutorial is based on TerminusDB v1.0. Tutorial for new version coming soon.**

In here you will see a step-by-step guide to create your first knowledge with Terminus DB Python Client in Jupyter notebook. We assume already have [Jupyter notebook](https://jupyter.org/install) and [TerminusDB Python Client (with woqlDataframe)](/docs/getting-started/install-clients/#python-client) installed and have TerminusDB up and running.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Create a database

First, import `WOQLClient`, `WOQLQuery` and `query_to_df` form the client library:

```python
from woqlclient import WOQLClient
from woqlclient import WOQLQuery
from woqlclient import query_to_df
```

Then set up server_url and key for the client. For a local database, it's "http://localhost:6363" and "root" by default. Here we use the [docker image of TerminusDB](/docs/getting-started/quick-install/).

We also need a database id and a name for the database:

```python
server_url = "http://localhost:6363"
key = "root"
dbId = "pybike"
db_name = "Bicycle Graph"
```

After that, create a WOQLClient object and use `connect()` and `createDatabase()`.

```python
client = WOQLClient()
client.connect(server_url, key)
client.createDatabase(dbId, db_name)
```

Go to the [console](http://localhost:6363/console), we should now have the database created.

---

## Create a Schema

To create a schema, we construct a WOQLQuery object `schema` that will create a schema and use `execute()` to pass this query to TerminusDB via the client that we set up in the previous step.

```python
def create_schema(client):
    """The query which creates the schema
        Parameters - it uses variables rather than the fluent style as an example
        ==========
        client : a WOQLClient() connection
    """
    schema = WOQLQuery().when(True).woql_and(
        WOQLQuery().doctype("Station").
            label("Bike Station").
            description("A station where bikes are deposited"),
        WOQLQuery().doctype("Bicycle").label("Bicycle"),
        WOQLQuery().doctype("Journey").label("Journey").
            property("start_station", "Station").label("Start Station").
            property("end_station", "Station").label("End Station").
            property("duration", "integer").label("Journey Duration").
            property("start_time", "dateTime").label("Time Started").
            property("end_time", "dateTime").label("Time Ended").
            property("journey_bicycle", "Bicycle").label("Bicycle Used")
    )
    return schema.execute(client)

create_schema(client)
```

To review this schema-building WOQL query:

1. The when will perform the operation for every time its first argument is True. In this case, exactly once.
2. We perform all operations within the and.

So here’s the operations we have performed:

1. We created three different document types (given by the `doctype` function): `Station` , `Journey` and `Bicycle`
2. We added `label` (names) or `description` (short descriptions) to them.
3. We created properties for `Journey`, we do that by using the `property` function after `Journey` with the first argument as the name of the property and the second argument as the type (or range) of the property.
4. For each property, you have to provide an id and the type of that property in `property`, as with class you can add a `label` to it as well.

Go to the [console](http://localhost:6363/console), check that you have successfully created the schema by clicking the Schema button on the left. You should now be able to see the classes and properties in table format and get a graph representation by clicking the ‘graph’ button (circled in red):

![showing classes in schema](https://miro.medium.com/max/2756/1*1e2iw6CJnWm3NWTFuc9HKw.png)

![graph of the classes in schema](https://miro.medium.com/max/2780/1*x95n_XNGsO5-pNJci1iTJA.png)

![showing properties in schema](https://miro.medium.com/max/2754/1*ty448DHo8KcoUsFZGJ8n_Q.png)

![graph of the properties in schema](https://miro.medium.com/max/2736/1*xY5-Liid961dk1T-GfuE3g.png)

---

## Load in the Data

Assume we have a list of csvs that we would like to load.

```python
csvs = [
    "https://terminusdb.com/t/data/bikeshare/2011-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2012Q1-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2010-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2012Q2-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2012Q3-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2012Q4-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2013Q1-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2013Q2-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2013Q3-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2013Q4-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2014Q1-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2014Q2-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2014Q3-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2014Q4-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2015Q1-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2015Q2-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2015Q3-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2015Q4-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2016Q1-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2016Q2-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2016Q3-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2016Q4-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2017Q1-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2017Q2-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2017Q3-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/2017Q4-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201801_capitalbikeshare_tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201802-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201803-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201804-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201805-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201806-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201807-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201808-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201809-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201810-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201811-capitalbikeshare-tripdata.csv",
    "https://terminusdb.com/t/data/bikeshare/201812-capitalbikeshare-tripdata.csv"
]
```
These are hosted on a server, for

The process of loading csvs consist of 3 parts:

- reading the csvs in a temporary space and assign variables to them
- perform data wrangles which prepare the data in the temporary space fit for our schema
- insert the inputs into the graph database according to the schema.

### Get csvs into variables

```python
def get_csv_variables(url):
    """Extracting the data from a CSV and binding it to variables
       Parameters
       ==========
       client : a WOQLClient() connection
       url : string, the URL of the CSV
       """
    csv = WOQLQuery().get(
        WOQLQuery().woql_as("Start station", "v:Start_Station").
        woql_as("End station", "v:End_Station").
        woql_as("Start date", "v:Start_Time").
        woql_as("End date", "v:End_Time").
        woql_as("Duration", "v:Duration").
        woql_as("Start station number", "v:Start_ID").
        woql_as("End station number", "v:End_ID").
        woql_as("Bike number", "v:Bike").
        woql_as("Member type", "v:Member_Type")
    ).remote(url)
    return csv
```

This function consist the part of the query that imports the data from CSV in a `const` variable named `csv`. Then we create a list of WOQL operators and save it in another constvariable called `wrangles`, we combine the two parts of the query with a `woql_and` operator.

### Data wrangles

```python
def get_wrangles():
    wrangles = [
        WOQLQuery().idgen("doc:Journey", [
            "v:Start_ID", "v:Start_Time", "v:Bike"], "v:Journey_ID"),
        WOQLQuery().idgen("doc:Station", [
            "v:Start_ID"], "v:Start_Station_URL"),
        WOQLQuery().cast("v:Duration", "xsd:integer", "v:Duration_Cast"),
        WOQLQuery().cast("v:Bike", "xsd:string", "v:Bike_Label"),
        WOQLQuery().cast("v:Start_Time", "xsd:dateTime", "v:Start_Time_Cast"),
        WOQLQuery().cast("v:End_Time", "xsd:dateTime", "v:End_Time_Cast"),
        WOQLQuery().cast("v:Start_Station", "xsd:string", "v:Start_Station_Label"),
        WOQLQuery().cast("v:End_Station", "xsd:string", "v:End_Station_Label"),
        WOQLQuery().idgen("doc:Station", ["v:End_ID"], "v:End_Station_URL"),
        WOQLQuery().idgen("doc:Bicycle", ["v:Bike_Label"], "v:Bike_URL"),
        WOQLQuery().concat("Journey from v:Start_ID to v:End_ID at v:Start_Time", "v:Journey_Label"),
        WOQLQuery().concat("Bike v:Bike from v:Start_Station to v:End_Station at v:Start_Time until v:End_Time",
                           "v:Journey_Description")
    ]
    return wrangles
```

The `wrangles` is a list of WOQLQuery objects. They use 3 WOQL functions to transform the data into the correct form for input. In each case, the function creates a new variable as output — the last argument in each case. The `idgen` function generates IDs for our three document types `Journey`, `Station`, and `Bicycle`. The first argument is the prefix that will be used, the second is a list of variables which combine to give a unique identity for the id. For example, in `Journey` we use 3 fields in the `csv` (`Start_ID`, `Start_Time` and `Bike`) to generate a unique id `Journey_ID`.

Besides generating IDs, we also create new fields with new data types, for example, we use `typecast` to cast `Duration` into `integer` and store it as `Duration_Cast`. We can also use `concat` to contract new text formatted with variables in the fields — for example, to create `Journey_Label`.

### Insert Query

```python
def get_inserts():
    inserts = WOQLQuery().woql_and(
        WOQLQuery().insert("v:Journey_ID", "Journey").
            label("v:Journey_Label").
            description("v:Journey_Description").
            property("start_time", "v:Start_Time_Cast").
            property("end_time", "v:End_Time_Cast").
            property("duration", "v:Duration_Cast").
            property("start_station", "v:Start_Station_URL").
            property("end_station", "v:End_Station_URL").
            property("journey_bicycle", "v:Bike_URL"),
        WOQLQuery().insert("v:Start_Station_URL", "Station").
            label("v:Start_Station_Label"),
        WOQLQuery().insert("v:End_Station_URL", "Station").
            label("v:End_Station_Label"),
        WOQLQuery().insert("v:Bike_URL", "Bicycle").
            label("v:Bike_Label")
    )
    return inserts
```

This is the part of the query that actually inserts the data into the structure that we defined on our schema.

* The `insert` function inserts a new node into the database with the id `Journey_ID` and type `Journey` we add properties like `start_time`, `end_time`, `duration`, `start_station`, `end_station` and `label` and put the variables produced above in their correct spots.
* For `Start_Station_URL`, `End_Station_URL` and `Bike_URL`, we assign a `type` and `label` for each of them.

### Combine the 3 and load the csvs

```python
def load_csvs(client, csvlist, wrangl, insert):
    """Load the CSVs as input
       Parameters
       ==========
       client : a WOQLClient() connection
       csvs : a dict of all csvs to be input
    """
    for url in csvlist:
        csv = get_csv_variables(url)
        inputs = WOQLQuery().woql_and(csv, *wrangl)
        answer = WOQLQuery().when(inputs, insert)
        answer.execute(client)

load_csvs(client, csvs, get_wrangles(), get_inserts())
```

Here, for each url in the list above (a list named csvs) we combine the result of `get_csv_variables` and result of `get_wrangles` with a `woql_and` and called it `inputs`. When the `inputs` are ready, perform get_inserts.

---

## Query The Data

```python
def query_data(client):
    """The query which query the database
        Parameters - it uses variables rather than the fluent style as an example
        ==========
        client : a WOQLClient() connection
    """
    conditions = [WOQLQuery().triple("v:Journey", "type", "scm:Journey"),
                  WOQLQuery().triple("v:Journey", "start_station", "v:Start"),
                  WOQLQuery().opt().triple("v:Start", "label", "v:Start_Label"),
                  WOQLQuery().triple("v:Journey", "end_station", "v:End"),
                  WOQLQuery().opt().triple("v:End", "label", "v:End_Label"),
                  WOQLQuery().triple("v:Journey", "journey_bicycle", "v:Bike")]
    query = WOQLQuery().select("v:Start",
                               "v:Start_Label",
                               "v:End",
                               "v:End_Label").woql_and(*conditions)
    return query.execute(client)

result = query_data(client)
```

Here we used `select` to filter out the variables (those starting with `v:`) that appear in our output. Then we used `and` to link all the conditions we want to include, as you can see there are lot's of `triples` to be conditioned. The ones with `opt()` means that they are optional — it will be ignored if that data is missing (instead of returning an error — very handy).

The query can be translated as below:

1. select all the `Journeys`
2. and all the `start_stations` of all the `Journeys` (let's call them `Start`)
3. and, if any, all the `labels` of the `start_stations` (let's call them `Start_Label`)
4. and all the `end_stations` of all the `Journeys` (let's call them `End`)
5. and, if any, all the `labels` of the `end_stations` (let's call them `End_Label`)
6. and all the `journey_bicycles` of all the `Journeys` (let's call them `Bike`)

Note that we store the result as a variable which can be used with `query_to_df` to turn it into a pandas DataFrame

```python
query_to_df(result)
```

![Result as a DataFrame](../..//assets/images/console/result_as_df.png)

---

## Graph Visualisation

Graph Visualisation can be created in the TerminusDB console, please see the [Graph Visualisation session at Create TerminusDB Graph with Console](/docs/getting-started/start-tutorials/console_js/#graph-visualisation).
