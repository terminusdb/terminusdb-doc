## Non Primitive Functions

### WOQL Literals, Prefixes & IRI Constants

#### string 

string(Val1) 

Status: Stable

Description: Generates explicitly a JSON-LD string literal from the input    

Arguments: 
    Val1 (literal*) - any literal type

Returns: 
    A JSON-LD string literal

Example: 
    string(1)
    //returns { "@type": "xsd:string", "@value": "1" }

#### literal 

literal(Val, Type) 

Status: Stable

Description: Generates explicitly a JSON-LD string literal from the input    

Arguments: 
    Val (literal*) - any literal type
    Type (string*) - an xsd or xdd type

Returns: 
    A JSON-LD literal 

Example: 
    literal(1, "nonNegativeInteger")
    //returns { "@type": "xsd:nonNegativeInteger", "@value": 1 }

#### iri 

iri(Val1) 

Status: Stable

Description: Explicitly sets a value to be an IRI - avoiding automatic type marshalling   

Arguments: 
    Val1 (string*) - string which will be treated as an IRI

Returns: 
    A JSON-LD IRI value

Example:
    iri("dc:title")
    //returns { "@type": "woql:Node", "woql:node": "dc:title" }

### Basic Helper Functions

#### query 

query() 

Status: Stable

Description: Generates an empty WOQLQuery object 

Arguments: None

Returns: 
    An empty WOQLQuery object

Example: 
    let q = query()
    //then q.triple(1, 1) ...
    
#### json 

json(JSONLD) 

Status: Stable

Description: translates between the JSON-LD and object version of a query - if an argument is passed, the query object is created from it, if none is passed, the current state is returned as a JSON-LD

Arguments: 
    JSONLD (json) - optional JSON-LD woql document encoding a query

Returns: 
    either a JSON-LD or a WOQLQuery object

Example: 
    let q = triple("a", "b", "c")
    let qjson = q.json()
    let p = json(qjson)
    //q an p both contain: {"@type": "woql:Triple", "woql:subject": { "@type": "woql:Node", "woql:node": "doc:a"}, "woql:predicate": ....

#### vars 

vars(...Varnames) 

Status: Stable

Description: generates javascript variables for use as WOQL variables within a query

Arguments: 
    ([string*]) an array of strings, each of which will server as a variable

Returns: 
    an array of javascript variables which can be dereferenced using the array destructuring operation

Example: 
    const [a, b, c] = vars("a", "b", "c")
    //a, b, c are javascript variables which can be used as WOQL variables in subsequent queries

## Compound Functions

### Shorthand Compound Functions
Shorthand compound functions provide shorthand forms for commonly used functions to avoid having to write the same basic patterns repeatedly

#### star 

star(Graph, Subject, Object, Predciate) 

Status: Stable

Description: generates a query that by default matches all triples in a graph  

Arguments: 
    Graph (string) - Option Resource String identifying the graph to be searched for the pattern 
    Subject (string) - Optional IRI of triple's subject or a variable 
    Predicate (string) - Optional IRI of a property or a variable 
    Object (string) - Optional IRI of a node or a variable, or a literal 

Returns: 
    A WOQLQuery which contains the pattern matching expression

Example: 
    star("schema/main")
    //will return every triple in schema/main graph

#### all 

all(Subject, Object, Predciate, Graph) 

Status: Stable

Description: generates a query that by default matches all triples in a graph - identical to star() except for order of arguments

Arguments: 
    Subject (string) - Optional IRI of triple's subject or a variable 
    Predicate (string) - Optional IRI of a property or a variable 
    Object (string) - Optional IRI of a node or a variable, or a literal 
    Graph (string) - Optional Resource String identifying the graph to be searched for the pattern 

Returns: 
    A WOQLQuery which contains the pattern matching expression

Example: 
    all("mydoc")
    //will return every triple in the instance/main graph that has "doc:mydoc" as its subject

#### nuke 

nuke(Graph) 

Status: Stable

Description: Deletes all triples in the graph 

