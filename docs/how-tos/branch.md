---
title: Create and Merge Branches
layout: default
parent: How Tos
nav_order: 6
---
# Create and Merge Branches

{: .no_toc }

<!--StartFragment-->

TerminusDB and TerminusHub provide powerful tools that make it easy to create and share branches in databases. But eventually these branches have to be merged back together - TerminusDB makes this process easy.

These tools are also central to the coordination of a team, all working on a common database or set of databases. By recording the changes each engineer and scientist makes, TerminusDB can keep track of many lines of work at once, and help engineers and scientist work out how to merge these lines of work together.

This How To uses the TerminusDB console. 

- - -

## Section 1 - Branch

From the 'DB Home' screen on your database, click on the 'Branch' tab. Once there, click the 'Branch' button under 'Create a new Branch'.

![Create new branch ](/docs/terminushub/assets/uploads/create-branches.jpg)

On the next screen insert the name of the new branch into the 'New Branch ID' box and click 'Create New Branch'. In this case, we have called the new branch 'branch_office'.

![Branch office ](/docs/terminushub/assets/uploads/create-branches-2.jpg)

You will now be able to see that a new branch appears in the top right drop down menu.

![Branch ](/docs/terminushub/assets/uploads/branch-office.jpg)

- - -

## Section 1 - Merge

Click on the 'Branch' tab and click the 'Merge' button under 'Merge Branches'. You will now be on the merge screen. You should select the branch you want to merge in the top right drop down and the correct branch to merge into in the 'Merge Into Branch' drop down. Once you are happy that these are correct, you can click 'Merge into x Branch' button (in the below example, it is 'Merge into Main Branch' as we are merging the 'branch_office' into 'main').

![Merging Branch Office ](/docs/terminushub/assets/uploads/merge-screen.jpg)

You can now check to confirm that the data from the branches has been merged. 

Without branching and merging, we give individuals the illusion of frozen time, that they are the only ones changing the system and those changes can wait until they are fully baked before risking the system. But this is an illusion and eventually the price for it comes due. Who pays? When? How much?