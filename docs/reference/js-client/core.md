---
layout: default
title: Client - Core Functions
parent: JS Client
nav_order: 2
---

# Client core functions
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
## Import Script

<<<<<<< HEAD

NPM:
=======
NPM:

```javascript

import TerminusClient from '@terminusdb/terminusdb-client'

```

Script:

```javascript
<script .../>
>>>>>>> 4b5e076a8d3cfd72f1a32095566722e396ef7001

```js
    import TerminusClient from '@terminusdb/terminusdb-client'
```

## WOQLClient Class

The core functionality of the TerminusDB javascript client is defined in the WOQLClient class - in the woqlClient.js file. This class provides methods which allow you to directly get and set all of the configuration and API endpoints of the client. The other parts of the WOQL core - connectionConfig.js and connectionCapabilities.js - are used by the client to store internal state - they should never have to be accessed directly. For situations where you want to communicate with a TerminusDB server API, the WOQLClient class is all you will need.  

Basic Usage:

<div class="anchor-sub-parts">Example</div>

```js
    let client = new TerminusClient.Client(SERVER_URL, opts)
    await client.connect(server, opts)
    client.db("test")
    client.checkout("dev")
    let turtle = await client.getTriples("schema", "main")
```

The client has an internal state which defines what organization / database / repository / branch / ref it is currently attached to

## TerminusDB Client API

### Connect
```javascript
client.connect(server, options)
```
Description: Connect to a TerminusDB server and retrieve information about the current user's capabilities and resources on the server.

Status: stable

Arguments:
-    server: (string) URL of the TerminusDB server to connect to
-    options: (json) options for connect
     -   organization: (string) the id of the organization to connect to (in desktop use, this will always be "admin")
     -   db: (string) the id of the database to connect to
     -   local_auth: (json) a local auth configuration used to authenticate the client to the local server
     -   key: (string) basic auth password
     -   user: (string) basic auth username (always admin in desktop mode)
     -   remote_auth: (json) a remote auth configuration - passed to the server to authenticate itself to remote servers during pull / push / clone / fork / fetch
     -   branch: (string) id of branch to connect to (defaults to main)
     -   ref: (string) id of the commit to connect to (defaults to head)
     -   repo:  (string) id of the repository to connect to (defaults to local)

Return Type:
-    a JSON-LD document of system:User class [link]

Example:
```javascript
    client.connect("https://127.0.0.1:6363/", {key="root"})
```

### Create Database
```javascript
client.createDatabase(dbid, doc, orgid)
```
Description: Creates a new database in TerminusDB server

Status: stable

Arguments:
-    dbid: (string - mandatory) The id of the new database to be created
-    doc:  (json - mandatory) a json object containing details of the database to be created:
     -   label (string - mandatory) the display name of the database
     -   comment (string - mandatory) text describing the database
     -   prefixes (json - optional) json containing:
         -   doc: (string) the IRI to use when doc: prefixes are expanded (defaults to terminusdb:///data)
         -   scm: (string) the IRI to use when scm: prefixes are expanded (defaults to terminusdb:///schema)
     -   schema (boolean - optional) if set to true, a main schema graph will be created, if not set, only a main instance graph will be created
    orgid: (string - optional) the id of the organization to create the database within (in desktop use, this should always be "admin")

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example:
```javascript
    client.createDatabase("mydb", {label: "My Database", comment: "Testing", schema: true})
```

### Delete Database
```javascript
client.deleteDatabase(dbid, orgid)
```
Description: Deletes a database from a TerminusDB server

Status: stable

Arguments:
-    dbid: (string - mandatory) The id of the database to be deleted
-    orgid: (string - optional) the id of the organization to which the database belongs (in desktop use, this will always be "admin")

Returns HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.deleteDatabase("mydb")
```

Returns Promise: HTTP 200 status on success, HTTP error code on failure

### Create Graph
```javascript
client.createGraph(type, gid, commit_msg)
```
Description: Creates a new named graph within a TerminusDB database

