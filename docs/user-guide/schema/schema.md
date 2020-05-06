---
layout: default
title: Schema
parent: User guide
nav_order: 3
has_children: true
permalink: /docs/user-guide/schema
---

# Code
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Introduction

Schemas are a very important part of TerminusDB. They allow you to define the shape that your data can take in such a way that TerminusDB will enforce the rules - preventing you from saving broken data to your database. 

Having to define a schema for your data does impose a certain amount of cost in advance for users. However, in the long run, the trade off is very much worth it. The earlier in the process that you identify errors in your data, the cheaper and easier it is to fix those errors. If your database allows you to write any old data to it, it becomes very difficult and expensive to clean it up subsequently. Many RDF based databases suffer terribly from the problem of not having adequate schemas defined in advance, meaning that they are in practice 'triple-soup' - an unmanageable mess of fragments of data which have no defined shape and are almost useless in practice. Thus we are strong advocates of defining schemas in advance. Without a schema it's not a real database, just a collection of random data fragments that have no defined interpretation. 

However, in certain cases, this can be overkill - for example, when you are first experimenting with a new project, it can be considerably offputting to have to nail things down in advance - you don't know what exact shape the data should take until you've tried out a few different options. Therefore, TerminusDB also supports schema-free databases which allow you to save any data without restrictions. This does limit the features of the system that you can use - for example, subsumption can only work if there is a defined class hierarchy in the schema. Thus, schema-free databases cannot use the more advanced features of the WOQL query language. Still they can be queried and written to using the basic structures of WOQL such as triple, path, etc.    

---

## Schema Definition Language

Under the hood, TerminusDB uses <a href="">OWL, the Web Ontology Language</a> for defining its schema.  OWL is a very rich and expressive language which allows you to encode a vast amount of business logic and rules in the schema itself. Furthermore, it has a solid mathematical basis, meaning that the definitions are precise and formally verifiable by reasoners. It is by some way, the most sophisticated data description standard that humankind has thus produced. However, it has a couple of major problems. Firstly, it lacks much in the way of tool support - using native OWL tools is a painful expreience. Secondly, it was defined as having only an 'open world' interpretation which is of limited use in practice. 

Therefore, although TerminusDB uses OWL under the hood, our interpretation is a standard, ordinary closed world one when using it for schema checking. We also support open world interpretations, via an inference graph - which supports almost all of the sophisticated reasoning capabilities of the language. Furthermore, rather than using OWL directly, in TerminusDB we typically use our programming language query composers WOQL.js and WOQL.py for actually defining schemas. These hide a lot of the syntactic complexity of the language and allow you to define your schema in familiar ways, using simple syntax. 

---

## Schema Constructs

### Classes

Basic intro to classes with link to classes section

---

### Properties

Basic intro to properties with link to classes section

---

### Datatypes

Basic intro to datatypes with link to section

---

### IRIs, URLs, IDs and Prefixes

---

### Graphs - Schema - Instance & Inference


Code can be rendered inline by wrapping it in single back ticks.

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
