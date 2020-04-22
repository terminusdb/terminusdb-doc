---
layout: default
title: Graph View
parent: Visualisation
nav_order: 2
---

# Code
Graph View

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

This section covers all of the rules which can be applied to a graph view. As mentioned in previous section a graph view can be defined as shown below:

```js
view = View.graph()   
```


1) Width

Allows you to set the width of graph component. The argument value is considered as pixels.

```js
view.graph().width(100)  
```

2) Height

Allows you to set the height of graph component. The argument value is considered as pixels.

```js
view.graph().width(100).height(50)
```

3) show_force

Provides a Gravitational view over the graph component. If set to false the graoh would simply appear rather than the floating effect.

```js
view.graph().width(100).show_force(true)
```
4) source

Alters the graph's view by treating the element mentioned in argument as the graph's source

```js
view.graph().source("v:A")
```

5) color

You can set color for graph's nodes in rgb format.

```js
view.graph().node("v:A").color([233, 54, 65])
```

5) fontfamily

Helps you to load icon families. By default Font Awesome is used here.

```js
view.graph().fontfamily('font')
```

6) edges

Alters the direction of edges pointing, based on values provided as arguments

```js
view.graph().edges(["v:B","v:A"])   
```
