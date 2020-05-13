---
layout: default
title: Datatypes
parent: Schema
nav_order: 3
---
Datatypes - Literals and Enumerated Types
{:toc}

---

## Introduction

TermiusDB follows OWL in using the xsd datatypes for defining basic literal types like strings and numbers. Every datatype property must be defined as having a specfic datatype which defines the range of acceptable values for that property. 

TerminusDB supports the full range of <a href="https://www.w3.org/2011/rdf-wg/wiki/XSD_Datatypes">xsd datatypes</a> and adds a number of our own <a href="https://terminusdb.com/schema/xdd">extended datatypes</a> which are particularly  useful in practice and are typically omitted from datatype defintions. 

In practice, many of the XSD datatypes are not particularly useful - focused on legacy features of XML. However, xsd provides a well-defined and extensible framework for datatype definitions.

Terminus DB also provides support for the definition of enumerated datatypes. 

### Principle XSD Types Supported

Internally Terminus supports more xsd datatypes but most of them are not useful in practice - this table just lists the useful ones

<table cellpadding="4" border="1">
<tbody><tr>
<th> Datatype
</th>
<th> JSON LD Example</th>
<th> Notes
</th></tr>
<tr>
<td> xsd:anyURI
</td>
<td> {@type : "xsd:anyURI", @value: "https://veryloose definition/of a/uri"}
</td>
<td>
</td></tr>
<tr>
<td> xsd:base64Binary
</td>
<td> {@type : "xsd:base64Binary", @value: "aGVsbG8gd29ybGQ="}
</td>
<td>
</td></tr>
<tr>
<td> xsd:boolean
</td>
<td> {@type : "xsd:boolean", @value: true}
</td>
<td>
</td></tr>
<tr>
<td> xsd:byte
</td>
<td> {@type : "xsd:byte", @value: 123}
</td>
<td>A number between -128 and 127
</td></tr>
<tr>
<td> xsd:date
</td>
<td> {@type : xsd:boolean, @value: "2001-10-23"}
</td>
<td>YYYY-MM-DD format with optional timezone suffix
</td></tr>
<tr>
<td> xsd:dateTime
</td>
<td>  {@type : "xsd:dateTime", @value: "2001-10-23T23:12:11.1"}
</td>
<td>YYYY-MM-DDTHH:MM:SS.sss format with optional timezone suffix
</td></tr>
<tr>
<td> xsd:dateTimeStamp
</td>
<td>  {@type : "xsd:dateTimeStamp", @value: "2001-10-23T23:12:11.1-05:00"}
</td>
<td>Same YYYY-MM-DDTHH:MM:SS.sss format as xsd:dateTime but the timezone suffix is required (+-HH:MM or Z to indicate UTC)
</td></tr>
<tr>
<td> xsd:decimal
</td>
<td> {@type : "xsd:decimal", @value: 23.323}
</td>
<td>
</td></tr>
<tr>
<td> xsd:double
</td>
<td> {@type : "xsd:double", @value: 23.323323323423423}
</td>
<td>
</td></tr>
<tr>
<td> xsd:float
</td>
<td> {@type : "xsd:float", @value: 23.3233223}
</td>
<td>
</td></tr>
<tr>
<td> xsd:gDay
</td>
<td> {@type: "xsd:gDay", @value: "---01"}
</td>
<td>Refers to a day that occurs once every month format is ---DD
</td></tr>
<tr>
<td> xsd:gMonth
</td>
<td> {@type: "xsd:gMonth", @value: "--09"}
</td>
<td>Refers to a month that occurs once every year, format is --MM
</td></tr>
<tr>
<td> xsd:gMonthDay
</td>
<td> {@type: "xsd:gMonthDay", @value: "--09-23"}
</td>
<td>Refers to a month and day that occurs once every year, format is --MM-DD
</td></tr>
<tr>
<td> xsd:gYear
</td>
<td> {@type: "xsd:gYear", @value: "2011"}
</td>
<td>4 digit year - can also be negative -1000 refers to 1000 BCE
</td></tr>
<tr>
<td> xsd:gYearMonth
</td>
<td> {@type: "xsd:gYearMonth", @value: "2011-01"}
</td>
<td>A specific month in a specific hear - format is YYYY-MM
</td></tr>
<tr>
<td> xsd:int
</td>
<td> {@type: "xsd:int", @value: 2}
</td>
<td>The value space of xsd:int is the set of common single-size integers (32 bits), the integers between -2147483648 and 2147483647. Its lexical space allows any number of insignificant leading zeros.</td></tr>
<tr>
<td> xsd:integer
</td>
<td> {@type: "xsd:integer", @value: -2}
</td>
<td>The value space of xsd:integer includes the set of all the signed integers, with no restriction on range. Its lexical space allows any number of insignificant leading zeros.
</td></tr>
<tr>
<td> xsd:language
</td>
<td> {@type: "xsd:language", @value: "EN-IE"}
</td>
<td>Values of the <code>xsd:language</code> type conform to RFC 3066, <cite>Tags for the Identification of Languages</cite>.
</td></tr>
<tr>
<td> xsd:long
</td>
<td> {@type: "xsd:long", @value: 543245345}
</td>
<td>Long integer - double-size integers (64 bits) — the integers between -9223372036854775808 and 9223372036854775807. Its lexical space allows any number of insignificant leading zeros.
</td></tr>
<tr>
<td> xsd:negativeInteger
</td>
<td> {@type: "xsd:negativeInteger", @value: -543245345}
</td>
<td>Less than 0
</td></tr>
<tr>
<td> xsd:nonNegativeInteger
</td>
<td> {@type: "xsd:nonNegativeInteger", @value: 0}
</td>
<td>Greater than or equal to 0
</td></tr>
<tr>
<td> xsd:nonPositiveInteger
</td>
<td> {@type: "xsd:nonPositiveInteger", @value: 0}
</td>
<td>Less than or equal to 0
</td></tr>
<tr>
<td> xsd:positiveInteger
</td>
<td> {@type: "xsd:positiveInteger", @value: 1}
</td>
<td>Greater than zero
</td></tr>
<tr>
<td> xsd:short
</td>
<td> {@type: "xsd:short", @value: 1}
</td>
<td>A short integer (16 bits) between -32768 and 32767
</td></tr>
<tr>
<td> xsd:string
</td>
<td> {@language: "en", @type: "xsd:string", @value: "this is the string"}
</td>
<td>If strings have a language, we can omit the type
</td></tr>
<tr>
<td> xsd:time
</td>
<td> {@type: "xsd:time", @value: "01:02:03.3223"}
</td>
<td>Format is HH:MM:SS.ssss with an optional timezone suffix
</td></tr>
<tr>
<td> xsd:unsignedByte
</td>
<td> {@type: "xsd:unsignedByte", @value: 1}
</td>
<td>Can take values of 0 to 255
</td></tr>
<tr>
<td> xsd:unsignedInt
</td>
<td> {@type: "xsd:unsignedInt", @value: 64000}
</td>
<td>Can take any value between 0 and 4294967295
</td></tr>
<tr>
<td> xsd:unsignedLong
</td>
<td> {@type: "xsd:unsignedLong", @value: 64000}
</td>
<td>An integer between 0 and 18446744073709551615
</td></tr>
<tr>
<td> xsd:unsignedShort
</td>
<td> {@type: "xsd:unsignedShort", @value: 64000}
</td>
<td>An integer between 0 and 65535
</td></tr>
</tbody></table>
<p></p>

