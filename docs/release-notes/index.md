---
title: Release notes
layout: default
has_children: true
nav_order: 7
---
# Release notes

The various components of TerminusDB have different release notes.

## TerminusDB Server v3.0.0 Release Notes

This is our TerminusDB Server v3 Emancipation release. We have removed
the masters from our default branching.

### New

* Reset API allows resetting branch to arbitrary commit
* Squash API operation now available
* Default branch is now called main and not master
* Added much more extensive coverage of API in the api.owl.ttl ontology
* Fixed some schema errors in woql.owl.ttl
* Added boolean flag (`all_witnesses`) for returning all or only the first witness from schema checks.
* Improvements to schema checking. Most large inserts will be 40% faster

### Backwards-Incompatible Changes

* Default branch will be set to main and not master, so that some
  calls which relied on master being default will fail. This can be
  fixed in all cases by doing a branch operation from master to main.
* By default only one witness is now returned in WOQL queries in which
  the resulting database violates schema constraints.

### Bug fixes

* Improved the API for organization management
* Improved CORS handling on some calls

[TerminusDB Version 3.0 Release Notes](https://github.com/terminusdb/terminusdb-server/blob/master/RELEASE_NOTES.md)

- - -

## TerminusDB Console v3.0 Release Notes

The Emancipation Release

* Support for integrated distributed operation, collaboration via TerminusHub 
* New integrated query libraries 
* Full support for Terminus Server 3.0 API 
* Improved support for RDF - turtle loading, prefix handling 
* Time travel & Commit navigator tools 
* Synchronization management tool 
* Branch & Merge management tool

- - -

## terminusdb-client-python v0.3.0

### New

* Updated create database to take advantage of default prefixes and schema graph creation happening on server
* Integrated all Revision Control API operations fully
* .vars() method - add v: to woql variables
* Reset allowing you to reset a branch to an arbitrary commit
* Post method for CSV uploads
* Triple endpoint for inserting turtle data directly to a graph
* Count triples functionality added

### Bug Fixes / Improvements

* Added 3 varieties of ordering specification as optional arguments to order_by
* fixed bug to make order_by("desc") work
* Empty selects no longer error

[TerminusDB Python Client v0.3.0 Release Notes](https://github.com/terminusdb/terminusdb-client-python/blob/master/RELEASE_NOTES.md)

{: .fs-6 .fw-300 }