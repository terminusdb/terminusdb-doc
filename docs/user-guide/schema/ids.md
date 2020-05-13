---
layout: default
title: IDs, IRIs, URLs and Prefixes
parent: Schema
nav_order: 4
---

# IDs in TerminusDB - IRIs, URLs and Prefixes
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

{:toc}

---

## Introduction

Under the hood, TerminusDB uses <a href="">RDF triples</a> to store all it's data. In RDF, all ids are defined to be IRIs - which can be thought of as URLs for all practical purposes. The benefits of using URLs as your principle IDs are many - you have a universal addressing space, which can be made automatically dereferencable and in complex data integration projects, namespaces are critical if we want to avoid undesirable naming collisions. 

The disadvantages of using URLs for IDs are, firstly, URLs tend to be long and difficult to remember and secondly, that you have to put some effort into the process of figuring out how to generate good URLs to represent you data. 

To address the first issue. rather than using full URLs, it's much more convenient to express things in a compressed form, with prefixes that map to an IRI base providing namespace safety, with fragment ids which identify the particular unit. So for example, rather than writing

http://www.w3.org/1999/02/22-rdf-syntax-ns#type we can use rdf:type

Each TerminusDB database comes preconfigured with a configurable and extensible set of namespace prefixes. 

To address the second issue, WOQL provides several functions which help with generating new ids. 

## Predefined Namespace Prefixes

The following URL prefixes are pre-configured (and fixed) for every TerminusDB Database: 

```
"@context":{
    "owl":"http://www.w3.org/2002/07/owl#",
    "rdf":"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "rdfs":"http://www.w3.org/2000/01/rdf-schema#",
    "xsd":"http://www.w3.org/2001/XMLSchema#"
    "xdd":"http://terminusdb.com/schema/xdd#",
    "terminus":"http://terminusdb.com/schema/terminus#",
    "ref":"http://terminusdb.com/schema/ref#",
    "repo":"http://terminusdb.com/schema/repository#",
    "vio":"http://terminusdb.com/schema/vio#",
    "woql":"http://terminusdb.com/schema/woql#",
    "layer":"http://terminusdb.com/schema/layer#",
}
```

* `owl`, `rdf`, `rdfs`, `xsd`, `xdd` are language primitives and datatypes. 
* `ref`, `repo` and `layer` refer to entities within the terminus layered storage system. 
* `woql` refers to the web object query language
* `terminus` defines high level constructs such as databases and resources specific to the terminus db administration db. 

## User Defined URIs 

In addition to the built in URL prefixes which are fixed, each database has it's own namespace.  This defines two important features - firstly the URLs which will be used to represent the instance data and secondly the namespace that will be used to represent classes and properties that are local to the specific database. 

Each terminus DB database has two useful prefixes defined by default. `doc:` is the default prefix that will be used for instance data in the database. TerminusDB allows users to define this to be whatever URL they want. So, for example, we can create a document with id "doc:John" and define the databases base uri to be "http://my.endpoint.com/" so that the data is actually stored and consumed as http://my.endpoint.com/John 

The prefix is specified in the create database api call and can be changed on a per-branch level, with different prefixes applying to different branch and can be specified during branch creation. 

```WOQLClient.createDatabase({uri_prefix: "http://my.data.com/"})```

## Extended Prefixes

Users can add new prefixes to a database, to conveniently support imported rdf data which may use a variety of namespaces and URLs. This can be achieved through the schema section of the console or through the following API call. 

```Does not exist yet```

## ID Generation

When inserting data, it is frequently the case that we need to generate new ids to represent the new objects that we are writing to the database. In general, we can always use the `doc:` prefix for all data objects which provides us with local namespace safety as well as potential universal addressability.  However, this still leaves the case of the appropriate local extension to use for each object within the database. How should we form our doc:something ids?

TerminusDB puts no restrictions on the IDs that are used for any object. As long as the id is unique within that database (and is a valid id without spaces or colons), it is valid. In the case of datasets where each entity has an existing unique identifier, we can choose to simply use these ids directly as is and that will work fine. However, in the more general case, where we can generate new ids for the entities in our database, the choice of which ids to use is signficant for several important reasons. Firstly, it is always quicker to lookup a value by its doc:id than it is search for it by the value of one of its properties - so when we first generate a new unique ID it pays to consider how easy it will be to regenerate that ID automatically without having to look it up. Secondly, without some principled way of naming objects, we quickly get to a situation where we have namespace clashes and confusion about types (we may, for example, have a Wine and a Person object both with the id: "doc:Rose").

In the case of schema and inference graphs, we are normally dealing with a small enough number of entities that it is normally possible to name them individually without too much risk of namespace collisions.  However, in general, in terminusDB we use the naming convention where we use capital letters (CamelCase) for class names and lowercase with underscores (snake_case) for property names. We encourage the use of this convention to guard against confusion. 

When it comes to instance data, TerminusDB provides two functions in WOQL that are explicitly concerned with generating unique ids for new objects in the database.  They allow users to reliably generate unique identifiers for objects from input variables with the guarantee that the functions will always produce the same output IDs when given the same input identifiers. The trick to using these functions is to find input variables that suitably make the value unique while being widely enough available to be likely useful in future situations where you want to generate the IDs again. For example, a customers name and address might be good choices. 

The second assistance that TerminusDB offers is the use of a convention whereby all objects ids should include the most-specific-class id in the name, so, for example, rather than using the id: doc:Rome, we would use the id doc:City_Rome to avoid later namespace collisions, and to include more information within the id/URL itself. 

The two functions that generate IDs in WOQL are idgen and unique. 

### idgen & unique

<div class="code-example" markdown="1">
```js
WOQL.idgen("doc:City", ["v:Name", "v:State", "v:Country"], "v:CityID") 
WOQL.unique("doc:Person", ["v:FirstName", "v:Family_Name", "v:DOB"], "v:PersonID") 
```
</div>