Arguments: 
    Graph (string) - Optional Resource String identifying the graph from which all triples will be removed 

Returns: 
    A WOQLQuery which contains the deletion expression

Example: 
    nuke("schema/main")
    //will delete everything from the schema/main graph


### Compound Schema Functions
Compound schema functions are compound functions specifically designed to make generating schemas easier. They generate multiple inserts for each function

#### add_class 

add_class(ClassIRI, Graph) 

Status: Stable

Description: adds a new class definition to the schema

Arguments: 
    ClassIRI (string*) - IRI or variable containing IRI of the new class to be added (prefix default to scm)
    Graph (string) - Optional Resource String identifying the schema graph into which the class definition will be written 

Returns: 
    A WOQLQuery which contains the add class expression

Example: 
    add_class("MyClass")
    //equivalent to add_quad("MyClass", "type", "owl:Class", "schema/main")

#### add_property 

add_property(PropIRI, RangeType, Graph) 

Status: Stable

Description: adds a new property definition to the schema

Arguments: 
    PropIRI (string*) - IRI or variable containing IRI of the new property to be added (prefix default to scm)
    RangeType (string) - optional IRI or variable containing IRI of the range type of the new property (defaults to xsd:string)
    Graph (string) - Optional Resource String identifying the schema graph into which the property definition will be written 

Returns: 
    A WOQLQuery which contains the add property expression

Example: 
    add_property("myprop")
    //equivalent to add_quad("myprop", "type", "owl:DatatypeProperty", "schema/main").add_quad("myprop", "range", "xsd:string", "schema/main")

#### doctype 

doctype(ClassIRI, Graph) 

Status: Stable

Description: Adds a new document class to the schema

Arguments: 
    ClassIRI (string*) - IRI or variable containing IRI of the new document class to be added (prefix default to scm)
    Graph (string) - Optional Resource String identifying the schema graph into which the class definition will be written 

Returns: 
    A WOQLQuery which contains the add document class expression

Example: 
    doctype("MyClass")
    //equivalent to add_quad("MyClass", "type", "owl:Class", "schema/main").add_quad("MyClass", "subClassOf", "system:Document", "schema/main")

#### delete_class 

delete_class(ClassIRI, Graph) 

Status: Experimental / Unstable

Description: Deletes a class - including all properties and incoming links - from the schema 

Arguments: 
    ClassIRI (string*) - IRI or variable containing IRI of the class to be deleted (prefix default to scm)
    Graph (string) - Optional Resource String identifying the schema graph from which the class definition will be deleted 

Returns: 
    A WOQLQuery which contains the class deletion expression

Example: 
    delete_class("MyClass")

#### delete_property 

delete_property(PropIRI, Graph) 

Status: Experimental / Unstable

Description: Deletes a property from the schema and all its references incoming and outgoing   

Arguments: 
    PropIRI (string*) - IRI or a variable containing IRI of the property to be deleted (prefix defaults to scm)
    Graph (string) - Optional Resource String identifying the schema graph from which the property definition will be deleted 

Returns: 
    A WOQLQuery which contains the property deletion expression

Example: 
    delete_property("MyProp")

#### schema 

schema(Graph) 

Status: Deprecated

Description: Generates an empty query object - identical to query - included for backwards compatibility as before v3.0, the schema functions were in their own namespace. 

Arguments: 
    Graph (string) - Optional Resource String identifying the graph which will be used for subsequent chained schema calls 

Returns: 
    An empty WOQLQuery with the internal schema graph pointes set to Graph 

Example: 
    schema("schema/dev").add_class("X")
    //equivalent to add_class("X", "schema/dev") - non-deprecated version


### Builder / Partial Functions

Builder functions are different from other WOQL functions in that they cannot be used in isolation - they produce partial functions in isolation and need to be chained onto other functions in order to form complete functions in their own right. Builder functions must be chained after a function that provides at least a subject (triple, add_triple, add_quad, delete_triple). Multiple builder functions can be chained together.

#### node 

node(NodeID, ChainType) 

Status: Stable

