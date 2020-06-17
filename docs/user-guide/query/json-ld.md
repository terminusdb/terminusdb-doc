---
layout: default
title: JSON-LD Query
parent: Query
grand_parent: User guide
nav_order: 5
---

# JSON-LD Query
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

# WOQL - Web Object Query Language

The WOQL query language is a unified model query language. It allows us to treat our database as a document store or a graph interchangeably, and provides powerful query features which make relationship traversals easy.

WOQL's interchange format is written in JSON-LD. This gives us a relatively straightforward human-readable format which can also be easily stored in TerminusDB itself.

For example a simple query which returns every source, predicate and object in a database:

```json
{"@context" : {"@import": "https://terminusdb/contexts/woql/syntax/context.jsonld",
               "@propagate": true},
 "@type" : "Triple",
 "subject" : {"@type" : "Variable",
              "variable_name" : {"@type" : "xsd:string",
                                 "@value" : "Subject"}},
 "predicate" : {"@type" : "Variable",
                "variable_name" : {"@type" : "xsd:string",
                                   "@value" : "Predicate"}},
 "object" : {"@type" : "Variable",
             "variable_name" : {"@type" : "xsd:string",
                               "@value" : "Object"}}}
```

This format is relatively verbose and inconvenient to write directly. However it is ideal for constructing programmatically in Python, Javascript or whatever your favourite language is. It's also possible to represent queries as graphs in Terminus, thereby allowing you to store and load queries which belong with your datasets.

---

# WOQL JSON-LD Encoding

The default imported JSON-LD context at [https://terminusdb/contexts/woql/syntax/context.jsonld](https://terminusdb/contexts/woql/syntax/context.jsonld) allows the syntax to be less verbose by automatically adding "@base", assuming that bare words are in the WOQL namespace. In addition some parameters of keywords are assumed to be identifiers and not strings.

```json
{"@context" :
 {"@version": 1.0,
  "@base": "http://terminusdb.com/schema/woql",
  "@vocab" : "#",
  "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
  "tcs" : "http://terminusdb.com/schema/tcs#",
  "owl" : "http://www.w3.org/2002/07/owl#",
  "xsd" : "http://www.w3.org/2001/XMLSchema#",
  "v" : "http://terminusdb.com/schema/woql/variable/",
  "terminus" : "http://terminusdb.com/schema/terminus#",
  "query_list" : {"@type" : "@id"},
  "query" : {"@type" : "@id"},
    ...
 }
}
```

---
