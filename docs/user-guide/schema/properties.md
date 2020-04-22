---
layout: default
title: Properties
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

In Terminus DB, properties are used in the traditional way, for defining the attributes that things can have.

Properties are divided into two distinct types - datatype properties and object properties. Datatype properties point at simple literal types - strings, numbers and so on, while object properties point at structured objects. In our schema, definition we specify the type of the property, and the types of the objects which can appear on the left (domain) and the right (range) of the property.  If the property is a Datatype property, the range will always be a datatype, if the property is an object property, the range will always be a class. In all cases, the domain of a property must be a class. 

Property Definitions

There are 5 important parts to a property definition:

    ex:address a owl:ObjectProperty | owl:DatatypeProperty - defines the property as either having a value that is an object or a simple datatype.
    rfds:label "Address"@en; - defines "Address" to be the primary name for the property in English - this is the text string that will appear in UIs, dropdowns, etc - recommended
    rfds:comment "The postal address at which the entity resides"@en; - defines a comment for the property in English - this is help text that appears in titles, etc - optional
    rfds:domain ex:Person - defines the domain of the property - i.e. the class that is on the left hand side of the property, or the class that 'owns' the property - mandatory
    rfds:range ex:Address - defines the range of the property - i.e. the value that is on the right hand side of the property, or the value that the property is assigned

Datatype Properties

Datatype properties must have a range that is a supported datatype, as listed in the datatypes documentation

Object Properties

The range of an object property must be a class - if that class is a subClass of tcs:Entity, then the property is interpreted as being a link to the other object, otherwise, it is interpreted as being a containment relationship - the object is contained by the class that is the domain of the property. This makes a difference in how documents are formed and in delete semantics. Contained objects appear as complex elements within the containing objects, whereas links appear as links to the linked object. When a document is deleted through the delete API, all contained elements are also deleted, whereas this is not the case when the property is a link to another document, all links to the deleted object are also deleted but the documents themselves are not. 


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
