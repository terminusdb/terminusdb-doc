---
layout: default
title: Properties
parent: Schema
nav_order: 2
---

## Introduction

In a TerminusDB schema, there are objects, defined by classes, and these objects can have attributes associated with them which are defined by proprties in the schema. 

Property Definitions

There are 7 important parts to a property definition:

1. Property ID
1. Property Type
1. Property Label
1. Property Description
1. Property Domain
1. Property Range
1. Property Cardinality Constraints

### Property ID

Under the hood TerminusDB uses OWL and RDF for defining Schemas. In RDF, all ids are IRIs and this is the case with property IDs, like all IDs in TerminusDB. However, rather than using full URLs, it’s much more convenient to express things in a compressed form, with prefixes that map to an IRI base providing namespace safety, with fragment ids which identify the particular class. So for example, rather than writing

http://terminusdb.com/john/crm#address

it’s much more convenient to write:

crm:address - and define the crm prefix to map to the actual URL.

In TerminusDB, a predefined prefix is part of every database - the scm namespace is local to every database and allows you to create a class that is local to that database, with a valid IRI which will not clash with any other namespaces. In general, unless you know what you are doing, you should always just use the scm: prefix for all your properties. 

In TerminusDB we generally follow the convention that property names are all lower case and use snake-case to make compound property names: word1_word2

In most cases, in TerminusDB you won’t need to specify the prefix - if you are using the default scm: prefix, it will be automatically added when no prefix is supplied. You just need to choose an id for your property that is meaningful, if possible according to the naming convention above. Because the property ID forms part of an IRI, you cannot use spaces in property ids, other special characters are permitted but should be used with extreme caution.

### Property Type

Properties are divided into two distinct types - datatype properties and object properties. Datatype properties point at simple literal types - strings, numbers and so on, while object properties point at structured objects. In our schema definition we specify the type of the property, and the types of the objects which can appear on the left (domain) and the right (range) of the property.  If the property is a Datatype property, the range will always be a datatype, if the property is an object property, the range will always be a class. In all cases, the domain of a property must be a class. 

### Property Label 

Like classes, properties can have a label - a simple text string that can be used in UI elements to refer to the property. This uses the standard `rdfs:label` predicate. Labels are optional but strongly recommended. 

### Property Description 

Properties can also have a description defined in the schema - a longer text string describing the meaning or rationale of the property. Providing descriptions is good practice as it provides readable documentation for others who want to understand the schema. Under the hood, descriptions are encoded using the standard `rdfs:comment` predicate. Descriptions are optional but strongly recommended. 

### Property Domain

The domain of a property is the class that can be considered to 'own' the property - that is to say that the domain of a property appears on the left hand side of the triple that uses the property.  So, for example, if I have a property called `color` with a domain of `Car`, then an object of type car can have a color property associated with it. This uses the standard `rdfs:domain` predicate under the hood.  

### Property Range

The range of the value is the class or datatype that can be considered to represent the value of the property.  For example, if my color property is defined as having a range of 'xsd:string' this means that the value of the property must be a string. If, on the other hand, it is defined as being an instance of a defined 'Color' class, then this means that the value should be an object of type `Color`. This uses the standard `rdfs:range` predicate under the hood. 

### Property Cardinality Constraints

Properties can have cardinality constraints associated with them. The semantics of these constraints are simple. We can define a maximum cardinality, a minimum cardinality or an exact cardinality for any property in the schema and this will be enforced by the system - in that TerminusDB will prevent you from writing any data to the database that breaks the cardinality constraints. So, for example, if I define a property to have a cardinality of exactly one, then if I create an object of a class that is the domain of this property, I must provide exactly one value for this property or it will be rejected - this is a mandatory and unique property. Similarly, if I define a property to have a maximum cardinality of 1, then the property is unique but not mandatory and if I define a property as having a minimum cardinality of 1, then it is a mandatory but not necessarily unique property. 

Under the hood, OWL has a non-intuitive way of defining such restrictions, although it is mathematically precise, using inheritance from a special owl:Restriction. Some example are provided below. 