Description: Specifies the identity of a node that can then be used in subsequent builder functions. Note that node() requires subsequent chained functions to complete the triples / quads that it produces - by itself it only generates the subject. 

Arguments: 
    NodeID (string*) The IRI of a node or a variable containing an IRI which will be the subject of the builder functions 
    ChainType (string) Optional type of builder function to build (can be Triple, Quad, AddTriple, AddQuad, DeleteTriple, DeleteQuad) - defaults to Triple  
Returns: 
    A WOQLQuery which contains the partial Node pattern matching expression

Example: 
    node("mydoc").label("my label")
    //equivalent to triple("mydoc", "label", "my label")

#### insert 

insert(Node, Type, Graph) 

Status: Stable

Description: Inserts a single triple into the database declaring the Node to have type Type, optionally into the specified graph  

Arguments: 
    Node (string*) - IRI string or variable containing the IRI of the node to be inserted
    Type (string*) - IRI string or variable containing the IRI of the type of the node 
    Graph (string) - Optional Graph resource identifier

Returns: 
    A WOQLQuery which contains the insert expression

Example: 
    insert("mydoc", "MyType")
    //equivalent to add_triple("mydoc", "type", "MyType")

#### graph 

graph(Graph) 

Status: Stable

Description: sets the graph resource ID that will be used for subsequent chained function calls  

Arguments: 
    Graph (string*) Graph Resource String literal 

Returns: 
    A WOQLQuery which contains the partial Graph pattern matching expression

Example: 
    node("MyClass", "AddQuad").graph("schema/main").label("My Class Label")
    //equivalent to add_quad("MyClass", "label", "My Class Label", "schema/main")

#### abstract 

abstract(Graph, Subject) 

Status: Stable

Description: adds an abstract designation to a class

Arguments: 
    Graph (string) optional Graph Resource String literal - defaults to "schema/main"
    Subject (string) optional IRI or variable containing IRI of the subject

Returns: 
    A WOQLQuery which contains the Abstract tag expression

Example: 
    node("MyClass", "AddQuad").abstract()
    //equivalent to add_quad("MyClass", "system:tag", "system:abstract","schema/main")

#### property 

property(PropIRI, Type_or_Value) 

Status: Stable

Description: Creates a property in the schema or adds a property to the instance data, or creates a property matching rule, depending on context  

Arguments: 
    PropIRI (string*) - the IRI of the property or a variable containing the property 
    Type_or_Value (string or literal*) - the value of the property (instance) or the type of the property (schema)

Returns: 
    A WOQLQuery which contains the property matching / insert expression

Example: 
    doctype("X").property("Y", "string")
    //creates a document type X with a property Y of type string

#### domain 

domain(ClassIRI) 

Status: Stable

Description: Specifies the domain of a property in a property chain

Arguments: 
    ClassIRI (string *) IRI of class or variable containing IRI

Returns: 
    A WOQLQuery which contains the domain expression

Example: 
    add_property("MyProp").domain("MyClass")

#### label 

label(Label, Lang) 

Status: Stable

Description: adds a label to an element in a chain using the rdfs:label predicate

Arguments: 
    Label (string *) string literal containing label or variable containing string
    Lang (string) optional language tag (e.g. "en")

Returns: 
    A WOQLQuery which contains the label in the rdfs:label predicate

Example: 
    add_class("MyClass").label("My Class Label")
    //creates the class and gives it a label

#### description 

description(Comment, Lang) 

Description: adds a description to an element in a chain using the rdfs:comment predicate

Arguments: 
    Comment (string *) string literal containing label or variable containing string
    Lang (string) optional language tag (e.g. "en")

Returns: 
    A WOQLQuery which contains the description in the rdfs:comment predicate

Example: 
    let [doc] = vars("doc")
    node(doc).description("My Class Description")
    //matches any document with the given description

#### parent 

parent(...ParentIRIs) 

Status: Stable

Description: Adds parent class clause(s) to a chain using the rdfs:subClassOf predicate