Status: stable

Arguments:
-    type: (string - mandatory) - type of graph to create, either "instance", "schema" or "inference"
-    gid:  (string - mandatory) - id of the graph to be created
-    commit_msg (string - optional) - a message describing the reason for the change that will be written into the commit log

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.createGraph("schema", "alt", "Adding new schema graph")
```

### Delete Graph
```javascript
client.deleteGraph(type, gid, commit_msg)
```
Description: Deletes a graph from a TerminusDB database

Status: stable

Arguments:
-    type: (string - mandatory) - type of graph to create, either "instance", "schema" or "inference"
-    gid:  (string - mandatory) - id of the graph to be created
-    commit_msg (string - optional) - a message describing the reason for the change that will be written into the commit log

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.deleteGraph("schema", "alt", "Deleting alt schema graph")
```

### Get Triples
```javascript
client.getTriples(gtype, gid)
```
Description: Retrieve the contents of a graph within a TerminusDB as triples, encoded in the turtle (ttl) format

Status: stable

Arguments:
-    gtype: (string - mandatory) - type of graph to get triples from, either "instance", "schema" or "inference"
-    gid:  (string - mandatory) - id of the graph to read from

Returns Promise: HTTP 200 status on success with the contents being a string representing a set of triples in turtle (ttl) format, HTTP error code on failure


Example
```javascript
    let turtle = await client.getTriples("schema", "alt")
```
### Update Triples
```javascript
client.updateTriples(gtype, gid, turtle, commit_msg)
```
Description: Replace the contents of the specified graph with the passed triples encoded in the turtle (ttl) format

Status: stable

Arguments:
-    gtype: (string - mandatory) - type of graph to get triples from, either "instance", "schema" or "inference"
-    gid:  (string - mandatory) - id of the graph to read from
-    turtle:  (string - mandatory) - string encoding triples in turtle (ttl) format
-    commit_msg (string - optional) - a message describing the reason for the change that will be written into the commit log

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.updateTriples("schema", "alt", turtle_string, "dumping triples to graph alt")
```

### Query
```javascript
client.query(woql, commit_msg)
```
Description: send a Web Object Query Language query to the server

Status: stable

Arguments:
-    woql: (WOQLQuery Object - mandatory) - an instance of the WOQLQuery class
-    commit_msg (string - optional) - a message describing the reason for the change that will be written into the commit log (only relevant if the query contains an update)

Returns Promise: HTTP 200 status on success, contents being a WOQL Query Response, HTTP error code on failure
-    api:WoqlResponse
     -   bindings: (Array) - an array of json values, each representing a single result, with each being indexed by variables
     -   api:variable_names: (Array) - an array of strings, which shows the order in which variables were used in the query
     -   deletes: (int) - the number of triples that were deleted by the query
     -   inserts: (int) - the number of triples that were inserted by the query
     -   transaction_retry_count: (int) - the number of times the transaction was restarted due to contention

Example:
```javascript
    let result = await client.query(WOQL.star())
```
### Clonedb
```javascript
client.clonedb(clone_source, newid, orgid)
```
Description: Clones a remote DB to the local server

Status: Stable

Arguments:
-    clone_source: (json - mandatory) json describing the source branch to be used as a base
     -   remote_url: (string - mandatory) - The URL of the database to be cloned (the URL is always of the form https://server/organization_id/database_id )
     -   label (string - mandatory) the display name of the new cloned database
     -   comment (string - mandatory) text describing the new cloned database
-    newid: (string - mandatory) id of the new cloned database on the local server
-    orgid: (string - optional) id of the local organization that the new cloned database will be created in (in desktop mode this is always "admin")

Example:
```javascript
    client.clonedb({remote_url: "https://my.terminusdb.com/myorg/mydb", label "Cloned DB", comment: "Cloned from mydb"}, newid: "mydb")
