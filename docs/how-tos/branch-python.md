---
layout: default
title: Create and Merge Branches in Python
parent: How Tos
nav_order: 7
---

# Create and Merge Branches
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Branch

First, we need to connect to our TerminusDB server and an existing database.

```
server_url = "https://127.0.0.1:6363"
db = "My_DB"
user = "admin"
account = "admin"
key = "root"
repository = "local"
client = WOQLClient(server_url)
client.connect(user=user, account=account, key=key, db=db)
```

If we want to branch from the current head on branch main, all that is
required is to execute the following:

```
client.branch('new_branch')
```

If we instead want to branch from a different branch head (which must
already exist) we can do the following:

```
client.checkout('other_branch')
client.branch('new_branch')
```
Branching does not move you to the new branch! You need to do that manually with `checkout`. For instance:

```
client.checkout('new_branch')
```

## Merging (rebase) branches

Once we have two branches, we can rebase one into the other. This will
leave us with a branch that has all of the data from both branches.

If we want to rebase `new_branch` on top of `other_branch`, we can do
the following:


```
client.checkout('other_branch')
branch = 'new_branch'
client.rebase({"rebase_from": f'{user}/{db}/{repository}/branch/{branch}',
               "author": user,
               "message": f"Merging {branch} into other_branch"})
```

And then you should have all of the content from `old_branch` present
in `new_branch`!
