---
layout: default
title: Import and Clean Data in Python
parent: How Tos
nav_order: 12
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

```python
#!/usr/bin/python3

from terminusdb_client import WOQLClient
from terminusdb_client import WOQLQuery as WQ

server_url = "https://127.0.0.1:6363"
user = "admin"
account = "admin"
key = "root"
db = "roster"
repository = "local"
label = "Roster CSV Example"
description = "An example database for playing with bank accounts"
client = WOQLClient(server_url)
client.connect(user=user, account=account, key=key, db=db)

#client.delete_database(db)
try:
    client.create_database(db,account,label=label,
                           description=description,
                           include_schema=None)
except Exception as E:
    pass

query = WQ().woql_and(
    WQ().get(WQ().woql_as("Name","v:Name")
                 .woql_as("Registration_Date", "v:Date")
                 .woql_as("Paid", "v:Paid")
            ).post('roster.csv'),
    WQ().idgen("doc:RosterRecord",["v:Name","v:Date","v:Paid"],"v:ID"),
    WQ().add_triple("v:ID","scm:name","v:Name"),
    WQ().add_triple("v:ID","scm:date","v:Date"),
    WQ().add_triple("v:ID","scm:paid","v:Paid"))
client.query(query,
    "Adding Roster Data",
    {'roster.csv' : '/home/gavin/tmp/roster.csv'}
    )
```

The `get` loads our csv from a post variable `roster.csv`. We will
pass the path for this to the client when we execute the query.

We can also load a URL which contains the csv using instead the
`remote` keyword.

The first argument of the `woql_as` is the column header name, the
second is the name of the variable which will carry this data.

We want to construct an URI identifier which carries a unique
representation of the record from the roster. We can do this with
`idgen` which will create a valid id from the *key* for us.

The final `add_triple` simply adds the information for this property
to the database.

## Turtle / RDF

For RDF ingestion TerminusDB can read directly from a TTL file with
get, as above, if you supply the `type` flag. If you don't have a TTL
file, you should use on of the abundant RDF tools from transforming
RDF into TTL.

```python
#!/usr/bin/python3

from terminusdb_client import WOQLClient
from terminusdb_client import WOQLQuery as WQ

server_url = "https://127.0.0.1:6363"
db = "api"
label = "API"
description="The API Ontology"
user = "admin"
account = "admin"
key = "root"
client = WOQLClient(server_url)
client.connect(user=user, account=account, key=key, db=db)

try:
    client.create_database(db,account,label=label,
                           description=description,
                           include_schema=None)
except Exception as E:
    print(E)

[x,y,z] = WQ().vars("x","y","z")
query = WQ().get(
    WQ().woql_as(x).woql_as(y).woql_as(z)
).post("api.owl.ttl",
       {"type" : "turtle"})
client.query(query,
             "Adding turtle file contents",
             {"api.owl.ttl" : "/home/me/tmp/api.owl.ttl")
```

This will load the turtle file designated as
`"/home/me/tmp/api.owl.ttl"` into the current database.

## Larger TTLs

The above method is best used if you want to load small files or
transform the data, or mix and match with other import files during
import.

However, if you're just trying to load a large number of triples, it
is better to use the triples client interface.

### Medium Data Sets

If you have fewer than 500k triples (perhaps called `my_triples.ttl`)
you can load it as follows:

```python
#!/usr/bin/python3

from terminusdb_client import WOQLClient
from terminusdb_client import WOQLQuery as WQ

server_url = "https://127.0.0.1:6363"
db = "my_triples"
label = "My Triples"
description="My Triples"
user = "admin"
account = "admin"
key = "root"
filename = "my_triples.ttl"
client = WOQLClient(server_url)
client.connect(user=user, account=account, key=key, db=db)

try:
    client.create_database(db,account,label=label,
                           description=description,
                           include_schema=None)
except Exception as E:
    print(E)

ttl_file = open(filename)
contents = ttl_file.read()
ttl_file.close()
client.insert_triples(
    "instance","main",
    contents,
    f"Adding my triples")
```


### Larger Data Sets

If you have a rather large file (>500k triples) you should process it
by chunking it.

For example, if we want to load the
[Person](https://downloads.dbpedia.org/repo/dbpedia/generic/persondata/2020.07.01/persondata_lang=en.ttl.bz2))
data, we can process it as follows:

First, we download this file and unpack it. Since the dataset is
large, we will move the ttl into a folder and split it into chunks.

From linux on the command line this can be achieved with a programme
like `split`.

```bash
split -l 100000 persons.ttl
```

If we put these files into a subfolder named 'persons_100k' we can
then iterate over them and insert them as follows:

```python
import os
import time
from terminusdb_client import WOQLClient
from terminusdb_client import WOQLQuery as WQ


server_url = "https://127.0.0.1:6363"
db = "person"
db_label = "Persons"
db_comment = "A Database of People"
directory = 'persons_100k'
user = "admin"
account = "admin"
key = "root"
client = WOQLClient(server_url)
client.connect(user=user, account=account, key=key, db=db)

try:
    client.delete_database(db)
except Exception as E:
    print(E)

client.create_database(db,account,label=f"{db_label}",
                       include_schema=False,
                       description=f"All DBPedia {db} data")

times = []
for f in os.listdir(directory):
    filename = f'{directory}/{f}'
    ttl_file = open(filename)
    contents = ttl_file.read()
    ttl_file.close()
    before = time.time()
    client.insert_triples(
        "instance","main",
        contents,
        f"Adding persondata in 100k chunk ({f})")
    after = time.time()
    total = (after - before)
    times.append(total)
    print(f"Update took {total} seconds")

print(times)
```
The heavy lifting here is again done by `client.insert_triples`.

You should be able to load files in excess of 30 million triples this
way.
