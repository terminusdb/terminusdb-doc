---
layout: default
title: API
parent: Server
grand_parent: Reference
nav_order: 3
---

# API
{: .no_toc }

The TerminusDB Server HTTP API. JSON documents have optional elements notated with angle-brackets, for instance:

```jsx
{
  <"optional" : "foo">,
  "required" : "bar"
}
```

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Connect

```jsx
GET http://localhost:6363/
```

The Connect API endpoint returns the `system:User` object associated
with the authentication provided (as documented in the
`system_schema.owl.ttl` ontology). If no authentication is provided,
the user will be the predefined `terminusdb:///system/data/anonymous`
user.

## Create Database

```jsx
POST http://localhost:6363/db/<organization>/<dbid>
```

Post argument is a JSON document of the following form

```jsx
{ < "prefixes" : { < "doc" : Document_Prefix >,
                   < "scm" : Schema_Prefix > } >
  "label" : "A Label",
  "comment" : "A Comment",
  < "public" : Boolean >,
  < "schema" : Boolean >
}
```
Create a new database with database ID `dbid` for organization `organization`.

Default prefixes associated with document and schema can be specified.

Both `label` and `comment` are required fields, which will be the
display name of the database and its description.

The `public` boolean will determine if this database has read visibility
to the anonymous user. It defaults to false.

The `schema` boolean will determine if this database is created with
an empty schema, or if it is running in "schema free" mode. It
defaults to false.

## Delete Database

```jsx
DELETE http://localhost:6363/<organization>/<dbid>
```
Delete the database with organisation <organization> and database ID, `dbid`.

## Get Triples

```jsx
GET http://localhost:6363/triples/<organization>/<dbid>/<repo>/branch/<branchid>/<type>/<name><?format=turtle>
GET http://localhost:6363/triples/<organization>/<dbid>/<repo>/commit/<refid>/<type>/<name><?format=turtle>
```

This call returns a "Turtle" format file representation of the graph
specified in the URL path as a JSON string. It takes a get parameter
`format` which must always be "turtle". In the future we hope to
support other formats.

## Update Triples

```jsx
POST http://localhost:6363/triples/<organization>/<dbid>/local/branch/<branchid>/<type>/<name>
```
Post argument is a JSON document of the following form

```jsx
{ "turtle" : TTL_String,
  "commit_info" : { "author" : Author, "message" : Message } }
```

This call creates the update required to make the graph referred to in
the URL have exactly the triples specified in the `turtle` field of
the JSON document. It must be supplied with a commit message (though
it can be an empty string).

## Query

```jsx
POST http://localhost:6363/woql
POST http://localhost:6363/woql/<organization>/<dbid>
POST http://localhost:6363/woql/<organization>/<dbid>/_meta
POST http://localhost:6363/woql/<organization>/<dbid>/<repo>
POST http://localhost:6363/woql/<organization>/<dbid>/<repo>/_commits
POST http://localhost:6363/woql/<organization>/<dbid>/<repo>/branch/<branchid>
POST http://localhost:6363/woql/<organization>/<dbid>/<repo>/commit/<refid>
```

Post argument is a JSON document of the following form

```jsx
{ <"commit_info" : { "author" : Author, "message" : Message } >,
  "query" : Query }
```

The commit message is a requirement if an update is being made, whereas `query` should be a JSON-LD object as specified by the ontology `woql.owl.ttl`.

This API call performs a WOQL query and returns an `api:WoqlResponse`
result object, which has the form:

```jsx
{ "@type" : "api:WoqlResponse",
  "api:status" : "api:success",
  "api:variable_names" : Variable_Names,
  "bindings" : Bindings,
  "inserts" : Number_Of_Inserts,
  "deletes" : Number_Of_Deletes,
  "transaction_retry_count" : Retries
  }
```

## Clone

```jsx
POST http://localhost:6363/clone/<organization>/[<new_dbid>]
```

The JSON payload is:

```jsx
{
   "comment" : Comment,
   "label" : Label,
   "remote_url" : Remote,
   < "public" : Bool >
}
```

The API call creates a new database under the same DB ID as the cloned
database, or with the new database ID `new_dbid` if provided.

The other options are exactly as with create db.

## Fetch

```jsx
POST http://localhost:6363/fetch/<organization>/<dbid>
```

Fetches new layers from the remotes for this database along with the
commit history.

## Rebase

```jsx
POST http://localhost:6363/rebase/<organization>/<dbid>[/<repo>/branch/<branchid>]
```

The JSON payload is:

```jsx
{
   "rebase_from" : Resource,
   "author" : Author,
}
```

The `rebase_from` contains an absolute string descriptor for the reference we are rebasing from. It may be a ref or a branch. Author should be the author of the newly produced commits.

This operation will attempt to construct a new history which has the
same contents as that given by "rebase_from" by repeated application
of diverging commits.

## Push

```jsx
POST http://localhost:6363/push/<organization>/<dbid>[/<repo>/branch/<branchid>/]
```

Pushes deltas from this database to the remote repository.

## Pull

```jsx
POST http://localhost:6363/push/<organization>/<dbid>[/<repo>/branch/<branchid>/]
```
JSON API document is:

```jsx
{ "remote" : Remote_Name,
  "remote_branch" : Remote_Branch_Name
}
```

Fetch layers from `remote`, then attempt a rebase from the remote branch `remote_branch` onto the local branch specified in the URL.

## Branch

```jsx
POST http://localhost:6363/branch/<organization>/<dbid>/<repo>/<new_branchid>
```

JSON API document is:

```jsx
{ <"origin" : Remote_Name >
}
```

Creates a new branch as specified by the URI, starting from the branch given by `origin` or empty if it is unspecified.

## Create Graph

```jsx
POST http://localhost:6363/graph/<organization>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>
```

This takes a post parameter:

```jsx
{"commit_info" : { "author" : Author, "message" : Message }}
```

This API call creates a new graph as specified by the absolute graph descriptor in the URI.

## Delete Graph

```jsx
DELETE http://localhost:6363/graph/<organization>/<dbid>/<repo>/branch/<branchid>/<instance|schema|inference>/<graphid>
```

This takes a post parameter:

```jsx
{"commit_info" : { "author" : Author, "message" : Message }}
```
This API deletes the graph specified by the absolute graph descriptor in the URI.
