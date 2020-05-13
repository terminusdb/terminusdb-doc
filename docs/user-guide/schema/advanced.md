---
layout: default
title: Advanced Topics
parent: Schema
nav_order: 6
---

# Advanced Topics - OWL Unleashed
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

<div class="code-example" markdown="1">

```js
WOQL.add_class("EphemeralEntity")
    .label("Ephemeral Entity").abstract(true)
    .property("from", "xsd:dateTime")
      .label("From")
    .property("to", "xsd:dateTime")
      .label("To")
      
WOQL.add_class("Shareholding").parent("EphemeralEntity")

```
</div>

In TerminusDB there is no fundamental distiction between things and relationships - relationships are things that can be interepreted as relationships by virtue of having properties that point at other things.    

## Boxing Datatypes

In RDF it is not possible to address triples with literal values directly. Therefore, if we want to add scopings or other annotations to a datatype property, we can't do so directly. However, it is straightforward to create box classes to wrap the datatype properties in a simple object, with a regular naming convention. 

Terminus WOQL contains some functions to support this situation. 

<div class="code-example" markdown="1">

```js
boxClasses(prefix, classes, except, graph)
loadXDDBoxes(parent, graph, prefix);
this.loadXSDBoxes(parent, graph, prefix)
```
</div>

## Open and Closed World Reasoning

Terminus supports both open and closed world reasoning. Schema graphs use closed world reasoning, but inference graphs use open world reasoning and allow the expression of inference rules. These rules are evaluated dynamically at query time rather than being materialised. 

### Inference Graph

The master terminus database makes use of an inference graph to describe the concept whereby authority should commute over resource inclusion (i.e. if I have authority for a thing, I have authority for the things that are included within that thing). 

<div class="code-example" markdown="1">

```ttl

terminus:authority_scope
  owl:propertyChainAxiom ( terminus:authority_scope terminus:resource_includes ) .

```
</div>


## Freestyle OWL

OWL is an almost infinitely flexible language. This document just provides a taste of the complex configurations that can be achieved by defining OWL schema and inference rules. TerminusDB supports a large subset of OWL in both inference and schema modes. The diagram below provies a snapshot of the OWL predicates that we currently support. It should be noted that all of OWL can be used in schemata and inference graphs, but only this subset will be correctly reasoned over. In some cases, the reason that we do not support a predicate is because, in practice, the way that the predicate is used does not correspond with it's semantic definition (owl:SameAs) in other cases, it is because we have never had the need to use that specific formulation. It is normally possible to adequately capture a situation using a much smaller subset of the language.   

---

<img src="https://terminusdb.com/docs/img/owl-support.png" />
