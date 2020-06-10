---
layout: default
title: Time Travel
parent: Revision Control
grand_parent: User guide
nav_order: 2
---

# Time Travel
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Script that Creates the Examples

Script that Creates the Examples below

## Sequence of WOQL queries as a script

Sequence of WOQL queries that updates new WOQL database and populates the commit graph with all the commits necessary to illustrate all of the examples in the sections.

---

# Using the commit graph to create time travel

Using the commit graph for time travel queries

simply put down the technique for using time stamps and commit chaining to find the active commit at any point in time.

---

# Time Traveling with the TerminusDB API

here is how you change the api endpoint to affect time travel

---

# The WOQL Time Travel Library



6 key queries <- explain them

# getFirstCommit(cresource) 
Gives you the first commit in the database

returns [Tail: IRI of first commit, CommitID: ID of first commit]

WOQLLibrary.prototype.getFirstCommit = function(cresource) {
    cresource= cresource || this.commits
    new WOQLQuery().using(cresource).and(
        new WOQLQuery().triple('v:Tail', 'ref:commit_id', "v:CommitID"),
        new WOQLQuery().not().triple('v:Tail', 'ref:commit_parent', 'v:Any'),
    )
}

Explanation - there is only single commit in the graph that does not have a parent - it is the first commit. 

# getCommitProperties
WOQLLibrary.prototype.getCommitProperties = function(commit_id, cresource) {
    cresource= cresource || this.commits
    let woql = new WOQLQuery().using(cresource).and(
        new WOQLQuery().eq("v:CommitID", commit_id),
        new WOQLQuery().triple("v:CommitIRI", 'ref:commit_id', commit_id),
        new WOQLQuery().triple("v:CommitIRI", 'ref:commit_timestamp', 'v:Time'),
        new WOQLQuery().opt().triple("v:CommitIRI", 'ref:commit_author', 'v:Author'),
        new WOQLQuery().opt().triple("v:CommitIRI", 'ref:commit_message', 'v:Message'),        
        new WOQLQuery()
            .opt()
            .and(
                new WOQLQuery().triple("v:CommitIRI", 'ref:commit_parent', 'v:ParentIRI'),
                new WOQLQuery().triple('v:ParentIRI', 'ref:commit_id', 'v:Parent'),
            ),
        new WOQLQuery()
            .opt()
            .select("v:Children")
            .group_by('v:ChildID', 'v:Child', 'v:Children')
                .and(
                    new WOQLQuery().triple('v:ChildID', 'ref:commit_parent', commitvar),
                    new WOQLQuery().triple('v:ChildID', 'ref:commit_id', 'v:Child'),
                ),
        new WOQLQuery()
            .opt()
            .and(
                new WOQLQuery().triple('v:BranchIRI', 'ref:branch_name', 'v:Branch'),
                new WOQLQuery().triple('v:BranchIRI', 'ref:ref_commit', commitvar),
            ),
    )
    return woql
}

Branch, Message, Time, Author, Children, Parent, Branch

Gets all possible metadata about a specific commit and loads it into a single binding with the following fields:

(note this is fast because we consider the commit in isolation without the branch context and do not have to traverse any relationships)

## Compounding Version 1:
WOQL.lib().getFirstCommit().and().lib().getCommitProperties()

## Get Commit Child On Branch

getChildOnBranch(commit_id, branch){
  new WOQLQuery().and(
      new WOQLQuery().triple('v:Branch', 'ref:branch_name', branch),
      new WOQLQuery().triple('v:Branch', 'ref:ref_commit', 'v:BHead'),
      new WOQLQuery().path('v:BHead', 'ref:commit_parent+', 'v:ChildIRI', 'v:Path'),
      new WOQLQuery().triple('v:CommitIRI', 'ref:commit_parent', "v:ChildIRI"),
      new WOQLQuery().triple('v:CommitIRI', 'ref:commit_id', commit_id),
      new WOQLQuery().triple('v:ChildIRI', 'ref:commit_id', "v:CommitID"),
  )
}

