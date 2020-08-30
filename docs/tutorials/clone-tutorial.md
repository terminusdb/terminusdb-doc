---
title: My First Cloned Database
layout: default
parent: Tutorials
nav_order: 1
---
# My First Cloned Database

{: .no_toc }

This tutorial will show you how to clone a database in the TerminusDB and Hub console. Once you have downloaded TerminusDB and set up your account, cloning a database should take less than a minute. 

{: .no_toc .text-delta }

- - -

<iframe width="560" height="315" src="https://www.youtube.com/embed/PUUei56QB1c" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Step 1 - Login to TerminusDB and Go to Clone Screen

Go to the TerminusDB home page and login to TerminusHub by clicking `Connect to Hub`:

![](/docs/assets/uploads/logged-out-1-2-.jpg)

You are now be in the logged in environment and should click `clone:`

![](/docs/assets/uploads/logged-in-1-2-.jpg)

On the clone screen, click the cloud beside the bike sharing database to clone the DB

![](/docs/assets/uploads/clone-screen-1-2-.jpg)

You can also click on the title of the database `TerminusDB Bike Tutorial` to get to the clone screen. In this screen you also have the option to 'fork' the database which creates your own copy of the database. You may want your own copy if you want to make changes to the database.

![](/docs/assets/uploads/clone-or-fork-1.jpg)

- - -

## Step 2 - Clone and Review

Now you have clicked the `clone` button, you will be taken to the home screen of the bike sharing database:

![](/docs/assets/uploads/post-clone-bike-1.jpg)

You can now explore the database by reviewing the commit history or looking at the database's schema and documents. 

![](/docs/assets/uploads/schema.jpg)

- - -

## Step 3 - Running a Query

Now click on the `query` button to run a quick query against the database. 

![](/docs/assets/uploads/query-1.jpg)

This query is taken from the [bike data tutorial ](https://medium.com/terminusdb/my-first-terminusdb-2-0-graph-ef7f05038910): 

```
WOQL.select("v:Start", "v:Start_Label", "v:End", "v:End_Label").and(
	WOQL.triple("v:Journey", "type", "scm:Journey"),
	WOQL.triple("v:Journey", "start_station", "v:Start"),
	WOQL.opt().triple("v:Start", "label", "v:Start_Label"),
	WOQL.triple("v:Journey", "end_station", "v:End"),
	WOQL.opt().triple("v:End", "label", "v:End_Label"),
	WOQL.triple("v:Journey", "journey_bicycle", "v:Bike")
)
```

You can now click on `result viewer` to see the result of the query and click on the drop down menu on the right hand side to switch to a graph view.

![](/docs/assets/uploads/query-2.jpg)

![](/docs/assets/uploads/query-3.jpg)

And that is how easy it is to clone a complex database and immediately run a query against the database. 

Enjoy!