---
title: WOQL.js - the Definitive Guide
layout: default
parent: Reference
nav_order: 6
has_children: true
permalink: /reference/woql
---



# WOQL.js - the Definitive Guide

## WOQL.js and JSON-LD

WOQL uses JSON-LD and a formally specified ontology to define the language and to transmit queries over the wire.  WOQL.js is designed primarily to be as easy as possible for programmers to write because JSON-LD is itself tedious for humans to read and write. All WOQL.js queries are translated into the equivalent JSON-LD format for transmission over the wire.  The WOQL.js json() function can be used to translate any WOQL query from its JSON-LD format to and from it's WOQL.js equivalent (a WOQLQuery() object). If passed a JSON-LD argument, it will generate the equivalent WOQLQuery() object, if passed no argument, it will return the JSON-LD equivalent of the WOQLQuery(), in general the following semantic identity should always hold:

let wjs = new WOQLQuery().json(json_ld)
json_ld == wjs.json()

<hr class="section-separator"/>

<!--insert_class_data-->
<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">insert class data</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable </span>
</div>

<i class="fa fa-check status-stable"/>

Inserts data about a class as a json object - enabling a class and all its properties to be specified in a single function

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

insert_class_data(Data, Graph)
```
</div>

<div class="anchor-sub-parts">Arguments</div>  

<table cellspacing="0" cellpadding="0">
  <tr><th>Arguments</th><th>Types</th><th>Requirement</th></tr><tr>
    <td class="param-type">Data</td>
    <td>
        (object*) a json object containing - an id and keys <br/>
        <span class="param-object">id (string*),</span> IRI or variable containing IRI of the class to be inserted <br/>
        <span class="param-object">*key* (string*), </span> keys representing properties that the class has (label, description, parent and any properties that the class has)
    </td>
    <td>Mandatory</td>
  </tr>
  <tr>
    <td class="param-type">Graph</td>
    <td>(string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)</td>
    <td>Optional</td>
  </tr>
</table>


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the insertion expression

<div class="anchor-sub-parts">Example</div>


<div class="code-example" markdown="1">
```js

let data = {
    id: "Robot",
    label: "Robot",
    parent: ["X", "MyClass"]
}

insert_class_data(data)
```
</div>

<hr class="section-separator"/>
<!--insert_doctype_data-->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">insert doctype data</span>
    <span class="anchor-status anchor-status-stable"> Status: Stable</span>
</div>

<i class="fa fa-check status-stable"/>

Inserts data about a document class as a json object - enabling a document class and all its properties to be specified in a single function


<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

insert_doctype_data(Data, Graph)
```
</div>

<div class="anchor-sub-parts">Arguments</div>


<table cellspacing="0" cellpadding="0">
  <tr><th>Arguments</th><th>Types</th><th>Requirement</th></tr>
  <tr>
    <td class="param-type">Data</td>
    <td>
        (object*) a json object containing - an id and keys <br/>
        <span class="param-object">id (string*),</span> IRI or variable containing IRI of the class to be inserted <br/>
        <span class="param-object">*key* (string*), </span> keys representing properties that the class has (label, description, parent and any properties that the class has)
    </td>
    <td>Mandatory</td>
  </tr>
  <tr>
    <td class="param-type">Graph</td>
    <td>(string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)</td>
    <td>Optional</td>
  </tr>
</table>


<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the insertion expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js

let data = {
    id: "Person",
    label: "Person",  
    age: {
        label: "Age",
        range: "xsd:integer",
        max: 1
    }
}
insert_doctype_data(data)
```
</div>














## Document Queries (Experimental / Unstable)

Document queries take or return entire JSON-LD document as arguments. This relies upon the internal frame-generation capabilities of the database and requires the user to have defined discrete document classes to dictate at what points the graph traversal is truncated - a document is considered to contain all objects within it, with the exception of predicates and classes that belong to other documents. This takes some care - improperly defined it can lead to very slow queries which contain the whole database unrolled into a single document - not normally what we require.   

<hr class="section-separator"/>
<!--update_object-->

<div class="anchor-sub-headings-style">
    <span class="anchor-sub-headings">update object</span>
    <span class="anchor-status anchor-status-experimental"> Status: Experimental / Unstable </span>
</div>

<i class="fa fa-flask status-experimental"/>

Updates a document (or any object) in the db with the passed json-ld - replaces the current version

<div class="anchor-sub-parts">Syntax</div>
<div class="code-example" markdown="1">
```js

update_object(JSONLD)
```
</div>


<div class="anchor-sub-parts">Arguments</div>
<table cellspacing="0" cellpadding="0">
  <tr><th>Arguments</th><th>Types</th><th>Requirement</th></tr>
  <tr>
    <td class="param-type">JSONLD</td>
    <td>
        (string*) the document's JSON-LD form which will be written to the DB
    </td>
    <td>Mandatory</td>
  </tr>
</table>

<div class="anchor-sub-parts">Returns</div>
A WOQLQuery which contains the update object expression

<div class="anchor-sub-parts">Example</div>

<div class="code-example" markdown="1">
```js

let data = {
    "@id": "doc:joe",
    "@type": "scm:Person",
    "rdfs:label": {
        "@type": "xsd:string",
        "@value": "Joe"
    }
}

update_object(data)
```
</div>