## loadBranchDetails(branch)

 let woql = new WOQLQuery().and(
        new WOQLQuery().triple('v:BranchIRI', 'ref:branch_name', branch),
        new WOQLQuery()
            .opt()
            .and(
                new WOQLQuery().triple('v:BranchIRI', 'ref:ref_commit', 'v:HeadIRI'),
                new WOQLQuery().triple('v:HeadIRI', 'ref:commit_id', head),
                new WOQLQuery().triple('v:HeadIRI', 'ref:commit_timestamp', 'v:Time'),
            ),
    )
    
Returns the name of a branch and the time of the last commit to head of that branch

This is important because this tells you if somebody has advance head while you were doing something else. 

## loadActiveCommitAtTime(ts, branch)

WOQLQuery()
    .limit(1)
    .or(
            new WOQLQuery().and(
                new WOQLQuery().not().greater('v:LastCommitBefore', 'v:HeadTime'),
                new WOQLQuery().eq('v:CommitID', 'v:HeadID'),
            ),
            new WOQLQuery()
                .limit(1)
                .and(
                    new WOQLQuery().path('v:Head', 'ref:commit_parent+', 'v:Tail', 'v:Path'),
                    new WOQLQuery().triple('v:Tail', 'ref:commit_id', 'v:TailID'),
                    new WOQLQuery().triple('v:Tail', 'ref:commit_timestamp', 'v:TailTime'),
                    new WOQLQuery().not().greater('v:LastCommitBefore', 'v:TailTime'),
                    new WOQLQuery().eq('v:CommitID', 'v:TailID'),
                ),
        ),
    )


6 key queries <- explain them

/**
 * pass the client and uses looks for current branch in current commits graph
 */
WOQLLibrary.prototype.loadBranchGraphNames = function(branch) {
    return this.getBranchGraphNames(branch, this.commits)
}

/**
 * Loads meta-data about the types of graphs that existed in a DB at the time of a particular commit
 */
WOQLLibrary.prototype.getGraphsAtRef = function(commitID, cresource) {
    let woql = new WOQLQuery().and(
        new WOQLQuery().triple('v:CommitIRI', 'ref:commit_id', commitID),
        new WOQLQuery().or(
            new WOQLQuery()
                .triple('v:CommitIRI', 'ref:instance', 'v:GraphIRI')
                .eq('v:GraphType', 'instance'),
            new WOQLQuery()
                .triple('v:CommitIRI', 'ref:schema', 'v:GraphIRI')
                .eq('v:GraphType', 'schema'),
            new WOQLQuery()
                .triple('v:CommitIRI', 'ref:inference', 'v:GraphIRI')
                .eq('v:GraphType', 'inference'),
        ),
        new WOQLQuery().triple('v:GraphIRI', 'ref:graph_name', 'v:GraphID'),
    )
    return this.pointQueryAtResource(woql, cresource)
}

WOQLLibrary.prototype.loadGraphsAtRef = function(ref) {
    return this.getGraphsAtRef(ref, client.commits)
}

WOQLLibrary.prototype.loadGraphStructure = function(branch, ref) {
    return this.getGraphStructure(branch, ref, client.commits)
}

/**
 * Loads the branches, graphs in those branches and their sizes for any given ref / branch
 */
WOQLLibrary.prototype.getGraphStructure = function(branch, ref, cresource) {
    if (ref) {
        var start = this.getGraphsAtRef(ref)
    } else {
        var start = this.getBranchGraphNames(branch)
    }

    let commitquery = new WOQLQuery().and(start, new WOQLQuery().opt(this.getFirstCommit()))
    return this.pointQueryAtResource(commitquery, cresource)

    let full = new WOQLQuery().and(
        new WOQLQuery().using(cresource, commitquery),
        new WOQLQuery().and(
            new WOQLQuery().concat('v:GraphType/v:GraphID', 'v:GraphFilter'),
            new WOQLQuery().size('v:GraphFilter', 'v:Size'),
            new WOQLQuery().triple_count('v:GraphFilter', 'v:Triples'),
        ),
    )
    return full
}

# The WOQL Time Travel Console


---

# Use Cases

### 1. updating of numbers in a bank a/c

rewinding to a point in time to see who the author of the last commit at a specific time

### 2. machine learning use case

Idea: Compare predictions result changes when deploying new models

simplest possible labour saving device for preventing reloading of data in machine learning pipeline