```

### Branch
```javascript
client.branch(new_branch_id)
```
Description: creates a new branch with a TerminusDB database, starting from the current context of the client (branch / ref)

Status: Stable

Arguments:
-    new_branch_id: (string - mandatory) - the ID of the new branch to be created

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.branch("dev")
```
### Rebase
```javascript
client.rebase(rebase_source)
```
Description: Merges the passed branch into the current one using the rebase operation

Status: Stable

Arguments:
-    rebase_source: (json - mandatory) json describing the source branch to be used as a base
     -   rebase_from: (string - mandatory) - branch id to be rebased from
     -   message (string - optional) - a message describing the reason for the change that will be written into the commit log

Example:
```javascript
    client.rebase({rebase_from: "dev", message: "Merging from dev")
```

### Pull
```javascript
client.pull(remote_source_descriptor)
```
Description: Pull changes from a branch on a remote database to a branch on a local database

Status: Stable

Arguments:
-    remote_source_descriptor: (json - mandatory) an object describing the source of the pull
     -   remote: (string - mandatory) - the id of the remote repo (normally origin)
     -   remote_branch: (string - mandatory) - the id of the remote branch to pull from
     -   message (string - optional) - a message describing the reason for the change that will be written into the commit log

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.pull({remote: "origin", remote_branch: "main", message: "Pulling from remote"})
```

### Push
```javascript
client.push(remote_target_descriptor)
```
Description: Push changes from a branch on a local database to a branch on a remote database

Status: Stable

Arguments:
-    remote_target_descriptor: (json - mandatory) an object describing the target of the push
     -   remote: (string - mandatory) - the id of the remote repo (normally origin)
     -   remote_branch: (string - mandatory) - the id of the remote branch to push to
     -   message (string - optional) - a message describing the reason for the change that will be written into the commit log

Returns Promise: HTTP 200 status on success, HTTP error code on failure

Example
```javascript
    client.push({remote: "origin", remote_branch: "main", message: "Pulling from remote"})
```

### Fetch
```javascript
client.fetch(remote_id)
```
Description: Fetch updates to a remote database to a remote repository with the local database

Status: Stable

Arguments:
-    remote_id (string - required) the id of the remote to fetch (normally origin)

Returns Promise: HTTP 200 status on success, HTTP error code on failure

## Accessing and Changing Client Context

The client's has an internal context which defines which allows the user to invoke the API actions against any valid resource in the database. For example, by specifying a particular commit id as the source of a query operation, all queries will be made against the state of the database as it was immediately after that specific commit was completed.  All of these methods are both getters and setters with 0 or 1 arguments - if no argument is supplied, they get the current value, if an argument is supplied they set the current value for that part of context

Methods

* organization
* db
* repo
* checkout
* ref

### organization
```javascript
client.organization(orgid)
```
Description: Gets and Sets the client's internal organization context value

Status: Stable

Arguments:
-    orgid: (string - optional) the organization id to set the context to

Returns
-    (string) the current organization id within the client context

Example
```javascript
    client.organization("admin")
```
### db
```javascript
client.db(dbid)
```
Description: Gets and Sets the client's internal db context value

Status: Stable

Arguments:
-    dbid: (string - optional) the database id to set the context to

Returns
-    (string) the current database id within the client context

Example
```javascript
    client.db("mydb")
```
### repo
```javascript
client.repo(repoid)
```
Description: Gets and Sets the client's internal repository context value (defaults to 'local')

Status: Stable

Arguments:
-    repoid: (string - optional) the repository id to set the context to

Returns
-    (string) the current repository id within the client context

Example
```javascript
    client.repo("origin")
```
### checkout
```javascript
client.checkout(branch_id)
```
Description: Gets and Sets the client's internal branch context value (defaults to 'main')

Status: Stable

Arguments:
-    branch_id: (string - optional) the branch id to set the context to

Returns
-    (string) the current branch id within the client context

Example
```javascript
    client.checkout("dev")
