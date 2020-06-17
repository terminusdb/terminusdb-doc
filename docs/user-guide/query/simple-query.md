---
layout: default
title: Simple Query
parent: Query
grand_parent: User guide
nav_order: 1
---

# Simple Query
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

# Introduction - 

While WOQL is a very powerful and sophisticated query language which allows you to concisely express very complex patterns over arbitrary data structures.  However, what makes it so expressive and easy to use is the radical simplicity of the core underlying concepts. 

To unleash the power of WOQL, you just need to understand two very simple things. 

## Rule 1. Triples all the way down

In Terminus DB every single fragment of information is always and universally stored and accessible as triples. Triples are the universal and fundamental atom of information in TerminusDB - objects and documents and everything else is stored as collections of triples and it is always possible to break any object down in a reliable and deterministic way into a precise set of triples. Not only that, but TerminusDB adheres to the RDF standard, which means all triples have a regular structure and interpretation and strong norms. From a query writer point of view, this regularity is very helpful - you don't have to care about the low-level structure of the data (what table it is stored in, how many columns there, etc), you just have to care about the patterns of meaning you are interested in.  

(table about Triples)

Simple Add Triple Queries 

## Rule 2 Unify All The Things

The second fundamental concept behind WOQL is unification. This is an old computer science concept that has been polished and refined for 60 years and is defined in obscure mathematical jargon, but it is remarkably simple and intuitive to understand by example. 

### WOQL Variables

In WOQL we have the concept of variables, which are normally represented by a string that starts with `v:` - we use them to store the results of queries. For example we might define variables like 'v:First Name' , 'v:Family Name', 'v:Date of Birth' for a query to find somebody's basic identifying information. 

If we use a variable in a triple query, TerminusDB will show us every possible value that exists in the database that could possibly fill that variable in that position in the query. 

Table showing all combinations of triple variable pattern matches on our simple database. 

### Logical Operators

Single triple pattern matching like the above, is certainly neat, but there's a limited number of things that can be expressed as a single pattern of triples, even with all our variables turned on.  However, WOQL also provides logical operators, AND, OR which allow you to combine as many basic patterns as you like into incredibly expressive queries in very simple forms.  

The most useful operator is logical AND - WOQL.and() which behaves as we would logically expect - if all of the patterns defined within a WOQL.and() can be filled by the database, all of the results will be returned, otherwise, no results will be returned. 

The other basic logical operators: OR - WOQL.or() and NOT - WOQL.not() are also very useful - they are interpreted also as expected, - in the first case, the query will return the first result that it matches in a list of possibilities, in the second case, the query will only return true if the pattern specified is not found in the database. 

Below are some simple examples of using these logical operators in practice. It is amazing how many things you can readily express simply by combining these patterns in different ways. Extreme simplicity and absolutely regularity in the little things allows extreme elegance of description in the big things.  


## That's not all folks

One other huge advantage of a simple and regular underlying architecture is that it becomes much easier to build extra functionality on top. In addition to the basic ideas presented here, WOQL also has a broad set of built in operators and libraries which cover arithmetic, mathematical, date and time, taxonomy specific patterns, aggregation, ordering, grouping, geographical and a wide range of other functions out of the box.  This allows you to move a lot of your logic into the Database Layer and out of your application code - the database should be the only thing that cares about the structure of the storage layer, the rest of us care about getting the data we want out!

The rest of this chapter contains lots of information about all the functions and operators that WOQL provides and how you can access them, but before you leave, we have a question to ask. 

I want to ask my database for the full records of all living people whose direct ancestors were born in Italy before 1850 (assuming I have the records of course) along with their lineage. 

In WOQL my query would look like this: 

```WOQL.("v:Living Person Record ID", "status", "alive")
       .path("v:Living Person Record ID", "parent+", "v:Italian Ancestor", "v:Ancestry Line")
       .triple("v:Italian Ancestor", "date_born", "v:Date of Birth")
       .less("v:Date of Birth", 1850)
       .triple("v:Italian Ancestor", "country_born", "Italy")
       .get_object("v:Living Person Record ID", "v:Full Record")```

How would you ask your database this question? 
  
How 
