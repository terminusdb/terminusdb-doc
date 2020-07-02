---
layout: default
title: Client - Core Functions 
parent: JS Client
nav_order: 2
---

# Configuration
{: .no_toc }

(The core functions of the woqlclient)

## Table of contents
{: .no_toc .text-delta }

1. TOC
WOQL Client Class 
TerminusDB API
Connection State

{:toc}

---
## Import Script

NPM: 

```javascript

import TerminusClient from '@terminusdb/terminusdb-client'

```

Script: 

```javascript
<script .../>

```

## WOQLClient Class

The core functionality of the terminusdb javascript client are defined in the WOQLClient class - in the woqlClient.js file. This class provides methods which allow you to directly get and set all of the configuration and api endpoints of the client. The other parts of the WOQL core - connectionConfig.js and connectionCapabilities.js - are used by the client to store internal state - they should never have to be accessed directly.  For situations where you want to communicate with a TerminusDB server API, the WOQLClient class is all you will need.  

Basic Usage:

```javascript

let client = new TerminusClient.Client(SERVER_URL, opts)
client.connect(opts).then(() => {
    client.db("test")
    client.checkout("dev")
    client.getTriples("schema", "main")
})
```



## 

content of section 2

etc
