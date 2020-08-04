---
layout: default
title: Schema Query
parent: Query
grand_parent: User guide
nav_order: 3
---

# Schema Query
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


# Creating Schema

Schema can be constructed by creating `doctype` followed by its `property` (if any). Each of them can have its own `label` and `discription`. For example in WOQLjs:

```js
WOQL.and(
    WOQL.doctype("Station")
        .label("Bike Station")
        .description("A station where bicycles are deposited"),
    WOQL.doctype("Bicycle")
        .label("Bicycle"),
    WOQL.doctype("Journey")
        .label("Journey")
        .property("start_station", "Station")
            .label("Start Station")
        .property("end_station", "Station")
            .label("End Station")
        .property("duration", "integer")
            .label("Journey Duration")
        .property("start_time", "dateTime")
            .label("Time Started")
        .property("end_time", "dateTime")
            .label("Time Ended")
        .property("journey_bicycle", "Bicycle")
            .label("Bicycle Used")
)
```

### Document objects

The executable queries can be constructed with the help of the WOQL query objects. Usually the document objects with labels and descriptions can be easily constructed with a chain of call like:

``` js
WOQL.doctype("Station")
    .label("Bike Station")
    .description("A station where bicycles are deposited")
```

However, labels and descriptions are optional. The minimum way of creating a document object would be `WOQL.doctype("idOfObj")`.

### Properties

Properties can also be chained to the document objects in WOQLjs and WOQLpy, for example in WOQLjs:

``` js
WOQL.doctype("Journey")
    .label("Journey")
    .property("start_station", "Station")
        .label("Start Station")
```

Properties will take an extra argument for the range of the property - it could be a datatype e.g. dateTime, string, integer, double, etc; or an other document object. A label and descriptions can also be added to properties in similar manner as doctype objects.

### Subclases

To created a subclass structure in TerminusDB graph,`add_quad` can be used. For example:

``` js
WOQL.add_quad("child", "subClassOf", "parent", "schema")
```

For details regarding WOQL query objects in API clients, please refer to [API Reference](/docs/api-reference/).

---
