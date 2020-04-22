---
layout: default
title: TerminusDB API
parent: User guide
nav_order: 5
has_children: true
permalink: /docs/user-guide/api
---

# TerminusDB API
{: .no_toc }

The TerminusDB Server includes a built in HTTP server which implements the Terminus API consisting of the following endpoints:

- Connect
  - `GET http://<server>/`
- Create database
  - `POST http://<server>/db/<account>/<dbid>`
- Delete database
  - `DELETE http://<server>/db/<account>/<dbid>`
- Get triples
  - `GET http://<server>/triples/<account>/<dbid>/<repo>/branch/<branchid>/<type>/<schema_graphid>`
  - `GET http://<server>/triples/<account>/<dbid>/<repo>/commit/<refid>/<type>/<schema_graphid>`
- Update triples
  - `POST http://<server>/triples/<account>/<dbid>/local/branch/<branchid>/<type>/<schema_graphid>`
- Class frame
  - `GET http://<server>/frame/<account>/<dbid>/<repo>/branch/<branchid>`
  - `GET http://<server>/frame/<account>/<dbid>/<repo>/commit/<refid>`
- Clone
  - `POST http://<server>/clone/<account>/<new_dbid>`
- Fetch
  - `POST http://<server>/fetch/<account>/<dbid>/<repo_id>`
- Rebase
  - `POST http://<server>/rebase/<account>/<dbid>/<repo>/branch/<branchid>`
- Push
  - `POST http://<server>/push/<account>/<dbid>/<repo>/branch/<branchid>`
- Branch
  - `POST http://<server>/branch/<account>/<dbid>/<repo>/branch/<new_branchid>`
- Create graph
  - `POST http://<server>/graph/<account>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>`
- Delete graph
  - `DELETE http://<server>/graph/<account>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>`
- Woql Query
  - `POST http://<server>/woql/<account>/<dbid>`
  - `POST http://<server>/woql/<account>/<dbid>/_meta`
  - `POST http://<server>/woql/<account>/<dbid>/<repo>`
  - `POST http://<server>/woql/<account>/<dbid>/<repo>/_commit`
  - `POST http://<server>/woql/<account>/<dbid>/<repo>/branch/<branchid>`
  - `POST http://<server>/woql/<account>/<dbid>/<repo>/commit/<refid>`