<h3>XDD Types Supported</h3>
<p>
</p><table cellpadding="4" border="1">
<tbody><tr>
<th>Datatype
</th>
<th>Example</th>
<th>Notes
</th></tr>
<tr>
<td>xdd:coordinate
</td>
<td> {@type: "xdd:coordinate", @value: "[43.35353234,45.66645634]"}
</td><td>Represents a point coordinate on the earth's surface, identified by a latitude, longitude pair, separated by a comma and wrapped with square brackets</td>
</tr>
<tr>
<td>xdd:coordinatePolyline
</td>
<td> {@type: "xdd:coordinatePolyline", @value: "[[23.23423432,-42.423423535],[43.35353234,45.66645634]]"}</td>
<td>Represents a line across the earth's surface. An array of xdd:coordinate values, separated by a comma and wrapped with square brackets - there must be at least 2 coordinate pairs in the line.</td>
</tr>
<tr>
<td>xdd:coordinatePolygon
</td>
<td> {@type: "xdd:coordinatePolygon", @value: "[[23.23423432,-42.423423535],[43.35353234,45.66645634],[-65.35353234,-2.66645634]]"}</td>
<td>Represents a closed polygon on the earth's surface. An array of xdd:coordinate values, separated by a comma and wrapped with square brackets - there must be at least 3 coordinate pairs in the line and they should form a closed shape.</td>
</tr>
<tr>
<td>xdd:integerRange</td>
<td> {@type: "xdd:integerRange", @value: "[23,30]"}</td>
<td>An uncertain integer number, what is somewhere between the two ranges, expressed either as i) an uncertainty range - somewhere between a and b, separated by a comma and wrapped in square brackets, or ii) a simple integer</td></tr>
<tr>
<td>xdd:decimalRange</td>
<td> {@type: "xdd:decimalRange", @value: "[23.323,-3.6754]"}</td>
<td>A decimal value expressed as an uncertainty range - somewhere between a and b (or a simple decimal number)</td></tr>
<tr>
<td>xdd:dateRange</td>
<td> {@type: "xdd:dateRange", @value: "[2001-01-02,2003-03-01]"}</td>
<td>A date expressed as an uncertainty range - somewhere between date a and date b</td></tr>
<tr>
<td>xdd:gYearRange</td>
<td> {@type: "xdd:gYearRange", @value: "[2001,2003]"}</td>
<td>A year expressed as an uncertainty range - somewhere between year a and year b</td></tr>
<tr>
<td>xdd:url</td>
<td> {@type: "xdd:url", @value: "http://my.url.com/hello_world.png"}</td>
<td>A valid HTTP/HTTPS URL</td></tr>
<tr>
<td>xdd:email</td>
<td> {@type: "xdd:email", @value: "obama@whitehouse.gov"}</td>
<td>A valid Email Address according to rfc 5322</td></tr>
<tr>
<td>xdd:html</td>
<td> {@type: "xdd:html", @value: "&lt;p&gt;hello world&lt;/p&gt;"}</td>
<td>A HTML encoded string</td></tr>
<tr>
<td>xdd:json</td>
<td> {@type: "xdd:json", @value: "{hello: \"world\"}"}</td>
<td>A JSON encoded string</td></tr>
</tbody></table>
<p></p>

