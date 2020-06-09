---
layout: default
title: TerminusDB Console
parent: User guide
nav_order: 4
has_children: true
permalink: /user-guide/console
---


# Deep Dive into how to use the Console
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---


The terminus console is a simple javascript client application which provides users with a User Interface for managing and querying TerminusDB.
The console is implemented using React Javascript which takes the help of Terminus Client as a gateway for API calls and other libraries which talks to the Terminus Server.

![console fig](../../assets/images/console/overview.JPG)

You can load the console in the browser - http://localhost:6363
Note - You will have to login in order to use the Hub services. The documentation in this section is restricted to console services.

## Home

The Home Page, will be the landing page on loading the above URL which displays a list of all Database to which you have access. User is able to choose any Database from the list which will display more Database centric actions.

On download of the console, User will always be able to view the local Terminus DB installed in their local machine. The local database comes with the name terminus and holds information related to all other database and associated strings. Consider this terminus db as the master to which all other database are tied to. User can always look at a database document in this master database.

## New Database

The New Database page allows user to create a new Database and manage them, more of this will be covered in [link text](/docs/console/managing-databases.md)

## Schema

The Schema page shows off the database schema and provides tools to view and update the schema.

## Query

The Query page allows you to query the database and view results. A set of saved queries are available to load and fire.
