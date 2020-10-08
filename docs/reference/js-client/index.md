---
layout: default
title: JS Client
parent: Reference
has_children: true
nav_order: 3
---

## JS Client
{: .no_toc }

The client library and all of its functions are documented at: 
[JavaScript Client](https://terminusdb.github.io/terminusdb-client-js/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }  Please visit the client documentation site for reference material on all of the functions, their parameters, etc. This documentation provides fuller reference material on the important components and how they work.   


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Introduction

The Terminusdb Javascript Client allows you to connect to any terminusdb-server from Javascript programs, running either in the browser, or elsewhere. 

It provides access to the full server API through programmatic function calls. 

The TerminusDB Javascript Client is open source software, released under the Apache License. It can be downloaded and modified by anybody from the github repository: https://github.com/terminusdb/terminusdb-client - which is the authoritative source - all development takes place through the open source github repository.  

It can be installed either as a simple script on a web-page, or as a node module, through the npm repository. See the Installation Page for more details. 

## Package Structure

The Javascript client is divided into 3 distinct components. 

The core client functions which allow you to call the temrinus-db api directly, set state, security, etc

The query library which implements the WOQL.js query language - a native javascript fluent-style query language which abstracts away the details of the underlying document format and presents queries as simple javascript objects which interact well with code. 

The view library implements the WOQL.view pattern matching library - a simple language for matching patterns with WOQL results, designed to be plugged into vizualisations. 
