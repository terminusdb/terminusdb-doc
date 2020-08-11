# Library Functions

WOQL.js includes a standard library of pattern matching functions which provide a flexible way of extracting records about the system's internal records without having to remember the predicates that are used under the hood. 

Unlike other WOQL.js functions, library functions are not part of the WOQLQuery object - they are accessed through the lib() call. Library functions have a standard signature which makes them all accessible in the same way. 

## Standard Arguments

All Library functions take the same three optional arguments. 

* Values
* Variables
* ResourceIdentifier

### Values

The values argument allows values to be passed for any of the internal variables which serve to constrain the query to a subset of the complete set. The Values argument comes in three forms: 

* [...Value] - a list of specific values, where each entry sets the corresonpding entry in the Variables list for the function. Any values that are not to be set can be omitted or set to null or false explicitly in which case no constraints will be applied. 

    example: lib().classes("scm:Person") - specifies that only the class with ID scm:Person will be matched

* object - a json key-value object where the keys are the names of the variables to be set and the value is the value for that variable. 

    example: lib().classes({'Class ID': "scm:Person"}) - specifies that only the class with ID scm:Person will be matched

* WOQLQuery - a woql query which serves as a constraint on any variable mentioned in the query

    example: 
    let [clist] = vars("Class List")
    lib().classes(member(clist, ['scm:Person', 'scm:Animal'])) - specifies that only the class with ID scm:Person and scm:Animal will be matched

### Variables

Each library function defines an internal list of variable names which are used by default to represent the results of the library query - the variables names can be overriden by passing in an alternative list of variable names. As with values, a null or false or an omitted variable means that the default will be used for that position

    example:
     let [cid, cname] = vars("Class", "Class Label")
     lib().classes(false, [cid, cname])

### ResourceIdentifier

Each library query is associated with a specific graph - by default the graph resource identifier is set to the appropriate graph of the current default database. This can be changed by setting the ResourceIdentifier argument to the desired graph. 

    example: 
      lib().classes(false, false, 'schema/extra')

## Library Functions with Standard Arguments

### classes

classes(Values, Variables, ResourceIdentifier)

Description: Retreives a list of classes from the schema. For each class matched, the following properties are returned 

Default Variables:
    Class ID - IRI of the class
    Class Name - Label of the Class (rdfs:label)
    Description - Description (rdfs:comment)
    Parents - Parent classes (rdfs:subClassOf)
    Children - Child classes (rdfs:subClassOf)
    Abstract - Abstract class designation (system:tag system:abstract) 

Returns
    WOQLQuery containing the classes pattern matching expression

Example
    let [cls] = vars("Class ID")
    lib().classes(eq(cls, 'scm:X'))
    //retrieves the class with IRI scm:X

### properties

properties(Values, Variables, ResourceIdentifier)

Description: Retreives the list of properties from the schema. For each property matched, the following properties are returned 

Default Variables:
    Property ID - IRI of the property
    Property Name - Label of the property (rdfs:label)
    Property Domain - Domain of the property (rdfs:domain)
    Property Type - Object | Data
    Property Range - Range of the property (rdfs:range)
    Property Description - Description (rdfs:comment)

Returns
    WOQLQuery containing the properties pattern matching expression

Example
    let [prop] = vars("Property Type")
    lib().classes(eq(prop, 'Object'))
    //retrieves all object properties

### graphs

graphs(Values, Variables, ResourceIdentifier)

Description: Retreives the list of graphs for the current database for each commit 

Default Variables:
    Graph ID - resource id of the graph (ref:graph_name)
    Graph Type - schema | instance | inference
    Branch ID - id of the branch (if the commit is branch head - ref:branch_name)
    Commit ID - id of the commit that points to the graph (ref:commit_id) 
    Graph IRI - Graph IRI
    Branch IRI - Branch IRI
    Commit IRI - Commit IRI

Returns
    WOQLQuery containing the graphs pattern matching expression

Example
    let [br] = vars("Branch ID")
    lib().graphs().not().eq(br, '')
    //retrieves all graphs on current branch heads

### branches

branches(Values, Variables, ResourceIdentifier)

Description: Retreives the list of branches for the current database  

Default Variables:
    Branch ID - resource id of the branch (ref:branch)
    Time - Time of last commit (ref:commit_timestamp)
    Commit ID - id of the commit that points to the graph (ref:ref_commit) 
    Branch IRI - Branch IRI
    Commit IRI - Commit IRI

Returns
    WOQLQuery containing the branches pattern matching expression

Example
    let [ci] = vars("Branch ID")
    lib().branches(eq(ci, 'main'))
    //retrieves branch with id main

### objects