Arguments: 
    ParentIRI ([string*]) - list of class IRIs or variables containing class IRIs representing parent classes of the current class

Returns: 
    A WOQLQuery which contains the parent expression

Example: 
    add_class("Y").parent("X")
    //creates class Y as a subClass of class X

#### max 

max(Count) 

Status: Stable

Description: adds a maximum cardinality constraint to an add_property chain   

Arguments: 
    Count (integer or string*) - a non negative integer or a variable containing a non-negative integer

Returns: 
    A WOQLQuery which contains the maximum cardinality expression

Example: 
    add_property("MyProp").domain("X").max(1)
    //creates a string property in class X with a maximum cardinality of 1

#### min 

min(Count) 

Status: Stable

Description: adds a minimum cardinality constraint to an add_property chain   

Arguments: 
    Count (integer or string*) - a non negative integer or a variable containing a non-negative integer

Returns: 
    A WOQLQuery which contains the minimum cardinality expression

Example: 
    add_property("MyProp").domain("X").min(1)
    //creates a string property in class X with a minimum cardinality of 1

#### cardinality 

cardinality(Count) 

Status: Stable

Description: adds an exact cardinality constraint to an add_property chain   

Arguments: 
    Count (integer or string*) - a non negative integer or a variable containing a non-negative integer

Returns: 
    A WOQLQuery which contains the cardinality expression

Example: 
    add_property("MyProp").domain("X").cardinality(1)
    //creates a string property in class X with an exact cardinality of 1

#### insert data

insert_data(Data, Graph) 

Status: Stable

Description: Inserts data as an object - enabling multiple property values to be inserted in one go   

Arguments: 
    Data (object*) a json object containing 
        id (string*) IRI or variable containing IRI of the entity to be inserted
        *key* (string*) keys representing properties that the entity has (label, description, type and any other valid property for the object)
    Graph (string) an optional graph resource identifier (defaults to "instance/main" if no using or into is specified)

Returns: 
    A WOQLQuery which contains the insertion expression

Example: 
    let data = {id: "doc:joe", type: "Person", label: "Joe", description: "My friend Joe", age: 42}
    insert_data(data)

#### insert_class_data 

insert_class_data(Data, Graph) 

Status: Stable

Description: Inserts data about a class as a json object - enabling a class and all its properties to be specified in a single function

Arguments: 
    Data (object*) a json object containing 
        id (string*) IRI or variable containing IRI of the class to be inserted
        *key* (string*) keys representing properties that the class has (label, description, parent and any properties that the class has)
    Graph (string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)

Returns: 
    A WOQLQuery which contains the insertion expression

Example: 
    let data = {id: "Robot", label: "Robot", parent: ["X", "MyClass"]}
    insert_class_data(data)

#### doctype_data 

insert_doctype_data(Data, Graph) 

Status: Stable

Description: Inserts data about a document class as a json object - enabling a document class and all its properties to be specified in a single function

Arguments: 
    Data (object*) a json object containing 
        id (string*) IRI or variable containing IRI of the document class to be inserted
        *key* (string*) keys representing properties that the document class has (label, description, parent and any properties that the class has)
    Graph (string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)

Returns: 
    A WOQLQuery which contains the insertion expression

Example: 
    let data = { id: "Person", label: "Person",  age: { label: "Age", range: "xsd:integer", max: 1}}
    insert_doctype_data(data)

#### insert_property_data 

insert_property_data(Data, Graph) 

Status: Stable

Description: Inserts data about a document class as a json object - enabling a document class and all its properties to be specified in a single function

Arguments: 
    Data (object*) a json object containing 
        id (string*) IRI or variable containing IRI of the property to be inserted
        *key* (string*) keys representing attributes that the property has (label, description, domain, range, max, min, cardinality)
    Graph (string) an optional graph resource identifier (defaults to "schema/main" if no using or into is specified)

Returns: 
    A WOQLQuery which contains the insertion expression

Example: 
    let data = {id: "prop", label: "Property", description: "prop desc", range: "X", domain: "X", max: 2, min: 1}
    insert_property_data(data)

