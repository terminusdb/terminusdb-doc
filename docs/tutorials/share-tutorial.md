---
title: My First Shared Database
layout: default
parent: Tutorials
nav_order: 2
---
# My First Shared Database

{: .no_toc }

This is a quick tutorial to introduce you to sharing databases with TerminusDB and TerminusHub. This tutorial uses the console and has installed TerminusDB using [bootstrap](https://github.com/terminusdb/terminusdb-bootstrap). 

<iframe width="560" height="315" src="https://www.youtube.com/embed/pCLgW3bhSCw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

- - -

## Step 1 - Connect to Hub

Go to the TerminusDB home page and click `Connect to Hub` to login to your TerminusHub account.

![Connect to TerminusHub ](/docs/terminushub/assets/uploads/logged-out-1-2-.jpg)

Once you have logged in, click `Create`

![Click Create ](/docs/terminushub/assets/uploads/logged-in.jpg)

## Step 2 - Create a Database

You will arrive on the create database screen. As this is a tutorial explaining how to share databases with TerminusDB and Hub, you should create the database on TerminusHub. You will also need to name the database and give it an ID. You can also indicate if the database will be public or private and if you need to include a schema. The default is a public database with a schema. You can elect to include a picture or an icon to associate with the database.

![Create Database on TerminusHub ](/docs/terminushub/assets/uploads/create-on-hub.jpg)

For this example, we have named the database `test` and given the ID `test1`

![Database name 'Test' ](/docs/terminushub/assets/uploads/create-2.jpg)

Once you have created the database, you will find the `DB Home` screen. Click on `Query` so we can update the database prior to sharing.

![Update Database ](/docs/terminushub/assets/uploads/query-doctype.jpg)

This uses a quick query to insert a `doctype` into the database. We use `WOQL.doctype("test")`

Once you have run the query, you can check the schema to make sure the `doctype` is inserted

![Checking Shema for Doctype ](/docs/terminushub/assets/uploads/schema.jpg)

## Step 3 - Sync and Share

Now that we have something in the database, click on the `Synchronize` tab. You can now push your changes to TerminusHub so that collaborators and others can access your changes.

![Sync and Share on TerminusHub](/docs/terminushub/assets/uploads/sync.jpg)

Now click on the TerminusDB button in the top right to return to the home page. Once there, click `Collaborate` so we can share the database.

![Share Database ](/docs/terminushub/assets/uploads/home-with-test.jpg)

On the collaboration page, use the `Collaborative Actions` dropdown to select `Add Collaborators`. On this page, you can assign collaborative permissions (read, write or manage) and add the user ID or email address of your collaborators (these can be separated by a comma if more than one).

In this case, I am giving manage permissions to my collaborator 'lf' and sending a message to explain my action.

![Collaborative Actions ](/docs/terminushub/assets/uploads/share-1.jpg)

This was successfully shared with user 'lf'

![Collaborative Actions ](/docs/terminushub/assets/uploads/share-2.jpg)

User 'lf' can now login and see that the database has been shared with them.

![Collaborative Actions ](/docs/terminushub/assets/uploads/success.jpg)

Finally, we can now revisit the `Collaboration` page and see that the list of invited collaborators has been updated with the relevant information:

![List of invited Collaborators ](/docs/terminushub/assets/uploads/share-list.jpg)

That's how easy it is to share databases with TerminusDB and TerminusHub. Feel free to use my ID ('luke' or 'lf') when trying it out.

Enjoy!