---
layout: default
title: Administration
nav_order: 5
---

1. TOC
{:toc}

# Deployment options

Currently, terminus-quickstart is the supported distribution of TerminusDB. To find out about all
the options, check out the README on GitHub. https://github.com/terminusdb/terminusdb-quickstart/blob/master/README.md

# Backup / restore

Backing up is as simple as pushing your data to a remote on TerminusHub. You can run TerminusDB on a different
machine as well and use it as a backup remote.

Restoring the database can be done by pulling from the remote.

# Security

* Always change the default password!
* If you want to host your instance of TerminusDB, put it behind a reverse proxy with HTTPS
