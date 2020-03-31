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

WOQL's primary syntax and interchange format is in JSON-LD. This gives us a relatively straightforward human-readable format which can also be easily stored in TerminusDB itself.

For example a simple query which allows us to retrieve all documents in the database, along with their labels and types:

```json
{"@context" : {"@import": "https://terminusdb/contexts/woql/syntax/context.jsonld",
               "@propagate": true,
               "db" : "http://localhost:6363/testDB004/"}, "from" : [ "db:main",
     {"select" : [ "v:Object", "v:Class", "v:Class_Label", "v:Label", "v:Type",
          {"and" : [{"triple" : ["v:Object", "rdf:type", "v:Class"] },
                    {"sub" : ["v:Class", "dcog:Entity"] },
                    {"eq" : ["v:Type", {"@value" :"Entity", "@type" : "xsd:string"}]},
                    {"quad" : ["v:Class", "rdfs:label", "v:Class_Label", "db:schema"]},
                    {"opt" : [{"triple" : ["v:Object", "rdfs:label", "v:Label"]}]}
                   ]}
                 ]}
          ]}
```

---

# WOQL JSON-LD Encoding

The default imported JSON-LD context at [https://terminusdb/contexts/woql/syntax/context.jsonld](https://terminusdb/contexts/woql/syntax/context.jsonld) allows the syntax to be less verbose by automatically adding "@id" to each of the syntactic elements and providing a default WOQL base URI. For example:

```json

{"@context" :
{
    "@version": 1.1,
    "@vocab": "http://terminusdb.com/woql#",
    "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
    "dcog" : "https://datachemist.net/ontology/dcog#",
    "v" : "http://terminusdb.com/woql/variable/",
    "select" : {"@type" : "@id"},
    "from" : {"@type" : "@id"},
    "and" : {"@type" : "@id"},
    "triple" : {"@type" : "@id"},
    "eq" : {"@type" : "@id" },
    "sub" : {"@type" : "@id" },
    "opt" : {"@type" : "@id"}
    ...
 }
}
```

---

# WOQLjs and WOQLpy

JSON, through an elegant way to pass queries to the database, it is not the most coding friendly. WOQLjs and WOQLpy provide a tool to construct WOQL queries with JavaScript and Python. They are included in their corresponding API client to construct WQOL queries. Query using WOQLjs and WOQLpy is also available in TerminusDB console. For details about WOQLjs and WOQLpy calls, please see the documentation of the API clients:

[JavaScript Client](https://terminusdb.github.io/terminus-client/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }[Python Client](https://terminusdb.github.io/terminus-client-python/){: .btn .fs-5 .mb-4 .mb-md-0 }

We assume most users will use WOQLjs or WOQLpy when constructing queries, hence most examples in this documentation will be in WOQLjs and/or WOQLpy.

---

# Creating Schema

---

# Loading Data into Database

---

# Querying Database

---
