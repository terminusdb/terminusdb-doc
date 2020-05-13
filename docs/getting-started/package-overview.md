---
layout: default
title: Package overview
parent: Getting started
nav_order: 4
---

## Introduction

TerminusDB consists of a large number of different code-repositories and packages, each of which is made available individually on <a href="https://github.com/terminusdb/">the TerminusDB github page</a>, as well as being bundled into releases.  This document describes the different packages and what they do and why you might need them. 

## Core Server Packages

These packages are part of the core TerminusDB DB Server engine

### <a href="https://github.com/terminusdb/terminusdb-server">terminusdb-server</a>

The main server package - built in Prolog - contains much of the logic and orchestration of the system

### <a href="https://github.com/terminusdb/terminus-store">terminus-store</a>

The underlying data store - built in Rust - provides fast access to an immutable append only data-store

### <a href="https://github.com/terminusdb/jwt_io">jwt_io</a> 

JWT authentication support for Prolog - used by terminusdb-server to enable JWT authentication

### <a href="https://github.com/terminusdb/terminus_store_prolog">terminus_store_prolog</a>

Prolog bindings which allow Terminus Server to talk to terminus-store 

### <a href="https://github.com/terminusdb/terminus-store-test">terminus-store-test</a> 

Automated load testing scripts for terminus-store

### <a href="https://github.com/terminusdb/terminus-upgrade-to-store">terminus-upgrade-to-store</a> 

Old package to support upgrading from terminusdb-server 1.0 to terminusdb-server 1.1 - requiring a change in underlying storage engine from HDT to terminus-store

## Client Language Packages

Client libraries for accessing TerminusDB from programming languages

### <a href="https://github.com/terminusdb/terminusdb-client">terminusdb-client</a> 

Javascript client library - comes as npm model or script

### <a href="https://github.com/terminusdb/terminusdb-client-python">terminusdb-client-python</a> 

Python client library - includes panda dataframes integration. 

##  User Interface

User Interface libraries for visualising TerminusDB contents and query results

### <a href="https://github.com/terminusdb/terminus-dashboard">terminus-dashboard</a> 

The management dashboard that ships with TerminusDB

### <a href="https://github.com/terminusdb/terminus-react-table">terminus-react-table</a> 

A react table element for displaying TerminusDB query results

### <a href="https://github.com/terminusdb/terminus-react-graph">terminus-react-graph</a>

A react graph element based on d3, for displaying TerminusDB query results as graphs

### <a href="https://github.com/terminusdb/terminusdb-doc">terminus-react-chart</a> 

A react charting element, for displaying TerminusDB query results as charts


## Documentation and News

Repositories which provide documentation and news about TerminusDB

### <a href="https://github.com/terminusdb/terminusdb-doc">terminusdb-doc</a>

The documentation site for terminus DB - includes this page!

### <a href="https://github.com/terminusdb/terminus-tutorials">terminus-tutorials</a> 

A collection of tutorials and useful scripts to help users better understand TerminusDB

### <a href="https://github.com/terminusdb/terminus-schema">terminus-schema</a>

Documentation on the internal datastructures used by TerminusDB

### <a href="https://github.com/terminusdb/terminusdb-blog">terminusdb-blog</a>

The TerminusDB blog site

### <a href="https://github.com/terminusdb/terminusdb-community">terminusdb-community</a> 

The TerminusDB community website

### <a href="https://github.com/terminusdb/terminusdb-events">terminusdb-events</a> 

The TerminusDB events listing site 

### <a href="https://github.com/terminusdb/documentation-sprint">documentation-sprint</a> 

Special repository for supporting documentation sprints

### <a href="https://github.com/terminusdb/terminusdb-knowledge">terminusdb-knowledge</a> 

Some background articles on terminus DB

## Deployment

Repositories to help deploy TerminusDB 

### <a href="https://github.com/terminusdb/terminus-quickstart">terminus-quickstart</a>

Quickstart script for loading TerminusDB as a docker container 

### <a href="https://github.com/terminusdb/terminus-heroku">terminus-heroku</a>

One click deploy of TerminusDB to a heroku account. 

### <a href="https://github.com/terminusdb/katacoda-scenarios">katacoda-scenarios</a>

TerminusDB deployed as a katacode tutorial (Deprecated as service has become tumbleweed)

### <a href="https://github.com/terminusdb/swi-prolog-docker">swi-prolog-docker</a>

Docker container pre-built for SWI-Prolog
