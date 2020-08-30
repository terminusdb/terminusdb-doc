---
title: My First Shared Database
layout: default
parent: Tutorials
nav_order: 2
---
# My First Shared Database

{: .no_toc }

This is a quick tutorial to introduce you to sharing databases with TerminusDB and TerminusHub. This tutorial uses the console and has installed TerminusDB using [quickstart](https://github.com/terminusdb/terminusdb-quickstart). 

<iframe width="560" height="315" src="https://www.youtube.com/embed/pCLgW3bhSCw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

- - -

## Step 1 - Connect to Hub

Go to the TerminusDB home page and click `Connect to Hub` to login to your TerminusHub account. 

![](/docs/assets/uploads/logged-out-1-2-.jpg)

Once you have logged in you should click `Create` 

![](/docs/assets/uploads/logged-in.jpg)

## Step 2 - Create a Database

You will arrive on the create database screen. As this is a tutorial explaining how to share databases with TerminusDB and Hub, you should create the database on TerminusHub. You will also need to name the database and give it an ID. You can also indicate if the database will be public or private and if you need to include a schema. The dafault is a public database with a schema. You can elect to include a picture or an icon to associate with the database.

![](/docs/assets/uploads/create-on-hub.jpg)

For this example, we have named the database `test` and given the ID `test1`

![](/docs/assets/uploads/create-2.jpg)

Once you have created the database, you will find the `DB Home` screen. Click on `Query` so we can update the database prior to sharing. 

![](/docs/assets/uploads/query-doctype.jpg)

This uses a quick query to insert a `doctype` into the database. We use `WOQL.doctype("test")`

Once you have run the query, you can check the schema to make sure the `doctype` is inserted

![](/docs/assets/uploads/schema.jpg)

## Step 3 - Sync and Share

Now that we have something in the database, click on the `Synchronize` tab. You can now push you changes to TerminusHub so that collaborators and others can access your changes. 

![](/docs/assets/uploads/sync.jpg)

Now click on the TerminusDB button in the top right to return to the home page. Once there, click `Collaborate` so we can share the database.

![](/docs/assets/uploads/home-with-test.jpg)

On the collaboration page, use the `Collaborative Actions` drop down to select `Add Collaborators`. On this page you can assign collaborative persmissions (read, write or manage) and add the user ID or email address of your collaborators (these can be sepearated by a comma if more than one). 

In this case I am giving manage permissions to my collaborator 'lf' and sending a message to explain my action. 

![](/docs/assets/uploads/share-1.jpg)

This was successfully shared with user 'lf'

![](/docs/assets/uploads/share-2.jpg)

User 'lf' can now login and see that the database has been shared with them.

![](/docs/assets/uploads/success.jpg)

Finally, we can now revisit the `Collaboration` page and see that the list of invited collaborators has been updated with the relevant information:

![](/docs/assets/uploads/share-list.jpg)

That's how easy it is to share databases with TerminusDB and TerminusHub. Feel free to use my ID ('luke' or 'lf') when trying it out.

Enjoy!