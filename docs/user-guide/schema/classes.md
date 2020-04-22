---
layout: default
title: Classes
parent: Schema
nav_order: 1
---

## Introduction

In TerminusDB, classes are used to define the shapes of the data structures that we store in the database.  Every fragment of data saved in the database is associated with a particular type and this type is defined by it's class definition in the schema. So, if, for example, we wanted to save data structures of type "Customer", we would first define the "Customer" class in the schema.  

Classes are relatively simple structures - but they can be combined in a variety of ways to produce complex results. 

---

## Class Definitions

A class definition is composed of several properties in the schema: 

1. ID
2. Label / Name
3. Description
4. Parent Classes

### OWL

<div class="code-example" markdown="1">
```turtle
scm:MyClass 
  a owl:Class;
  rdfs:label "Class Name"@en;
  rdfs:comment "Class Description"@en;
  rdfs:subClassOf scm:MyOtherClass.
```
</div>
{% highlight markdown %}
```js
  WOQL.add_class("MyClass")
      .label("Class Name")
      .description("Class Description")
      .parent("MyOtherClass")
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