objects(Values, Variables, ResourceIdentifier)

Description: Retreives the list of object ids and their types  

Default Variables:
    Object Type - type of the object
    Object ID - IRI of the object

Returns
    WOQLQuery containing the objects pattern matching expression

Example
    let [ot] = vars("Object Type")
    lib().objects(member(ot, ['scm:Y', 'scm:Z']))
    //retrieves all objects of type scm:Z and scm:Y

### property_values

property_values(Values, Variables, ResourceIdentifier)

Description: Retreives the list of property values for objects in the database  

Default Variables:
    Object ID - IRI of the object
    Property ID - IRI of the property
    Property Value - The value of the property (literal or JSON-LD document)
    Value ID - IRI of the value (object properties) 
    Value Class - Class of the value (object properties)

Returns
    WOQLQuery containing the property values pattern matching expression

Example
    let [p] = vars("Property ID")
    lib().property_values(eq(p, 'rdf:type'))
    //retrieves all type properties from the DB

### object_metadata

object_metadata(Values, Variables, ResourceIdentifier)

Description: Retreives the list of objects with metadata about their types  

Default Variables:
    Object ID - IRI of the object
    Name - Object label (rdfs:label)
    Description - Object description (rdfs:comment)
    Type ID - IRI of the type of the object (rdf:type)
    Type Name - Label of the type (rdfs:label from schema)
    Type Description - Description of the type (rdfs:comment from schema)

Returns
    WOQLQuery containing the object metadata pattern matching expression

Example
    let [t] = vars("Type ID")
    lib().object_metadata(eq(t, 'scm:Z'))
    //retrieves all objects of type scm:Z with their metadata

### property_metadata

property_metadata(Values, Variables, ResourceIdentifier)

Description: Retreives the list of properties with metadata about their types  

Default Variables:
    Object ID - IRI of the object
    Property ID - IRI of the property
    Property Name - Property label (rdfs:label)
    Property Value - Property Value 
    Property Description - Property description (rdfs:comment)

Returns
    WOQLQuery containing the property metadata pattern matching expression

Example
    lib().property_metadata()
    //retrieves all objects of type scm:Z with their metadata

### commits

commits(Values, Variables, ResourceIdentifier)

Description: Retreives the list of commits  

Default Variables:
    Commit ID - ID of the commit
    Commit IRI - IRI of the commit
    Time - timestamp of commit
    Author - Author of commit
    Message - commit message
    Parent ID - Commit ID of parent commit
    Parent IRI - IRI of parent commit
    Children - Array of child commits 

Returns
    WOQLQuery containing the commits pattern matching expression

Example
    lib().commits()

### commit_chain

commit_chain(Values, Variables, ResourceIdentifier)

Description: Retrieves chains of commits from one commit to another   

Default Variables:
    Head IRI - IRI of commit as chain starting point
    Tail IRI - IRI of commit as chain ending point
    Path - Path traversed from head to tail

Returns
    WOQLQuery containing the commit chain pattern matching expression

Example
    lib().commit_chain()

### repos

repos(Values, Variables, ResourceIdentifier)

Description: Retrieves information about remotes and their repositories in the repository graph   

Default Variables:
    Repository IRI - IRI of commit as chain starting point
    Repository Name - name of the repositoriy (ref:repository_name)
    Path - Path traversed from head to tail

Returns
    WOQLQuery containing the repository pattern matching expression

Example
    lib().repos(false, false, "admin/MyTestDB/_meta")
    //note: the resource id for repository graphs must be specified explicitly for the db

### dbs

dbs(Values, Variables, ResourceIdentifier)

Description: Retrieves information about the databases on the server   

Default Variables:
    DB Name - Name of the database (system:database_name)
    DB ID - IRI of the database document 
    Organization - ID of the organization that owns the DB
    Description - Description of the DB
    DB IRI - IRI of the database document in the system graph
    Organization IRI - IRI of the organization document in the system graph

Returns
    WOQLQuery containing the database pattern matching expression

Example
    lib().dbs()

### prefixes

prefixes(Values, Variables, ResourceIdentifier)

Description: Retrieves the list of IRI prefixes in use in the DB   

Default Variables:
    Prefix - The prefix string (eg. doc)
    URI - The full URI/IRI that the prefix refers to 
    Prefix Pair IRI - the IRI of the document that contains the prefix / URL

Returns
    WOQLQuery containing the prefix pattern matching expression

Example
    lib().prefixes()

### insert_prefix

insert_prefix(Values, Variables, ResourceIdentifier)

Description: Inserts a new prefix pair into the database  

