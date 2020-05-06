---
layout: default
title: Advanced Topics
parent: Schema
nav_order: 6
---

# Code
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
## Introduction

TerminusDB supports a large fragment of the OWL language. This enables a large number of complex constraints to be expressed in a wide variety of different ways. However, as OWL supports multiple inheritance, it is almost never necessary to use anything much more esoteric than subclassing to achieve a desired effect. This section demonstrates how we can solve some common data-modelling problems with TerminusDB. 

## Scoping

When we construct knowledge graphs, consisting of relationships between things, we often want to scope the relationships, or the properties of the things, especially by time.  In a more general sense, the relationships between things are often complex and can't be represented by a simple property. In TerminusDB this is easy to achieve by creating classes to represent the common properties.

For example, if we wanted to model a situation where a person was a shareholder of a company for a certain period of time.  We want our knowledge graph to contain a shareholder relationship between the person and the company, but it should be scoped by the time of the relationship. 

This is simple to achieve by creating an abstract super-class called "EphermeralEntity", making the shareholder relationship a subclass of this class along with the properties which point at the people involved in the relationships. 

In TerminusDB there is no fundamental distiction between things and relationships - relationships are things that can be interepreted as relationships by virtue of having properties that point at other things.    

## Boxing Datatypes

In RDF it is not possible to address triples with literal values directly. Therefore, if we want to add scopings or other annotations to a datatype property, we can't do so directly. However, it is straightforward to create box classes to wrap the datatype properties in a simple object, with a regular naming convention. 

Terminus WOQL contains some functions to support this situation. 

boxClasses(prefix, classes, except, graph)
loadXDDBoxes(parent, graph, prefix);
this.loadXSDBoxes(parent, graph, prefix)

## OWL Supprted

Here goes the diagram of the bits of owl we support

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
