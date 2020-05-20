---
layout: default
title: Chooser View
parent: Visualisation
grand_parent: User guide
nav_order: 2
---

# Chooser View



This section covers all of the rules which can be applied to a chooser view. As mentioned in previous section a chooser view can be defined as shown below:

```js
view = View.chooser()   
```

All other rules are accessible as chaining functions of variable view.


1) ###### show_empty

Takes a string as argument and displays this as placeholder on load of chooser when nothing hasm been chosen yet.

```js
view.chooser().show_empty("Select Something")  
```

2) ###### sort

Allows to select a result and sort it in any direction.

```js
view.sort('c')
```

3) ###### direction

Specifies the direction in which chooser value needs to be sorted (asc or desc)

```js
view.sort('c').direction('asc')
```

4) ###### values

Displays the values of chooser of whatever you want to display

```js
view.values('v:Names') // displays the values of v:Name
```
5) ###### labels

Displays labels of results as values in drop down of chooser

```js
view.labels("v:Label")
```

6) ###### changeSize

Allows to change table page size  

```js
view.changeSize(true)
```

7) ###### pager

on set to true allows pagination

```js
view.pager(true)
```

8) ###### pagesize

Defines minimum page size of a table

```js
view.pagesize(10) // displays only 10 rows per page
```