```
### ref
```javascript
client.ref(commit_id)
```
Description: Gets and Sets the client's internal ref context value (defaults to false)

Status: Stable

Arguments:
-    commit_id: (string - optional) the commit id to set the context to

Returns
-    (string) the current commit id within the client context

Example
```javascript
    client.ref("mkz98k2h3j8cqjwi3wxxzuyn7cr6cw7")
```
## How Context Affects API Calls

| API Call       | organization                 | db                       | repo                        | checkout                  | ref                        |
|----------------|------------------------------|--------------------------|-----------------------------|---------------------------|----------------------------|
| connect        | set organization context     | set db context           | set repo context            | set branch context        | set commit context         |
| createDatabase | db created in organization   | NA                       | NA                          | NA                        | NA                         |
| deleteDatabase | db deleted from organization | Database to be deleted   | NA                          | NA                        | NA                         |
| createGraph    | db from organization         | Database for operation   | local                       | graph created in branch   | NA                         |
| deleteGraph    | db from organization         | Database for operation   | local                       | graph deleted in branch   | NA                         |
| getTriples     | db from organization         | Database for operation   | Repository for operation    | branch for operation      | commit base for operation* |
| updateTriples  | db from organization         | Database for operation   | local                       | NA                        | NA                         |
| query          | db from organization         | Database for operation   | Repository for operation    | branch to be queried      | commit root for query*     |
| clonedb        | db from organization         | Database for operation   | local                       | NA                        | NA                         |
| branch         | db from organization         | Database for operation   | Repository of branch origin | branch (head) of origin   | commit id of branch origin*|
| rebase         | db from organization         | Database for operation   | Repository of rebase target | rebase to target branch   | NA                         |
| push           | db from organization         | Database for operation   | local                       | push from branch          | NA                         |
| pull           | db from organization         | Database for operation   | local                       | pull to branch            | NA                         |
| fetch          | db from organization         | Database for operation   | NA                          | NA                        | NA                         |

* note ref and checkout are mutually exclusive - if the ref is set it will be used and the branch will be ignored

## Setting and Getting Client Configuration Options

* server
* api
* uid
* user_organization
* local_auth
* remote_auth
* databases
* get_database
* author
* set_system_db
* set

### server
```javascript
client.server()
```
Description: Retrieve the URL of the server that we are currently connected to

Status: Stable

Arguments: None

Returns:
-    (string) the URL of the TerminusDB server endpoint we are connected to

Example:
```javascript
    let server_url = client.server()
```

### api
```javascript
client.api()
```
Description: Retrieve the URL of the server's API base that we are currently connected to

Status: Stable

Arguments: None

Returns:
-    (string) the URL of the TerminusDB server api endpoint we are connected to (typically server() + "api/")

Example:
```javascript
    let api_url = client.api()
```
### uid
```javascript
client.uid()
```
Description: Retrieve the id of the user that is logged in with the client

Status: Stable

Arguments: None

Returns:
-    (string) the id of the current user (always 'admin' for desktop client)

Example:
```javascript
    let server_url = client.server()
```
### user_organization
```javascript
client.user_organization()
```
Description: Retrieve the id of the organization that the user currently belongs to

Status: Stable

Arguments: None

Returns:
-    (string) the id of the current user (always 'admin' for desktop client)

Example:
```javascript
    let org = client.user_organization()
```
### local auth
```javascript
client.local_auth(credentials)
```
Description: Gets / sets the credentials for connecting to the local terminusdb-server

Status: Stable

Arguments:
-    credentials: (json - optional) the credentials to use to authenticate to local TerminusDB server
     -   type: (string - mandatory) either "jwt" or "basic"
     -   key: (string - mandatory) either the jwt token or the basic auth password depending on the type field
     -   user: (string - optional) the user id to use for basic authentication - defaults to "admin"
Returns:
-    (json) the current local credentials as a json

Example:
```javascript
    client.local_auth({type: "basic", user: "admin", key: "root" })