## Enumerated Types

It is often useful to have properties that can take on one or more of an enumerated set of values (e.g. we might want a property that has a value of either: `absent`, `present`, or `unknown`) rather than just using strings.  These types In the TerminusDB schema you can define specific properties as having ranges that are enumerated types in the following way.


<div class="code-example" markdown="1">

```js
let choices = [ 
    ["scm:absent", "Absent", "The feature was absent in this historical context"], 
    ["scm:present", "Present", "The feature was present in this historical context"], 
    ["scm:unknown", "Unknown", "It is not known whether the feature was present or absent in the context"]
] 

WOQL.schema().generateChoiceList("Presence", "Presence", "The epistemic state - is the feature present?", choices) 
```
</div>

In OWL, this is encoded in the following way: 

<div class="code-example" markdown="1">

```ttl
scm:Presence
  a owl:Class ;
  rdfs:comment "The epistemic state - is the feature present?"@en ;
  rdfs:label "Presence"@en ;
  owl:oneOf ( scm:unknown scm:absent scm:present ) .

scm:absent
  a scm:Presence ;
  rdfs:comment "The feature was absent in this historical context"@en ;
  rdfs:label "Absent"@en .
  
scm:present
  a scm:Presence ;
  rdfs:comment "The feature was present in this historical context"@en ;
  rdfs:label "Present"@en .  
  
scm:unknown
  a scm:Presence ;
  rdfs:comment "It is not known whether the feature was present or absent in the context"@en ;
  rdfs:label "Unkown"@en .  

```
</div>