The terminus administration schema ( http://terminusdb.com/schema/terminus ) contains definitions for all of the data structures and properties used in the API. All arguments and returned messages are encoded as JSON.

![](img/screenshots/terminus_client/api_calls.jpg)

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Connect

Connects to a TerminusDB Server and receives a Capability Document which defines the client's permissions on the server.

### Example

```bash
curl -X GET http://localhost:6363/ --user 'username:password'
```

### Arguments

The username and password for the client to connect to the server needs to be supplied as basic auth.
Depending if the server has been compiled with JWT support, the authentication can be a JWT token
with the `https://terminusdb.com/nickname` key provided as the username.

### Return

A document of type terminus:Capability (or one of its subclasses) http://terminusdb.com/schema/terminus#Capability

```json
"@context": {
    "doc":"http://localhost/terminus/document/",
    "owl":"http://www.w3.org/2002/07/owl#",
    "rdf":"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "rdfs":"http://www.w3.org/2000/01/rdf-schema#",
    "terminus": "http://terminusdb.com/schema/terminus#"
  },
  "@id":"doc:admin",
  "@type":"terminus:User",
  "rdfs:comment": {"@language":"en", "@value":"This is the server super user account"},
  "rdfs:label": {"@language":"en", "@value":"Server Admin User"},
  "terminus:authority": {
    "@id":"doc:access_all_areas",
    "@type":"terminus:ServerCapability",
    "rdfs:comment": {"@language":"en", "@value":"Access all server functions"},
    "rdfs:label": {"@language":"en", "@value":"All Capabilities"},
    "terminus:action": [
      {"@id":"terminus:class_frame", "@type":"terminus:DBAction"},
      {"@id":"terminus:create_database", "@type":"terminus:DBAction"},
      {"@id":"terminus:create_document", "@type":"terminus:DBAction"},
      {"@id":"terminus:delete_database", "@type":"terminus:DBAction"},
      {"@id":"terminus:delete_document", "@type":"terminus:DBAction"},
      {"@id":"terminus:get_document", "@type":"terminus:DBAction"},
      {"@id":"terminus:get_schema", "@type":"terminus:DBAction"},
      {"@id":"terminus:update_document", "@type":"terminus:DBAction"},
      {"@id":"terminus:update_schema", "@type":"terminus:DBAction"},
      {"@id":"terminus:woql_select", "@type":"terminus:DBAction"},
      {"@id":"terminus:woql_update", "@type":"terminus:DBAction"}
    ],
    "terminus:authority_scope": [
      {
        "@id":"doc:dima",
        "@type":"terminus:Database",
        "rdfs:comment": {
          "@language":"en",
          "@value":"This is a DB created for Dima to test the ontoogies"
        },
        "rdfs:label": {"@language":"en", "@value":"Dima Test DB"},
        "terminus:allow_origin": {"@type":"xsd:string", "@value":"*"},
        "terminus:id": {
          "@type":"xsd:anyURI",
          "@value":"http://localhost/dima"
        },
        "terminus:instance": {"@type":"xsd:string", "@value":"document"},
        "terminus:schema": {"@type":"xsd:string", "@value":"schema"}
      },
      {
        "@id":"doc:documentation",
        "@type":"terminus:Database",
        "rdfs:comment": {"@language":"en", "@value":"This is the documentation db"},
        "rdfs:label": {"@language":"en", "@value":"Documentation database"},
        "terminus:allow_origin": {"@type":"xsd:string", "@value":"*"},
        "terminus:id": {
          "@type":"xsd:anyURI",
          "@value":"http://localhost/documentation"
        },
        "terminus:instance": {"@type":"xsd:string", "@value":"document"},
        "terminus:schema": {"@type":"xsd:string", "@value":"schema"}
      },
      {
        "@id":"doc:terminus",
        "@type":"terminus:Database",
        "rdfs:comment": {
          "@language":"en",
          "@value":"The master database contains the meta-data about databases, users and roles"
        },
        "rdfs:label": {"@language":"en", "@value":"Master Database"},
        "terminus:allow_origin": {"@type":"xsd:string", "@value":"*"},
        "terminus:id": {
          "@type":"xsd:anyURI",
          "@value":"http://localhost/terminus"
        }
      },
      {
        "@id":"doc:server",
        "@type":"terminus:Server",
        "rdfs:comment": {
          "@language":"en",
          "@value":"The current Database Server itself"
        },
        "rdfs:label": {"@language":"en", "@value":"The DB server"},
        "terminus:allow_origin": {"@type":"xsd:string", "@value":"*"},
        "terminus:id": {"@type":"xsd:anyURI", "@value":"http://localhost"},
        "terminus:resource_includes": [
          {"@id":"doc:dima", "@type":"terminus:Database"},
          {"@id":"doc:documentation", "@type":"terminus:Database"},
          {"@id":"doc:terminus", "@type":"terminus:Database"}
        ]
      }
    ]
  }
}
```

## Create Database

```
POST http://<server>/db/<account>/<dbid>
```

Create a new database ex nihilo.

### Example

```bash
curl -X POST http://localhost:6363/db/dima/test --user 'username:password'
```

### Arguments

Post argument is a JSON document of the following form

```json
    { <"base_uri" : MY_BASE_DOCUMENT_URI>,
      "label" : "A Label",
      "comment" : "A Comment"
    }
```

Base_URI will default to `http://hub.terminusdb.com/<account>/<db>/document/`

Hub create DB will POST [http://terminus.db/](http://terminus.db/DBNAME)db/account/dbid with

```json
    { "base_uri" : "http://hub.terminusdb.com/account/db" }
```

### Return

A terminus result message indicating either terminus:success or terminus:failure

```json
    { "terminus:status" : "terminus:success" }
```

## Delete Database

Deletes an entire Database.

Sends a HTTP DELETE request to the URL of the Database on a Terminus Server

```bash
curl -X DELETE --user 'user:secret_key' http://localhost:6363/dima/test
```

### Return

A terminus result message indicating either terminus:success or terminus:failure

```json
    { "terminus:status" : "terminus:success" }
```

## Get Triples

```
GET http://<server>/triples/<account>/<dbid>/<repo>/branch/<branchid>/<type>/<schema_graphid>`
GET http://<server>/triples/<account>/<dbid>/<repo>/commit/<refid>/<type>/<schema_graphid>
```

Retrieves the database triples for a graph as a turtle encoding.

### Example
```bash
curl --user ':secret_key'  http://localhost/dima/test/local/branch/master/instance/main
```

### Arguments:

    None

### Return

The database schema encoded as a JSON string containing the contents of a turtle file

    "@prefix rdf: pre>http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
     @prefix
        ... OWL schema serialised as turtle ...
    "

## Update Triples

```
POST http://<server>/triples/<account>/<dbid>/local/branch/<branchid>/<type>/<schema_graphid>
```

Updates the specified graph by posting a new turtle version. Updates are atomic - the entire graph is replaced by the updated version by producing the necessary delta automatically.

### Example

```
curl --user 'user:secret_key' -d "@my-schema.ttl" -X POST http://localhost:6363/triples/dima/test/local/branch/master/schema/main
```

### Argument

A terminus:APIUpdate document with the contents of the turtle held by the terminus:turtle predicate.

```json
    { "turtle": "@prefix rdf:
                 ... OWL schema serialised as turtle ...",
      "commit_info": { "author" : "dima", "message" : "Fixing frob class" }
    }
```

### Return

A terminus result message indicating either terminus:success or terminus:failure

```json
      {"terminus:status":"terminus:success"}
```

## Class Frame
```
    GET http://<server>/frame/<account>/<dbid>/<repo>/branch/<branchid>
    GET http://<server>/frame/<account>/<dbid>/<repo>/commit/<refid>
```

Retrieves a frame representation of a class within the ontology - a json representation of all the logic contained in the class.

### Example

```bash
    curl -X GET --user 'admin:secret_key' "http://localhost:6363/dima/test/local/branch/master"
```
### Argument

The class that the frame is for must be passed in the terminus:class property

```json
    { "class" : "http://terminusdb.com/schema/terminus#Agent"
    }
```

### Return

An array of frames, each of which is encoded as a JSON-LD frame document and each of which represents a single property in the class frame.

```json

```

## WOQL Query

```
POST http://<server>/woql/
POST http://<server>/woql/terminus
POST http://<server>/woql/<account>/<dbid>
POST http://<server>/woql/<account>/<dbid>/_meta
POST http://<server>/woql/<account>/<dbid>/<repo>
POST http://<server>/woql/<account>/<dbid>/<repo>/_commit
POST http://<server>/woql/<account>/<dbid>/<repo>/branch/<branchid>
POST http://<server>/woql/<account>/<dbid>/<repo>/commit/<refid>
```

WOQL select allows users to perform queries from WOQL. The default
query object is formed from the path. No path means no default query
source.

### Example

```bash
curl -X POST --user 'admin:root' "http://localhost:6363/woql/terminus" \
   -d '{ "@type" : "Triple",                                           \
         "subject" : { "@type" : "Variable",                           \
                       "variable_name" : { "@type" : "xsd:string",     \
                                           "@value" : "Subject"}},     \
         "predicate" : { "@type" : "Variable",                         \
                         "variable_name" : { "@type" : "xsd:string",   \
                                             "@value" : "Predicate"}}, \
         "object" : { "@type" : "Variable",                            \
                      "variable_name" : { "@type" : "xsd:string",      \
                                          "@value" : "Object"}}}' 
```

## WOQL Update

To be documented

## Metadata

`GET http://terminus.db/DBNAME/metadata`

The metadata associated with a database can be retrieved with a GET to the `metadata`.

    curl --user 'username:secret_key' -X GET -H 'Content-Type: application/json' 'http://localhost:6363/terminus/metadata' 

### Return

A `terminus:DatabaseMetadata` object is returned whose structure is as follows:

    {
      "@context": {
        "doc":"http://localhost:6363/terminus/document/",
        "owl":"http://www.w3.org/2002/07/owl#",
        "rdf":"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "rdfs":"http://www.w3.org/2000/01/rdf-schema#",
        "scm":"http://localhost:6363/terminus/schema#",
        "tbs":"http://terminusdb.com/schema/tbs#",
        "tcs":"http://terminusdb.com/schema/tcs#",
        "terminus":"http://terminusdb.com/schema/terminus#",
        "vio":"http://terminusdb.com/schema/vio#",
        "xdd":"http://terminusdb.com/schema/xdd#",
        "xsd":"http://www.w3.org/2001/XMLSchema#"
      },
      "@type":"terminus:DatabaseMetadata",
      "terminus:database_created_time": {
        "@type":"xsd:dateTime",
        "@value":"2019-09-30T09:42:26+00:00"
      },
      "terminus:database_modified_time": {"@type":"xsd:dateTime", "@value":"2019-09-30T09:42:26+00:00"},
      "terminus:database_size": {"@type":"xsd:nonNegativeInteger", "@value":113781}
    }


## Clone

POST [http://terminus.db/](http://terminus.db/DBNAME)clone/<account>/[<new_dbid>]

### Arguments

The payload is the **resource identifier of** repo / db that we want to clone. If the new_dbid is provided, this id will be used locally to refer to the DB, otherwise whatever the cloned one uses will be used. 

    {
       @type: "terminus:APIUpdate"
       terminus:resource: URI_OF_RESOURCE_ID
    }

## Fetch

    POST http://terminus.db/fetch/<account>/<dbid>/<repo_id>

POST is empty

    POST http://terminus.db/fetch/<account>/<dbid>/ = http://terminus.db/fetch/<dbid>/origin

## Rebase

    POST http://terminus.db/rebase/<account>/<dbid>/<repo>/<branchid>/[<remote_repo_id>]/[<remote_branch_id>]

Merges deltas from remote_repo_id into dbid/branchid

POST is **empty**

Rebases into dbid/branchid

    POST http://terminus.db/rebase/<account>/<dbid>/<repo>/<branchid> = http://terminus.db/rebase/<dbid>/<branchid>/origin/master

## Push

    POST http://terminus.db/push/<account>/<dbid>/<repo>/<branchid>/[<remote_repo_id>]/[<remote_branch_id>]

Pushes deltas from dbid / branchid the remote repo

POST is empty

e.g.

    http://terminus.db/push/dbid = http://terminus.db/push/dbid/master/origin/master


## Branch

POST http://terminus.db/branch/<account>/<dbid>/<repo>/<new_branchid>

Creates a new branch with parent dbid/new_branchid

### Arguments

POST is a **terminus:Ref resource ID** specifying the base of the new branch to be created.

    {
       "@type" : "terminus:APIUpdate"
       "terminus:resource" : URI_OF_REF_RESOURCE_ID
    }

## Create graph

POST http://terminus.db/graph/<account>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>

### Arguments

This takes a post parameter:

    {"commit_info" : { "author" : Author, "message" : Message }}

## Delete graph

    DELETE http://terminus.db/graph/<account>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>

### Arguments

This takes a post parameter:

    {"commit_info" : { "author" : Author, "message" : Message }}
