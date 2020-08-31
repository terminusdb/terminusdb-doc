---
title: Pushing and Pulling Changes
layout: default
parent: Tutorials
nav_order: 3
---
# Pushing and Pulling Changes

{: .no_toc }

Shares databases and updates to databases is easy with TerminusDB and TerminusHub. We call this pulling and pushing changes: you pull updates from TerminusHub to your local version and push changes from you local version to TerminusHub. This makes collaboration and syncronization easy. 

This short tutorial shows you how to push and pull using the TerminusDB console. We have installed using [quickstart](https://github.com/terminusdb/terminusdb-quickstart). 

- - -

## Step 1 - Create a DB, Build a Schema

First things first, login to TerminusHub and click 'create'. 

![](/docs/assets/uploads/logged-in.jpg)

Ok, so we are going to create the database on TerminusHub so we can give access to our collaborators and colleagues. Lets call the database `team` and give the ID `team_list`. You can also choose a 'team' appropraite image to associatate with the database. We have added the descrition `this is a list of team members`.

![](/docs/assets/uploads/create-db.jpg)

Once you have created the database on TerminusHub, you will be taken to the DB Home screen. First thing we need to do is create a simple schema, so click on 'query' and enter the following script: 

```
WOQL.doctype("TeamMember").label("Team Member")
    .property("owner","xsd:string")
       .label("owner")
```

That'll look like this in the console:

![](/docs/assets/uploads/schema.jpg)

Now lets just quickly insert some test data. Lets use Mike and Sakura as our team members. 

Insert Mike on the query page and press 'Run Query':

```
WOQL.and(
  WOQL.add_triple("doc:mike", "type", "scm:TeamMember"),
  WOQL.add_triple("doc:mike", "owner", "mike")
)
```

Insert Mike on the query page and press 'Run Query':

```
WOQL.and(
  WOQL.add_triple("doc:sakura", "type", "scm:TeamMember"),
  WOQL.add_triple("doc:sakura", "owner", "sakura")
)
```

Now we have team members, we can go to the DB Home pane and see the updates (we used commit messages 'Insert Mike' and 'Insert Sakura'):

![](/docs/assets/uploads/db-home-with-revision-history.jpg)

- - -

## Step 2 - Push the Database to Hub

We now have a database with a schema and some data. Let's share it with another user. Click on the 'Synchronize' tab and under 'Upload' click the 'Push' button to share the database on TerminusHub. Once you have pushed you will see a report letting you know that the action was successful. 

![](/docs/assets/uploads/post-push-1.jpg)

Once you have pushed to Hub, you should click on the TerminusDB logo to go back to the home screen and click on 'Collaborate'. Use the drop-down menu on the right to select 'Add Collaborators'. You can then select the database you want to share - in this case 'team' - and give the correct permission. You can give read, write or manage rights to a collaborator. You should then include the ID or email of your collaborator and include and introduction note. (Note, if there is more than one 

![](/docs/assets/uploads/collaborate.jpg)

Go ahead and press 'Add Collaborators'. 

That is it - you have pushed the database to Hub and added a collaborator who can now pull updates from TerminusHub. 



- - -

## Step 3 - Pull from Hub

We are now in the account we shared with and can see all of the changes that we made:

![](/docs/assets/uploads/db-home-luke.jpg)

We can now add more information and the commit history is updated with the new person making the commit: 

![](/docs/assets/uploads/add-new-luke.jpg)

These changes can be pushed back to TerminusHub, so collaborators can collectively worked on shared databases. 

![](/docs/assets/uploads/pull-slide.jpg)

Of course, the complexity of collaboration can increase to match your workload! Trying branching first, then pushing the branch and have your collaborator pull that branch.