Arguments: 
    Values - must contain [prefix, IRI] as either variables or string literals
    Variables - single variable, default is:
        Prefix Pair IRI - variable which will contain the generated IRI of the prefix pair
 
Returns
    WOQLQuery containing the prefix insertion expression 

Example
    lib().insert_prefix(['foaf', "http://xmlns.com/foaf/0.1/"])

### document_classes

document_classes(Values, Variables, ResourceIdentifier)

Description: Retrieves the list of document classes from the DB   

Default Variables:
    Class ID - IRI of the class
    Class Name - Label of the Class (rdfs:label)
    Description - Description (rdfs:comment)
    Parents - Parent classes (rdfs:subClassOf)
    Children - Child classes (rdfs:subClassOf)
    Abstract - Abstract class designation (system:tag system:abstract) 

Returns
    WOQLQuery containing the classes pattern matching expression

Example
    lib().document_classes()

### concrete_document_classes

concrete_document_classes(Values, Variables, ResourceIdentifier)

Description: Retrieves the list of non-abstract document classes from the DB   

Default Variables:
    Class ID - IRI of the class
    Class Name - Label of the Class (rdfs:label)
    Description - Description (rdfs:comment)
    Parents - Parent classes (rdfs:subClassOf)
    Children - Child classes (rdfs:subClassOf)
    Abstract - Abstract class designation (system:tag system:abstract) 

Returns
    WOQLQuery containing the classes pattern matching expression

Example
    lib().concrete_document_classes()

### document_metadata 

document_metadata (Values, Variables, ResourceIdentifier)

Description: Retreives the list of documents with metadata about their types  

Default Variables:
    Document ID - IRI of the document
    Name - document label (rdfs:label)
    Description - document description (rdfs:comment)
    Type ID - IRI of the type of the document (rdf:type)
    Type Name - Label of the type (rdfs:label from schema)
    Type Description - Description of the type (rdfs:comment from schema)

Returns
    WOQLQuery containing the object metadata pattern matching expression

Example
    lib().document_metadata()

### documents

documents(Values, Variables, ResourceIdentifier)

Description: Retreives the list of document ids and their types  

Default Variables:
    Document Type - type of the document
    Document ID - IRI of the document

Returns
    WOQLQuery containing the objects pattern matching expression

Example
    lib().documents()

## Commit Graph Navigation

The WOQL.js library also provides a set of functions for navigation of the commit graph by branch, time and commit id. These functions do not take the same arguments as the standard functions above.  There are two flavours of all graph navigation functions - one that returns all the meta-data for each commit, the other that returns only the commit ids - to allow these functions to be conveniently joined with other queries and filters.  

### commit_chain_full

commit_chain_full(Values, ResourceIdentifier)

Description: Retreives the a commit chain with full details of all commits (combines commits() and commit_chain())  

Arguments:
    Values - values array as per standard arguments 
    ResourceIdentifier - graph identifier (defaults to _commits)

Returns
    WOQLQuery containing the full commit chain pattern matching expression

Example
    lib().commit_chain_full()

### first_commit

first_commit()

Description: Retreives information about the first commit in the database  

Arguments: None - variable names are as per commits() function above

Returns
    WOQLQuery containing the first commit pattern matching expression: returns the same variables as the lib().commits() function

Example
    lib().first_commit()

### active_commit

active_commit(BranchID, Timestamp)

Description: Retrieves the details of the commit that was active at the given timestamp on the given branch  

Arguments: 
    BranchID (string*) - the id of the branch to aim for (for disambiguation when there are multiple child commits)
    Timestamp (string or decimal) - the timestamp (or variable containing the timestamp) of interest - defaults to now

Returns
    WOQLQuery containing the active commit pattern matching expression: returns the same variables as the lib().commits() function

Example
    lib().active_commit('main')

### commit_history

commit_history(CommitID, Count)

Description: Retreives the metadata for the passed CommitID and its parent commits - up to a total of Count steps (including the passed CommitID)

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the history starting from (included in results)
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit history - defaults to 10 

Returns
    WOQLQuery containing the commit history pattern matching expression: returns the same variables as the lib().commits() function for each entry

Example
    and(
        lib().active_commit_id('main', false, "Current Head ID"),
        lib().commit_history("v:Current Head ID", 5)
    )

### previous_commits

previous_commits(CommitID, Count)

Description: Retreives the metadata for the parent commits of the passed CommitID - up to a total of Count steps (not including the passed CommitID)

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the previous commits starting from (not included in results)
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit history - defaults to 1 

Returns
    WOQLQuery containing the previous commits pattern matching expression: returns the same variables as the lib().commits() function for each entry