Once an enumerated type has been created in this way, we can use it as the range of any properties we want.  

<div class="code-example" markdown="1">

```js
WOQL.add_property("wear", "Presence").label("Signs of Wear").domain("Article") 
```
</div>

<div class="code-example" markdown="1">

```ttl
scm:wear 
   a owl:ObjectProperty;
   rdfs:label "Signs of Wear"@en;
   rdfs:domain scm:Article;
   rdfs:range scm:Presence.
```
</div>

Note that in OWL, properties that use enumerated datatypes are objectProperties, not datatype properties. Finally, note that there are a very large number of ways in which enumerated properties can be implemented in OWL. TerminusDB provides various shortcuts which use this particular encoding but does not put any limit on how you choose to encode such concepts in the schema. You are free to use another different encoding schema at your pleaure. 

## Example Datatype Schema 

<p>The <a href="https://github.com/terminusdb/terminus-schema">terminus-schema repository</a> contains a datatypes.owl.ttl file which includes a class that has a broad range of TerminusDB datatypes in use. If you load the file below into a TerminusDB schema, you should be able to see all the examples of datatypes in action. 
</p>

<div class="code-example">
  
```ttl

@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .
@prefix owl: &lt;http://www.w3.org/2002/07/owl#&gt; .
@prefix tcs: &lt;http://terminusdb.com/schema/tcs#&gt; .
@prefix xdd: &lt;http://terminusdb.com/schema/xdd#&gt; .
@prefix datatypes: &lt;http://terminusdb.com/schema/datatypes#&gt; .

datatypes:DatatypeHolder
  a owl:Class ;
  rdfs:subClassOf tcs:Entity;
  rdfs:comment "An entity that contains an example of every atomic datatype (non-compound) supported by the DB"@en;
  rdfs:label "Datatype Examples"@en .

datatypes:link
  a owl:ObjectProperty;
  rdfs:label "Document Link Type"@en;
  rdfs:domain datatypes:DatatypeHolder;
  rdfs:range datatypes:DatatypeHolder.  

datatypes:coord
  rdfs:label "xdd:coordinate"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:coordinate .

datatypes:coordline
  rdfs:label "xdd:coordinatePolyline"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:coordinatePolyline .

datatypes:coordpoly
  rdfs:label "xdd:coordinatePolygon"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:coordinatePolygon .

datatypes:dateRange
  rdfs:label "xdd:dateRange"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:dateRange .

datatypes:gYearRange
  rdfs:label "xdd:gYearRange"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:gYearRange .

datatypes:integerRange
  rdfs:label "xdd:integerRange"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:integerRange .

datatypes:decimalRange
  rdfs:label "xdd:decimalRange"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:decimalRange .

datatypes:email
  rdfs:label "xdd:email"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:email .

datatypes:html
  rdfs:label "xdd:html"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:html .

datatypes:url
  rdfs:label "xdd:url"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:url .

datatypes:anySimpleType
  rdfs:label "xsd:anySimpleType"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:anySimpleType .

datatypes:boolean
  rdfs:label "xsd:boolean"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:boolean .

datatypes:decimal
  rdfs:label "xsd:decimal"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:decimal .

datatypes:double
  rdfs:label "xsd:double"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:double .

datatypes:float
  rdfs:label "xsd:float"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:float .

datatypes:time
  rdfs:label "xsd:time"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:time .

datatypes:date
  rdfs:label "xsd:date"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:date .

datatypes:dateTime
  rdfs:label "xsd:dateTime"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:dateTime .

datatypes:dateTimeStamp
  rdfs:label "xsd:dateTimeStamp"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:dateTimeStamp .

datatypes:gYear
  rdfs:label "xsd:gYear"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:gYear .

datatypes:gYearMonth
  rdfs:label "xsd:gYearMonth"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:gYearMonth .

datatypes:gMonth
  rdfs:label "xsd:gMonth"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xsd:gMonth .

datatypes:json
  rdfs:label "xdd:JSON"@en ;
  a owl:DatatypeProperty ;
  rdfs:domain datatypes:DatatypeHolder ;
  rdfs:range xdd:json.

xdd:coordinate
  a rdfs:Datatype ;
  tcs:refines xsd:string ;
  rdfs:label "Coordinate"@en ;
  rdfs:comment "A longitude / latitude pair making up a coordinate."@en .

xdd:coordinatePolyline
  a rdfs:Datatype ;
  tcs:refines xsd:string ;
  rdfs:label "Coordinate Polyline"@en ;
  rdfs:comment "A JSON list of coordinates."@en .

xdd:coordinatePolygon
  a rdfs:Datatype ;
  rdfs:label "Coordinate Polygon"@en ;
  tcs:refines xdd:coordinatePolyline ;
  rdfs:comment "A JSON list of coordinates forming a closed polygon."@en .

xdd:range
  a rdfs:Datatype ;
  tcs:tag tcs:abstract ;
  rdfs:label "Range"@en ;
  rdfs:comment "Abstract datatype representing a value that is within a range of values. Enables uncertainty to be encoded directly in the data"@en .

xdd:dateRange
  a rdfs:Datatype ;
  rdfs:label "Date Range"@en ;
  tcs:refines xdd:range ;
  rdfs:comment "A date (YYYY-MM-DD) or an uncertain date range [YYYY-MM-DD1,YYYY-MM-DD2]. Enables uncertainty to be encoded directly in the data"@en .

xdd:gYearRange
  a rdfs:Datatype ;
  rdfs:label "Year Range"@en ;
  tcs:refines xdd:range ;
  rdfs:comment "A year (e.g. 1999) or an uncertain range of years: (e.g. [1999,2001]). Enables uncertainty to be encoded directly in the data"@en .

xdd:integerRange
  a rdfs:Datatype ;
  tcs:refines xdd:range ;
  rdfs:label "Integer Range"@en ;
  rdfs:comment "Either an integer (e.g. 30) or an uncertain range of integers [28,30]. Enables uncertainty to be encoded directly in the data"@en.

xdd:decimalRange
  a rdfs:Datatype ;
  rdfs:label "Decimal Range"@en ;
  tcs:refines xdd:range ;
  rdfs:comment "Either a decimal value (e.g. 23.34) or an uncertain range of decimal values (e.g.[23.4, 4.143]. Enables uncertainty to be encoded directly in the data"@en .

xdd:email
  a rdfs:Datatype ;
  tcs:refines xsd:string ;
  rdfs:label "Email"@en ;
  rdfs:comment "A valid email address"@en .

xdd:url
  a rdfs:Datatype ;
  tcs:refines xsd:string ;
  rdfs:label "URL"@en ;
  rdfs:comment "A valid http(s) URL"@en .

xdd:html
  a rdfs:Datatype ;
  tcs:refines xsd:string ;
  rdfs:label "HTML"@en ;
  rdfs:comment "A string with embedded HTML"@en .

xdd:json
  a rdfs:Datatype ;
  tcs:refines xsd:string ;
  rdfs:label "JSON"@en ;
  rdfs:comment "A JSON encoded string"@en .

terminus:Document
  a owl:Class ;
  rdfs:label "Document Class"@en ;
  rdfs:comment "A class used to designate the primary data objects managed by the system - relationships and entities"@en .

```
</div>
