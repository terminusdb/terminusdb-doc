---
layout: default
title: Administration
nav_order: 5
---

1. TOC
{:toc}

# Deployment options

The recommend way of running TerminusDB is to use terminusdb-quickstart.

To use terminusdb-quickstart you need to have Git and Docker installed, then
you can clone the terminusdb-quickstart repo and run the server by following
the instructions in the README.md on GitHub:

(https://github.com/terminusdb/terminusdb-quickstart/blob/master/README.md)

Experienced users can use the Docker container in their own configuration, or
compile from source code.

The TerminusDB Docker container is available on Docker Hub:

https://hub.docker.com/r/terminusdb/terminusdb-server

Source code and compilation instructions can be found in the terminusdb/terminusdb-server repo on github:

https://github.com/terminusdb/terminusdb-server


# Backup / restore

Backing up is as simple as pushing your data to a remote on TerminusHub. You can run TerminusDB on a different
machine as well and use it as a backup remote.

Restoring the database can be done by pulling from the remote.

Users of Docker or terminusdb-quickstart will be able to backup there data by backing their Docker volumes.


# Security

* Always change the default password!
* If you want to host your instance of TerminusDB, put it behind a reverse proxy with HTTPS
