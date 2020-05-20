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

The TerminusDB Server includes a built in HTTP server which implements the Terminus API consisting of a number of endpoints which can be used to modify or query the system. 

The terminus administration schema ( http://terminusdb.com/schema/terminus ) contains definitions for all of the data structures and properties used in the API. All arguments and returned messages are encoded as JSON.

![](img/screenshots/terminus_client/api_calls.jpg)

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Connect

`GET http://<server>/`

Connects to a TerminusDB Server and receives a Capability Document which defines the client's permissions on the server.

### Example

```bash
curl -X GET http://localhost:6363/ --user 'username:password'
```

### Arguments

The username and password for the client to connect to the server needs to be supplied as basic-auth.
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

Post argument is a JSON document of the following form:

```json
    { "prefixes" : { "doc" : "http://my_document_prefix/document/",
                     "scm" : "http://my_document_prefix/schema#"}
      "label" : "A Label",
      "comment" : "A Comment"
    }
```

The prefixes "doc" and "scm" are required for normal operation of the
database. They help define the default location of new elements
greated with `idgen`, `hash` etc.

### Return

A terminus result message indicating either terminus:success or terminus:failure

```json
    { "terminus:status" : "terminus:success" }
```

## Delete Database

`DELETE http://<server>/db/<account>/<dbid>`

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

Retrieves the database triples for a graph encoded as turtle. This can
be used to dump graphs from the database for import to other
databases.

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

An update document with the contents of the turtle held by the "turtle" key.

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

The path following WOQL will set the default collection for the query. For
instance, if you specify `terminus`, you will see information from the
terminus core database (assuming that you have admin privileges). If
you specify `<dbid>/_meta` you will see the graph which contains
information about all repositories available for `<dbid>`.

For more information on collection descriptors, see: [Collection
Descriptors].


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
                                          "@value" : "Object"}}}'      \
   -H "Content-Type: application/json"
```

## Clone

```
POST http://<server>/clone/<account>/[<new_dbid>]
```

Allows you to clone a database which already exists into `[<new_dbid>]`.

### Arguments

The payload provides the **resource identifier of** the repo / db that we want
to clone.

If the new_dbid is provided, this id will be used locally to
refer to the DB, otherwise whatever the cloned name is will be used. 

```json
{ "clone": "http://hub.terminusdb.com/jimbob/special_sauces" }
```

### Example

```bash
curl -X POST --user 'admin:root' "http://localhost:6363/admin/into" \
   -d '{ "clone" : "http://hub.terminusdb.com/xlea/from" }'      \
   -H "Content-Type: application/json"
```

This clones the remote repository "from" on "terminusdb.com" into our
local database "into".

## Fetch

```
POST http://terminus.db/fetch/<account>/<dbid>/<repo_id>
```

Fetches all new commits from a remote repository. This enables you to
get current with a remote so that all changes since last fetch are now
stored locally.

### Arguments

The payload is the id of the last repository head commit. This is
visible in the graph `/<account>/<dbid>/_meta` on the repository of
interest under the `repository:repository_head` property.

### Example

```bash
curl -X POST --user 'admin:root' "http://localhost:6363/admin/into" \
   -d '{ "clone" : "http://hub.terminusdb.com/xlea/from" }'      \
   -H "Content-Type: application/json"
```

## Rebase

```
POST http://terminus.db/rebase/<account>/<dbid>/<repo>/branch/<branchid>
```

Replays commits from another branch or ref on top of the branch
identified in the URI. This allows you to merge changes originating
from elsewhere.

### Arguments
```json
{ "from": "db/repo/branch/other_branch" }
```
The "from" resource can be a resource identifier of a ref or branch.

## Push

```
POST http://terminus.db/push/<account>/<dbid>/<repo>
```
Pushes commits and all deltas from a repository to the repository origin. This allows a remote to obtain all deltas which were created locally.

### Arguments

None.

### Errors

This errors when the remote has advanced. This can be resolve with "fetch"+"rebase" or "pull".

## Branch

```
POST http://terminus.db/branch/<account>/<dbid>/<repo>/branch/<new_branchid>
```

Creates a new branch, enabling the user to split off from a current branch or ref to create a new updatable database which leaves the original unchanged.

### Arguments

We send a resource identifier specifying the base of the new branch to be created.

```json
{ "from" : "<resource>" }
```

### Example

```bash
curl -X POST --user 'admin:root' "http://localhost:6363/admin/into/local/branch/dev" \
   -d '{ "from" : "admin/into/local/branch/master" }'      \
   -H "Content-Type: application/json"
```

## Create graph

```
POST http://terminus.db/graph/<account>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>
```

Creates a new graph in a given branch as either instance, schema or inference with the name "graphid".

### Arguments

This takes a post parameter:

```json
    {"commit_info" : { "author" : Author, "message" : Message }}
```

## Delete graph

```
DELETE http://terminus.db/graph/<account>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>
```

Deletes the already existing graph from a given branch as either instance, schema or inference with the name "graphid".

### Arguments

This takes a post parameter:

```json
    {"commit_info" : { "author" : "Steinbeck", "message" : "My Commit Message" }}
```
