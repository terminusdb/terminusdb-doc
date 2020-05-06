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

## Instance Data Base URI


## Namespace Prefixes

The following URL prefixes are pre-configured (and fixed) for every TerminusDB Database: 

## Extended Prefixes

## ID Generation







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
