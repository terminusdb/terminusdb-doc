---
layout: default
title: Table View
parent: Visualisation
grand_parent: User guide
nav_order: 2
---

# Table View

This section covers all of the rules which can be applied to a table view. As mentioned in previous section a table view can be defined as shown below:

```js
view = View.table()   
```
######   All other rules are accessible as chaining functions of variable view.
---

1)   column_order

column_order helps to arrange columns based on whatever order is specified, columns are accesed by header names. This function also hides column names which are not mentioned as arguments in the function

```js
view.table().column_order("c", "b", "d")  
```

2)   column

You can refer to a column using its header name

```js
view.column('c')
```

3)   header

Renames a particular column to another name

```js
view.column('c').header('New Name')
```

4)   header

Renames a particular column to another name

```js
view.column('c').header('New Name')
```
5)   pager

on set to true allows paging in table  

```js
view.pager(true)
```

5)   changeSize

Allows to change table page size  

```js
view.changeSize(true)
```

5)   pager

on set to true allows pagination

```js
view.pager(true)
```

6)   pageSize

Defines minimum page size of a table

```js
view.pagesize(10) // displays only 10 rows per page
```
