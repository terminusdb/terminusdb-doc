---
layout: default
title: Manipulate Data
parent: Query
grand_parent: How Tos
nav_order: 2
---

# Manipulate Data
{: .no_toc }

WOQL has various ways to manipulate data, which you can do from the console query page. Since in TerminusDB all changes are append-only, this will create a new commit describing all the additions and removals your query did.

When manipulating data from the query screen, you need to specify a reason for your update in the text bar at the top of the query pane. This message will be used as the commit message.

## Inserting
```javascript
insert(a,b,c)
```

This will insert the triple `(a,b,c)`.
## Deleting
```javascript
delete(a,b,c)
```

This will delete the triple `(a,b,c)`.