## Examples

### Simple Datatype Property

Defining a color property for a Car which takes a string value (e.g. "red")

#### WOQL.js
<div class="code-example">
    
```js
WOQL.add_property("color", "string")
    .label("Color")
    .description("The color of the object")
    .domain("Car")
```
</div>

#### WOQL.py

<div class="code-example">
    
```py
WOQLQuery().add_property("color", "string")
    .label("Color")
    .description("The color of the object")
    .domain("Car")
```
</div>

#### OWL (turtle encoding)

<div class="code-example">
    
```ttl
scm:color
    a owl:DatatypeProperty;
    rdfs:label "Color"@en;
    rdfs:comment "The color of the object"@en;
    rdfs:domain scm:Car
    rdfs:range xsd:string.
```
</div>

### Simple Object Property

Defining an address property for a Person which takes a structured Address object

#### WOQL.js
<div class="code-example">
    
```js
WOQL.add_property("address", "Address")
    .label("Address")
    .description("The postal address at which the person lives")
    .domain("Person")
```
</div>

#### WOQL.py
<div class="code-example">
    
```py
WOQLQuery().add_property("address", "Address")
    .label("Address")
    .description("The postal address at which the person lives")
    .domain("Person")
```
</div>

#### OWL (turtle encoding)

<div class="code-example">
    
```ttl
scm:address
    a owl:ObjectProperty;
    rdfs:label "Address"@en;
    rdfs:comment "The postal address at which the person lives"@en;
    rdfs:domain scm:Person
    rdfs:range scm:Address.
```
</div>

### Datatype Property with Cardinality Constraints

Defining a social security number property for a Person which is mandatory and unique

#### WOQL.js
<div class="code-example">
    
```js
WOQL.add_property("ssn", "integer")
    .label("SSN")
    .description("An official social security number")
    .domain("Person")
    .cardinality(1)
```
</div>

#### WOQL.py
<div class="code-example">
    
```py
WOQLQuery().add_property("ssn", "integer")
    .label("SSN")
    .description("An official social security number")
    .domain("Person")
    .cardinality(1)
```
</div>

#### OWL (turtle encoding)

In OWL we have to make the domain class a subclass of the restriction to encode the constraint. 

<div class="code-example">
    
```
scm:ssn
    a owl:ObjectProperty;
    rdfs:label "SSN"@en;
    rdfs:comment "An official social security number"@en;
    rdfs:domain scm:Person
    rdfs:range xsd:integer.

scm:ssn_property_constraint
    a owl:Restriction;
    owl:onProperty scm:ssn;
    owl:cardinality 1^^xsd:nonNegativeInteger.
    
scm:Person
    a owl:Class;
    rdfs:subClassOf scm:ssn_property_constraint.
```
</div>

### Datatype Property with Cardinality Constraints

Defining a rule that each employee must be assigned at least 3 tasks and no more than 5 tasks at any one time. 

#### WOQL.js
<div class="code-example">
    
```js
WOQL.add_property("tasks", "Task")
    .label("tasks")
    .description("A task assigned to an employee")
    .domain("Employee")
    .min(3)
    .max(5)
```
</div>

#### WOQL.py
<div class="code-example">
    
```py
WOQLQuery().add_property("tasks", "Task")
    .label("Tasks")
    .description("A task assigned to an employee")
    .domain("Employee")
    .min(3)
    .max(5)
```
</div>

#### OWL (turtle encoding)

<div class="code-example">
    
```ttl
scm:tasks
    a owl:ObjectProperty;
    rdfs:label "Tasks"@en;
    rdfs:comment "A task assigned to an employee"@en;
    rdfs:domain scm:Employee
    rdfs:range scm:Task.

scm:tasks_property_constraint
    a owl:Restriction;
    owl:onProperty scm:tasks;
    owl:minCardinality 5^^xsd:nonNegativeInteger;
    owl:maxCardinality 5^^xsd:nonNegativeInteger.
    
scm:Task
    a owl:Class;
    rdfs:subClassOf scm:tasks_property_constraint.
```
</div>
