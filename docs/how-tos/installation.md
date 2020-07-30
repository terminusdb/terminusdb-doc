---
layout: default
title: Installation
parent: How Tos
nav_order: 1
---

# Installation
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Prerequisites

### Docker

Since this script uses the TerminusDB Docker container, you need to have Docker running.

On Windows and Mac, Docker Desktop can be [downloaded here](https://www.docker.com/products/docker-desktop)

On Linux, use your distro's package manager, or find [more information here](https://www.docker.com/products/container-runtime)

### Git

This script is distributed via GitHub, so you will need git to clone and update it, if you don't already have git, you can [download it here](https://git-scm.com/downloads)

Windows users should use the application "Git Bash" for all terminal commands described below, this application comes with Git for Windows.

### Sudo

Sudo is optional. As letting unprivileged users run docker is insecure, this script uses sudo by default if it is available.

Most users will not need to do anything here, sudo is installed by default on Macs and many populer Linux distros such as Fedora, Red Hat, Debian, Ubuntu and Mint. Linux users who use minmal distros such as Archlinux, are advised to install sudo and confugure their sudoers file accordingly.

Windows users do not need to do anything here.

---

## Quick Start

Get the script in the [terminusdb-quickstart repo](https://github.com/terminusdb/terminusdb-quickstart), cd to it

```
git clone https://github.com/terminusdb/terminusdb-quickstart
cd terminusdb-quickstart
```

Run the container (the first time)

```
./terminusdb-container run
Unable to find image 'terminusdb/terminusdb-server:latest' locally
latest: Pulling from terminusdb/terminusdb-server
8f91359f1fff: Pulling fs layer
939634dec138: Pulling fs layer
f30474226dd6: Pulling fs layer
32a63113e3ae: Pulling fs layer
ae35de9092ce: Pulling fs layer
023c02983955: Pulling fs layer
d9fa4a1acf93: Pulling fs layer
[ ... ]
```

---

## If you've installed before

You may need to move or remove previous volumes or you may encounter bugs or the old console.

*Warning: This will lead to losing local data.*

```
 ./terminusdb-container rm

removing will delete storage and config volumes
Are you sure? [y/N] y
```

---

## Using the console

Ready to terminate? Open the TerminusDB Console in your web browser.
```
./terminusdb-container console
```
Or go here: [http://localhost:6363/](http://localhost:6363/)

---

## To stop, attach, etc, see usage

```
./terminusdb-container

USAGE:
  terminusdb-container [COMMAND]

  help        show usage
  run         run container
  stop        stop container
  console     launch console in web browser
  attach      attach to prolog shell
  stats       show container stats
  rm-config   remove config volume
  rm-storage  remove storage volume
  rm          remove volumes
```

That's it! You're ready to go!

---

## Using the Enviroment

* Mount a local directory inside the container
```
TERMINUSDB_LOCAL=/path/to/dir ./terminusdb-container [COMMAND]
```
* Using the latest release
```
TERMINUSDB_TAG=latest ./terminusdb-container [COMMAND]
```
* Using the development release
```
TERMINUSDB_TAG=dev ./terminusdb-container [COMMAND]
```
* Using a specific release instead of latest realease
```
TERMINUSDB_TAG=v1.1.2 ./terminusdb-container [COMMAND]
```
* Not using sudo even when sudo is available
```
TERMINUSDB_DOCKER=docker ./terminusdb-container [COMMAND]
```
* Using podman instead of docker command
```
TERMINUSDB_DOCKER="podman" ./terminusdb-container [COMMAND]
```

See the source code to find the other environment variables that can be set.