Example
    and(
        lib().active_commit_id('main', false, "Current Head ID"),
        lib().previous_commits("v:Current Head ID", 5)
    )

### commit_future

commit_future(CommitID, BranchID, Count)

Description: Retreives the metadata for the passed CommitID and its future commits on branch BranchID - up to a total of Count steps (including the passed CommitID)

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the future starting from (included in results)
    BranchID (string*) - the id of the branch to aim for (for disambiguation when there are multiple child commits)
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit future - defaults to 10 

Returns
    WOQLQuery containing the commit history pattern matching expression: returns the same variables as the lib().commits() function for each entry

Example
    lib().commit_future('bi1qqga9sxlzgvv061b3zpe48mmjtbb', "main", 5)

### next_commits

next_commits(CommitID, BranchID, Count)

Description: Retreives the metadata for child commits of the passed CommitID on branch BranchID - up to a total of Count steps (not including the passed CommitID)

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the next commits starting from (not included in results)
    BranchID (string*) - the id of the branch to aim for (for disambiguation when there are multiple child commits)
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit future - defaults to 1 

Returns
    WOQLQuery containing the commit history pattern matching expression: returns the same variables as the lib().commits() function for each entry

Example
    lib().next_commits('bi1qqga9sxlzgvv061b3zpe48mmjtbb', "main", 4)

### active_commit_id

active_commit_id(CommitID, Timestamp, CommitIDVar)

Description: Retrieves the ID of the commit that was active at the given timestamp on the given branch - result is stored in CommitIDVar  

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the history for
    Timestamp (string or decimal) - the Unix timestamp (or variable containing the timestamp) of interest - defaults to now
    CommitIDVar (string) - the name of the variable in which to store the matched IDs (defaults to "Commit ID")

Returns
    WOQLQuery containing the pattern matching expression: returns one row per CommitIDVar value 

Example
    lib().active_commit_id('main')


### history_ids

history_ids(CommitID, Count, CommitIDVar)

Description: Retrieves the ids of the passed CommitID and the ids of its parents - up to a total of count ids (including the passed CommitID), the results are stored in CommitIDVar  

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the history for
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit history - defaults to 10 
    CommitIDVar (string) - the name of the variable in which to store the matched IDs (defaults to "Commit ID")

Returns
    WOQLQuery containing the pattern matching expression: returns one row per CommitIDVar value 

Example
    and(
        lib().active_commit_id('main', false, "Current Head ID"),
        lib().history_ids("v:Current Head ID", 5)
    )

### previous_commit_ids

previous_commit_ids(CommitID, Count, CommitIDVar)

Description: Retrieves the ids of the parent commits of the passed CommitID - up to a total of count ids (not including the passed CommitID), the results are stored in CommitIDVar  

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the previous commits starting from
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit history - defaults to 10 
    CommitIDVar (string) - the name of the variable in which to store the matched IDs (defaults to "Commit ID")

Returns
    WOQLQuery containing the pattern matching expression: returns one row per CommitIDVar value 

Example
    and(
        lib().active_commit_id('main', false, "Current Head ID"),
        lib().previous_commit_ids("v:Current Head ID", 5)
    )

### future_ids

future_ids(CommitID, BranchID, Count, CommitIDVar)

Description: Retrieves the ids of the passed CommitID and the ids of its parents - up to a total of count ids (including the passed CommitID), the results are stored in CommitIDVar  

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the history for
    BranchID (string*) - the id of the branch to aim for (for disambiguation when there are multiple child commits)
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit history - defaults to 10 
    CommitIDVar (string) - the name of the variable in which to store the matched IDs (defaults to "Commit ID")

Returns
    WOQLQuery containing the pattern matching expression: returns one row per CommitIDVar value 

Example
   lib().future_ids("bi1qqga9sxlzgvv061b3zpe48mmjtbb", "main", 4)

### next_commit_ids

next_commit_ids(CommitID, BranchID, Count, CommitIDVar)

Description: Retrieves the ids of the child commits of the passed CommitID - up to a total of count ids (not including the passed CommitID), the results are stored in CommitIDVar  

Arguments: 
    CommitID (string*) - the id of the commit to retrieve the next commits starting from
    BranchID (string*) - the id of the branch to aim for (for disambiguation when there are multiple child commits)
    Count (string or integer) - an integer or variable containing an integer representing the number of steps to include in the commit chain - defaults to 1 
    CommitIDVar (string) - the name of the variable in which to store the matched IDs (defaults to "Commit ID")

Returns
    WOQLQuery containing the pattern matching expression: returns one row per CommitIDVar value 

Example
   lib().next_commit_ids("bi1qqga9sxlzgvv061b3zpe48mmjtbb", "main", 4)