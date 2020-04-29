---
layout: default
title: Classes
parent: Schema
nav_order: 1
---

>
> Tell me what type of a thing it is and I will know what to do with it
>

## Introduction

In the TerminusDB schema, classes are used to define the shapes of the data structures that we store in the database.  Every fragment of data saved in the database is associated with a particular *type* and this type is defined by it's class definition in the schema. So, if, for example, we wanted to save data structures of type `Customer`, we would first define the `Customer` class in the schema.  

Classes are relatively simple structures - but they can be combined in a variety of ways to produce complex results. 

---

## Class Definitions

A class definition is made up of a small number of properties in the Terminus schema: 

1. Class ID
2. Label / Name
3. Description
4. Parent Classes
5. Abstract Tag

### Class ID

Under the hood TerminusDB uses OWL and RDF for defining Schemas. In RDF, all ids are IRIs and this is the case with class IDs, like all IDs in TerminusDB. However, rather than using full URLs, it's much more convenient to express things in a compressed form, with prefixes that map to an IRI base providing namespace safety, with fragment ids which identify the particular class. So for example, rather than writing 

`http://terminusdb.com/john/crm#Person` it's much more convenient to write: `crm:Person` - and define the crm prefix to map to the actual URL. 

In TerminusDB, a predefined prefix is part of every database - the `scm` namespace is local to every database and allows you to create a class that is local to that database, with a valid IRI which will not clash with any other namespaces. In general, unless you know what you are doing, you should always just use the scm: prefix for all your classes. You can use whatever URLs you like for your classes but this makes it more difficult to work with prefixed forms - you have to define all the prefixes you want to use explicitly and have to remember what belongs where.  

In TerminusDB we follow the usual naming conventions for OWL - class names start with a capital and multiple words are CamelCased together. URL prefixes for classes end with the URL fragment separator '#' 

In most cases, in TerminusDB you won't need to specify the class prefix - if you are using the default scm: prefix, it will be automatically added when no prefix is supplied. You just need to choose an id for your class that is meaningful, if possible according to the capitalisation conventions above. Because the class ID forms part of an IRI, you cannot use spaces in class names, other special characters are permitted but should be used with extreme caution. 

Finally, note that the class URL does not have to dereference to anything at the chosen URL. From the point of view of the database, it is just a unique identifier for the class, nevertheless, it is best practice to only use URLs that will actually dereference properly. If at all possible, if you are making your URLs publically availalble, you should try to only use URLs that dereference to a representation of the class. 

### Label / Name

In addition to having an id, each class can have one or more textual names associated with it. Internally, these use the `rdfs:label` predicate from OWL. These labels are useful in generating user interfaces and tables, etc, with human readable identifiers rather than IRIs. It is strongly recommended that every class have an associated label. 

### Description

Each class can have a description associated with it, using the `rdfs:comment` predicate. Like comments in code, textual descriptions of the intent of the designer who created a data structure are extremely valuable for those who must use and modify their systems. It is strongly recommended that every class have an associated description. 

### Parent Classes

Classes can be designated as subclasses of other classes using the `rdfs:subClassOf` predicate, according to the standard OWL semantics. Intuitively this is an inheritance mechanism for data structures, the definition of a subclass includes and extends the definition of its parent class. That is to say, that it gets all of the parent's defined properties and can add its own new ones.  Note that TerminusDB supports multiple inheritance - a class can have multiple parents, allowing the modelling of complex multi-dimensional 

### Abstract Tag

TerminusDB includes a mechanism for tagging a class as abstract - a common requirement in data modelling where we wish to create a parent class which groups together the definition of various shared features but never actually exists in practice. For example, we might have a class called `Agent` representing people and automated processess. We can tag this as `terminus:abstract` to indicate that, it is such a class. 

## Class Definition Examples

There are two ways in which we can define classes in TerminusDB - directly in OWL, or through one of the WOQL coding language libraries like WOQL.js or WOQL.py. Generally we find that it is easier and quicker to use WOQL.  Below we show parallel examples of class definitions in OWL, WOQL.js and WOQL.py

### WOQL.js

<div class="code-example">
  
```js
WOQL.add_class("MyClass")
      .label("Class Name")
      .description("Class Description")
      .parent("MyOtherClass")
      .abstract(true)
```
</div>

### WOQL.py

<div class="code-example">
  
```py
WOQLQuery().add_class("MyClass")
      .label("Class Name")
      .description("Class Description")
      .parent("MyOtherClass")
      .abstract(True)
```
</div>

### OWL

<div class="code-example">
  
```ttl
scm:MyClass 
  a owl:Class;
  rdfs:label "Class Name"@en;
  rdfs:comment "Class Description"@en;
  terminus:tag terminus:abstract;
  rdfs:subClassOf scm:MyOtherClass.
```
</div>


## Document Classes

TerminusDB allows you to access data within it as documents as well as graphs. To take advantage of this feature, you need to tell the Database which classes should be treated as documents - classes that are not documents can be contained within documents, allowing you to build out documents with complex internal structure.  TerminusDB provides the special `terminus:Document` class - all subclasses of this class are considered to be document classes. The below examples show how you define a document class in OWL, WOQL.js and WOQL.py


### OWL

<div class="code-example">
  
```ttl
scm:MyClass 
  a owl:Class;
  rdfs:label "Class Name"@en;
  rdfs:comment "Class Description"@en;
  rdfs:subClassOf terminus:Document.
```
</div>

We provide a shortcut function doctype in WOQL.js and WOQL.py

```WOQL.doctype("X")` is equivalent to `WOQL.add_class("X").parent("Document")```

### WOQL.js

<div class="code-example">

```js
WOQL.doctype("MyClass")
      .label("Class Name")
      .description("Class Description")
```
</div>

### WOQL.py

<div class="code-example">

```py
WOQLQuery().doctype("MyClass")
      .label("Class Name")
      .description("Class Description")
```
</div>

## Class Properties

Properties are associated with properties via the rdfs:range and rdfs:domain predicates within property definitions.  Intuitively, we can imagine that each class 'owns' the properties that it is the domain of (the left hand side of the property relationship) and these properties have ranges that represent the type of the value of that property (the right hand side of the triple). Property definitions are covered in the next section. 


