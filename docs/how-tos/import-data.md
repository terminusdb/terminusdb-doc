---
layout: default
title: Import and Clean CSV Data
parent: How Tos
nav_order: 7
---

# Import and Clean Data
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## CSV

CSV files can be loaded directly into TerminusDB either from a URL or from a file on your local server using the get() operation.

### Loading CSVs from files and URLs

#### Loading CSV From a URL

```javascript
get(....).remote("http://seshatdatabank.info/wp-content/uploads/2020/01/Iron-Updated.csv")

```
#### Loading CSV From a file

```javascript
get(....).file("/app/local_files/Iron-Updated.csv")
```

### Mapping Columns to Variables

In order to address data in the CSV you need to map each column of interest in the CSV to a TerminusDB variable using the as() operation

There are two different ways in which we can map CSV columns - by column header or by column number

If we take the following `roster.csv` CSV for instance:

```csv
Name,Registration_Date,Paid
George,2017-01-02,Yes
Willie,2017-01-02,No
```

#### Mapping Columns by Name (Column Header)

We can map the 3 colums in the CSV to TerminusDB Variables, by using the column header text :

```javascript
get(as("Name","v:Name")
   .as("Date", "v:Date")
   .as("Paid", "v:Paid")).file('/app/local_files/roster.csv')
```

The first argument of the `as` is the column header name, the second
is the name of the TerminusDB variable which will be populated with the data in the column.

We do not need to map all columns, only those we are interested in. So, for example, if we are only interested in the Date and Name fields, we can write: 

```javascript
get(as("Name","v:Name")
   .as("Date", "v:Date")).file('/app/local_files/roster.csv')
```

#### Mapping Columns by Number

The second form of the as operator allows us to map columns by column number (indexed from 0). For example, the equivalent of the 3 column import from above would be: 

```javascript 
get(as(0, "v:Name")
.as(1, "v:Date")
.as(2, "v:Paid)).file('/app/local_files/roster.csv')
```

This will map the first 3 columns to the same 3 variables - having exactly the same effect as the above example

#### CSVs without headers

By default, TerminusDB assumes that the first line of a CSV contains headers for the columns. In some cases we may just have data, with no column headers.  To deal with this situation, we set format_header to be false in the file or remote operation

```javascript 
get(...).remote("http://seshatdatabank.info/wp-content/uploads/2020/01/Iron-Updated.csv", {format_header: false})
get(...).file('/app/local_files/roster.csv', {format_header: false})
```

The first line will be interpreted as data, not headers, and the columns can be mapped to variables by number

### Maninpulating CSV data

Once CSV data has been mapped to TerminusDB variables, they can be used in queries just like native variables: 

```javascript
and(
        get(as("Name","v:Name")
           .as("Date", "v:Date")
           .as("Paid", "v:Paid")).file('/app/local_files/roster.csv'),
        triple("v:EntryID", "scm:name", "v:Name")
)
```
This will find all entries in the exiting database which have the same name (scm:name) as the variable (v:Name) which contains the imported data from the CSV

### Typecasting

Every CSV datapoint is imported by default as a string. It is often useful to cast these strings to a better type to represent it. So, for example, in the above example, we probably want to treat "v:Date" as an actual date. The typecast() operation can be applied to imported CSV variables to make them treated as if they were another type than a string:

```javascript
and(
        get(as("Name","v:Name")
           .as("Date", "v:Date")
           .as("Paid", "v:Paid")).file('/app/local_files/roster.csv'),
        typecast("v:Date", "xsd:date", "v:RealDate")
           .less("v:RealDate", "2010-01-01")
)
```
The above example will cause the date comparison operator to work correctly because the "v:RealDate" variable has been typecast to the correct type. 

### Type mapping

In cases where there are no automatic typecasting operation available, we can still manually manipulate the CSV data to map it to the correct type: 

```javascript
and(
        get(as("Name","v:Name")
           .as("Date", "v:Date")
           .as("Paid", "v:Paid")).file('/app/local_files/roster.csv'),
        eq("v:Paid", "Yes").eq("v:PaidBoolean", literal(true, "boolean"))
        eq("v:Paid", "No").eq("v:PaidBoolean", literal(false, "boolean"))
)
```
In the above case we have constructed a new variable of the desired type (v:PaidBoolean) and mapped Yes to true and No to false, creating the boolean variable that we want. 

### Combining data from multiple columns

It is often the case that we want to combine data from multiple columns into a single variable. For example, consider the following CSV example: 

```csv
First Name,Last Name
George,Smith
Willie,Nelson
```
If we want to combine the two CSV column into a single variable to represent the full name of the individuals, we can do so as follows:

```javascript
and(
        get(
            as("First Name","v:First")
           .as("Last Name", "v:Last")
        ).file('/app/local_files/roster.csv'),
        concat("v:First v:Last", "v:Full")
)
```

In the above example the variable "v:Full" will have the full name, assembled from the first name and last name with a space in between. 

### Extracting Data From Columns with regular expressions

Sometimes, the data in the CSV needs to be significantly transformed from the input format. For example, we might want to extract patterns from multiple columns, or extract a substring from a particular column. In such cases regular expressions provide a great degree of flexibility in extracting the precise information that we want. For example, if we have a CSV with the following structure:

```csv
Full Name,Date of Birth
George Smith, 08/10/1970
Willie Nelson, 09/05/1963
```

In this example, if we wish to extract the first name and last name to independent variables, a regular expression does the trick:

```javascript
and(
        get(
            as("Full Name","v:Full")
        ).file('/app/local_files/roster.csv'),
        re(" [^ ]*$", "v:Full Name", ["v:Last Name", "v:All"]),
        re("$[^ ]*$", "v:Full Name", ["v:First Name", "v:All"])
)
```

### Inserting Data From CSVs

#### Generating IDs

We want to construct an URI identifier which carries a unique
representation of the record from the roster. We can do this with
`idgen` which will create a valid id from the *key* for us.


#### Writing Data


The final `add_triple` simply adds the information for this property
to the database.
