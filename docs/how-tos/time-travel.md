---
title: Time Travel
layout: default
parent: How Tos
nav_order: 5
---
# Time Travel

{: .no_toc }

TerminusDB is a temporal database and natively supports time travel. It offers temporal data types and stores information relating to the past states of the database. TerminusDB uses a delta encoding approach to facilitate time travel queries. You can read more about this in [this technical white paper](https://github.com/terminusdb/terminusdb-server/blob/dev/docs/terminushub/whitepaper/terminusdb.pdf).

This How To uses the console. 

- - -

## Section 1 - Go to Database

Login to TerminusHub and clone a database, or you can use a database you created or uploaded. This How To uses the bike share database available on TerminusHub.

![Go to database on TerminusHub ](/docs/terminushub/assets/uploads/clone-screen.jpg)

This will take you to the 'DB Home' screen, which contains all the relevant metadata about the database. 

![DB Home Screen ](/docs/terminushub/assets/uploads/db-homew.jpg)

## Section 2 - Time Travel

Go to the schema page and use the 'Latest' toggle in the top right to open the time travel widget. Once the widget is open, you can travel to any point in the history of the database using the slider bar or the calendar. When you have found the point you want to return to, just click 'Time Travel to this Commit' and you will move to that point. The schema will then reflect that state. You can always travel back to the head of the database should you need to.

![Time Travel on Console ](/docs/terminushub/assets/uploads/time-travel-schema.jpg)

The time travel widget work throughout the console. Click on the 'Branch' tab and select 'Branch' - the time travel widget appears automatically on this page to allow you to travel to any point in the history of the database and easily take a branch from there. You may wish to only have the data and schema from before a specific date. This makes it easy to use the time travel and branch features together.

Just use the slider and calendar to find the relevant point, input a 'New Branch ID' and click 'Create New Branch'.  

![Time Travel and Branch Features on Console ](/docs/terminushub/assets/uploads/time-travel-branch.jpg)

And remember faster than light travel is time travel.