```
### remote auth
```javascript
client.remote_auth(credentials)
```
Description: Gets / sets the credentials for connecting to a remote TerminusDB server for push / pull / clone / fetch operations

Status: Stable

Arguments:
-    credentials: (json - optional) the credentials to use to authenticate to the remote TerminusDB server
     -   type: (string - mandatory) either "jwt" or "basic"
     -   key: (string - mandatory) either the jwt token or the basic auth password depending on the type field
     -   user: (string - optional) the user id to use for basic authentication - defaults to "admin"
Returns:
-    (json) the current remote credentials as a json

Example:
```javascript
    client.local_auth({type: "jwt", key: "...."})
```
### databases
```javascript
client.databases()
```
Description: retrieves a list of databases (id, organization, label, comment) that the current user has access to on the server. Note that this requires the client to call connect() first.

Status: Stable

Arguments: None

Returns:
-    (Array(json)) a list of databases the user has access to on the server, each having:
     -   id: (string) the id of the database
     -   organization: (string) the id of the organization the database belongs to
     -   label: (string) the display name of the database
     -   comment: (string) the description text for the database

Example:
```javascript
    let my_dbs = client.databases()
```

### get database
```javascript
client.get_database(dbid, orgid)
```
Description: Retrieves metadata (label, comment) about a particular database.

Status: Stable

Arguments:
-    dbid (string - mandatory) the id of the database
-    orgid (string - optional) the id of the organization to which the database belongs (defaults to 'admin')

Returns:
-    (json) a json with fields representing metadata about the db:
     -   id: (string) the id of the database
     -   organization: (string) the id of the organization the database belongs to
     -   label: (string) the display name of the database
     -   comment: (string) the description text for the database

Example:
```javascript
    let my_db = client.get_database()
```
### author
```javascript
client.author(author_id)
```
Description: Gets / sets the string that will be written into the commit log for the current user

Status: Stable

Arguments:
-    author_id (string - optional) the id to write into commit logs as the author string (normally an email address)

Returns:
-    (string) the current author id in use for the current user

Example:
```javascript
    client.author("my@myemail.com")
```
### set system db
```javascript
client.set_system_db()
```
Description: sets the internal client context to allow it to talk to the server's internal system database

Status: Stable

Arguments: None

Returns: None

Example:
```javascript
    client.set_system_db()
```
### set
```javascript
client.set(opts)
```
Description: sets several of the internal state values in a single call (similar to connect, but only sets internal client state, does not communicate with server)

Status: Stable

Arguments: (json - mandatory) opts - a json object with the following optional fields:
-        organization: (string) the id of the organization to connect to (in desktop use, this will always be "admin")
-        db: (string) the id of the database to connect to
-        local_auth: (json) a local auth configuration used to authenticate the client to the local server
-        key: (string) basic auth password
-        user: (string) basic auth username (always admin in desktop mode)
-        remote_auth: (json) a remote auth configuration - passed to the server to authenticate itself to remote servers during pull / push / clone / fork / fetch
-        branch: (string) id of branch to connect to (defaults to main)
-        ref: (string) id of the commit to connect to (defaults to head)
-        repo:  (string) id of the repository to connect to (defaults to local)


Returns: None

Example:
```javascript
    client.set({key: "mypass", branch: "dev", repo: "origin"})
```
## Utility Functions

### copy
```javascript
client.copy()
```
Description: creates a copy of the client with identical internal state and context - useful if we want to change context for a particular API call without changing the current client context

Status: Stable

Arguments: None

Returns:
-    (WOQLClient) new client object with identical state to original but which can be manipulated independently

Example:
```javascript
    let tempClient = client.copy()
```
### resource
```javascript
client.resource(type, val)
```
Description: generates a resource string for the required context

Arguments:
-    type (string - mandatory) the type of resource string that is required - one of "db", "meta", "repo", "commits", "branch", "ref"
-    val (string - optional) - can be used to specify a specific branch / ref - if not supplied the current context will be used

Returns:
-    (string) - a resource string for the desired context

Example:
```javascript
    let branch_resource = client.resource("branch")
```
