---
layout: default
title: Package overview
parent: Getting started
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

TerminusDB consists of a large number of different code-repositories and packages, each of which is made available individually on <a href="https://github.com/terminusdb/">the TerminusDB github page</a>, as well as being bundled into releases.  This document describes the different packages and what they do and why you might need them. 

## Core Server Packages

These packages are part of the core TerminusDB DB Server engine

### terminus-server

The main server package - built in Prolog - contains much of the logic and orchestration of the system

### terminus-store

The underlying data store - built in Rust - provides fast access to an immutable append only data-store

### jwt_io 

JWT authentication support for Prolog - used by terminus-server to enable JWT authentication

### terminus_store_prolog 

Prolog bindings which allow Terminus Server to talk to terminus-store 

### terminus-store-test 

Automated load testing scripts for terminus-store

### terminus-upgrade-to-store 

Old package to support upgrading from terminus-server 1.0 to terminus-server 1.1 - requiring a change in underlying storage engine from HDT to terminus-store

## Client Language Packages

Client libraries for accessing TerminusDB from programming languages

### terminus-client 

Javascript client library - comes as npm model or script

### terminus-client-python 

Python client library - includes panda dataframes integration. 

## User Interface

User Interface libraries for visualising TerminusDB contents and query results

### terminus-dashboard 

The management dashboard that ships with TerminusDB

### terminus-react-table 

A react table element for displaying TerminusDB query results

### terminus-react-graph 

A react graph element based on d3, for displaying TerminusDB query results as graphs

### terminus-react-chart 

A react charting element, for displaying TerminusDB query results as charts


## Documentation and News

Repositories which provide documentation and news about TerminusDB

### <a href="https://github.com/terminusdb/terminusdb-doc">terminusdb-doc</a>

The documentation site for terminus DB - includes this page!

### terminus-tutorials 

A collection of tutorials and useful scripts to help users better understand TerminusDB

### terminus-schema

Documentation on the internal datastructures used by TerminusDB

### terminusdb-blog 

The TerminusDB blog site

### terminusdb-community 

The TerminusDB community website

### terminusdb-events 

The TerminusDB events listing site 

### documentation-sprint 

Special repository for supporting documentation sprints

### terminusdb-knowledge 

Some background articles on terminus DB

## Deployment

Repositories to help deploy TerminusDB 

### terminus-quickstart 

Quickstart script for loading TerminusDB as a docker container 

### terminus-heroku 

One click deploy of TerminusDB to a heroku account. 

### katacoda-scenarios 

TerminusDB deployed as a katacode tutorial (Deprecated as service has become tumbleweed)

### swi-prolog-docker 

Docker container pre-built for SWI-Prolog
