---
layout: default
title: Essential basic functionality
parent: Getting started
nav_order: 7
---

# Essential basic functionality
## Retrieve and query datasets others have created
There are many high-quality datasets out there already, and we host
many of them on terminushub. You can easily clone these datasets or
integrate them in datasets of your own. After downloading them,
they'll be available to you for offline use - forever.

## Work on a dataset without risking data loss
It can be scary to modify data. Nobody wants to lose hours, maybe even
days of work by pressing a wrong button, or entering a wrong
command. With terminusdb, you don't have to fear. Every modification
you do is stored in a way that allows you to undo. No matter how badly
you screw up, you can always go back to an earlier time when things
were right.

Whenever you modify your data, you'll be asked to provide a message
saying what you did. These will be kept in a log which you can
view. If you so choose, you can go back to any previous version.

## Keep your data valid with schemas
Structured data tends to follow rules. For example, a person has
exactly one age, not zero or five. Terminusdb can enforce such rules
on your data, so that when you try to give a person more than one age,
the system will tell you that's wrong, and why it is wrong.

If you have experience with relational databases, this is a bit like
database constraints. However, the language terminusdb uses for
schemas, OWL (the Web Ontology Language), is much more powerful than
what you could accomplish in such systems. OWL is an industry standard
with decades of research behind it. In terminusdb it ensures your data
never goes bad.

## Travel through time
Sometimes you don't want to query the latest version of your database,
but an older one. For example, for auditing purposes it may be useful
to be able to query your database as it was at the end of the month,
rather than how it is now. TerminusDB lets you query any revision.

## Use branches to work on modifications
You may want to work on modifications to your data without messing
with your 'master' version. For example, you may need to enter a lot
of data over multiple days, but only make that the master version when
it has all been entered. For this purpose, you can create branches.

A branch will start out with a copy of your data, but after that, any
changes made will only be visible from that branch. The original data
won't be modified. When you are satisfied with all your changes, you
can merge these changes back into your master version.

## Share your work with others

## Collaborate on data
