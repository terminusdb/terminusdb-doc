---
layout: default
title: IDs, IRIs, URLs and Prefixes
parent: Schema
nav_order: 4
---

# Code
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Introduction

Under the hood, TerminusDB uses <a href="">RDF triples</a> to store all it's data. In RDF, all ids are defined to be IRIs - which can be thought of as URLs for all practical purposes. The benefits of using URLs as your principle IDs are many - you have a universal addressing space, which can be made automatically dereferencable and in complex data integration projects, namespaces are critical if we want to avoid undesirable naming collisions. 

The disadvantages of using URLs for IDs are, firstly, URLs tend to be long and difficult to remember and secondly, that you have to put some effort into the process of figuring out how to generate good URLs to represent you data. 

To address the first issue. rather than using full URLs, it's much more convenient to express things in a compressed form, with prefixes that map to an IRI base providing namespace safety, with fragment ids which identify the particular unit. So for example, rather than writing

http://www.w3.org/1999/02/22-rdf-syntax-ns#type we can use rdf:type

Each TerminusDB database comes preconfigured with a configurable and extensible set of namespace prefixes. 

To address the second issue, WOQL provides several functions which help with generating new ids. 

## Namespace Prefixes

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

owl, rdf, rdfs, xsd, xdd are language primitives and datatypes. 
ref, repo and layer refer to entities within the terminus layered storage system. 
woql refers to the web object query language
terminus defines high level constructs such as databases and resources. 

## Instance Data Base URI

In addition to the built in URL prefixes which are fixed, each database has it's own namespace.  This defines two important features - firstly the URLs which will be used to represent the instance data and secondly the namespace that will be used to represent classes and properties that are local to the specific database. 

Each terminus DB database has two useful prefixes defined by default. doc: is the default prefix that will be used for instance data in the database. TerminusDB allows users to define this to be whatever URL they want. So, for example, we can create a document with id "doc:John" and define the databases base uri to be "http://my.endpoint.com/" so that the data is actually stored and consumed as http://my.endpoint.com/John 

The prefix is specified in the create database api cal and can be updated by writing to the terminus Database. 

WOQLClient.createDatabase(...)

or 

....

## Extended Prefixes

Users can add new prefixes to a database, to conveniently support imported rdf data which may use a variety of namespaces and URLs. This can be achieved through the schema section of the console or through the following API call 

???


## ID Generation

When inserting data, it is often the case that we need to generate an id that 





<div class="code-example" markdown="1">
Lorem ipsum dolor sit amet, `<inline code snippet>` adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
</div>
```markdown
Lorem ipsum dolor sit amet, `<inline code snippet>` adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```

---

## Syntax highlighted code blocks

Use Jekyll's built-in syntax highlighting with Rouge for code blocks by using three backticks, followed by the language name:

<div class="code-example" markdown="1">
```js
// Javascript code with syntax highlighting.
var fun = function lang(l) {
  dateformat.i18n = require('./lang/' + l)
  return true;
}
```
</div>
{% highlight markdown %}
```js
// Javascript code with syntax highlighting.
var fun = function lang(l) {
  dateformat.i18n = require('./lang/' + l)
  return true;
}
```
{% endhighlight %}

---

## Code blocks with rendered examples

To demonstrate front end code, sometimes it's useful to show a rendered example of that code. After including the styles from your project that you'll need to show the rendering, you can use a `<div>` with the `code-example` class, followed by the code block syntax. If you want to render your output with Markdown instead of HTML, use the `markdown="1"` attribute to tell Jekyll that the code you are rendering will be in Markdown format... This is about to get meta...

<div class="code-example" markdown="1">

<div class="code-example" markdown="1">

[Link button](http://example.com/){: .btn }

</div>
```markdown
[Link button](http://example.com/){: .btn }
```

</div>
{% highlight markdown %}
<div class="code-example" markdown="1">

[Link button](http://example.com/){: .btn }

</div>
```markdown
[Link button](http://example.com/){: .btn }
```
{% endhighlight %}
