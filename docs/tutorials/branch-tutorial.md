---
title: Creating and Merging Branches
layout: default
parent: Tutorials
nav_order: 4
---
# Create and Merge Branches

{: .no_toc }

TerminusDB is designed to enable collaboration and revision control on data assets. While git is a fantastic piece of software, it is designed for code management, and not data management. We bring that power to the world of data.

In order to get a feel for how these collaboration features work, we can start with a classic database management problem. The bank account balance. #

This tutorial will show you how to use the branch and merge functions in TerminusDB.





## Table of contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

- - -

## Section 1 - Schema and Data

Create a new database with the ID `banker` and the name “bank”, in the console. Select 'share on TerminusHub'. 

Once created you should land in the DB Home page.

The first thing we need to do is define a data model. To do this, click on the Query button at the top. And enter the following query, along with a comment “New schema”.

```
WOQL.doctype("BankAccount").label("Bank Account")
    .property("owner","xsd:string")
       .label("owner")
       .cardinality(1)
    .property("balance","xsd:nonNegativeInteger")
       .label("balance")
       .cardinality(1)
```

This query creates a new document type “BankAccount” along with two properties, one named “owner” which is a string, and one named balance. Both have a cardinality of 1. This query is in fact a very concise shorthand for an OWL specification which we will see later.

If you click on the “Bank Balance Example” button on the top of the screen, it will bring you back to the revision overview and you should be able to see what changes you have made.

# Data Entry

Ok, so far so good, but we’ve no data. Now it is time to try and put some data in the db.

Let’s go to the query screen and write the following query:

```
WOQL.and(
  WOQL.add_triple("doc:mike", "type", "scm:BankAccount"),
  WOQL.add_triple("doc:mike", "owner", "mike"),
  WOQL.add_triple("doc:mike", "balance", 123)
  )
```

This adds some data to our database. You can click on the Documents page and you will see, that in fact mike was added.

Now we should try to make some edits to the bank account to see what happens.

First, let’s try and subtract 130 dollars from mikes account.

```
vars = function(sl) {return sl.map( s => "v:" + s)}
let [balance,new_balance] = vars(["Balance", "New Balance"])
WOQL.and(
  WOQL.triple("doc:mike", "scm:balance", balance),
  WOQL.delete_triple("doc:mike", "scm:balance", balance),
  WOQL.eval(WOQL.minus(balance, 130), new_balance),
  WOQL.add_triple("doc:mike", "scm:balance", new_balance)
)
```

This query fails with the following JSON-LD witness object:


This tells us that our bank balance is invalid as it is negative! TerminusDB doesn’t allow the transaction to go through.

However, we can change the balance by subtracting a smaller number:

Now we have a balance of 13 as expected and everything works fine.

## Section 2 - Branch and Merge

# Branching

Now that we have some data and some updates, we can go ahead and try creating a branch. A branch starts a new database from the a particular commit, allowing us to change the database without affecting the original database.

This can be used to make isolated changes and test them, before we merge them back into the original.

Ok, so go click on the “Bank Balance Example” button at the top and then go to the Manage-tab. Click on the “Branch” button.

Under the field “New Branch ID*” enter in “branch_office” and we’ll pretend we have a branch office adding accounts. In the commit message put: “Branch for our new branch office”.


Now go to the query page. If you look up at the top right of the interface, you’ll see we are still on “branch: main”. Pull the selector down to “branch: branch_office”.

Now we can enter the following query:

```
WOQL.and(
  WOQL.add_triple("doc:jim", "type", "scm:BankAccount"),
  WOQL.add_triple("doc:jim", "owner", "jim"),
  WOQL.add_triple("doc:jim", "balance", 8)
  )
```

This creates Jim, with all 8 dollars to his name. If we now go to the Documents tab we can see that Jim and Mike’s bank account are both listed now.

# Rebase

Let’s go back to the original branch (main), by selecting it in the upper right hand corner, and add one more person, jane in the main branch so that we now have two different histories, with one common commit.

```
WOQL.and(
  WOQL.add_triple("doc:jane", "type", "scm:BankAccount"),
  WOQL.add_triple("doc:jane", "owner", "jane"),
  WOQL.add_triple("doc:jane", "balance", 887)
  )
```

Jane was a bit more frugal and has saved 887 dollars.

But we’re still missing the information about jim, as its stuck in the branch office. How do we get the information into our main branch?

This is why we have merge. Go to the “Bank balance Example” button and then click on the manage-tab.

Click on Merge. Select the “branch_office” branch in the upper right hand corner. Now select the “merge into” branch as “main”. Now you can type: “Merging branch office info” in the commit message.

Now we should go back to the main branch (again in the upper right hand corner), and select the documents view. You’ll see that we have merged the two databases together!



That's how easy it is to manage complex data with TerminusDB and TerminusHub