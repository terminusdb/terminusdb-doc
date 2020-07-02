---
title: Installation
layout: default
parent: Console
grand_parent: Reference
nav_order: 1
---
# Installation

{: .no_toc }

Here we are going to explain how to 

## Table of contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

- - -

## Install from bintray

content of section 1

## Clone from GitHub

You can clone the repository into your local machine via git clone and run console locally.

```shell
git clone https://github.com/terminusdb/terminusdb-console.git
```



After cloning the Repository using the above code, hop into the directory terminusdb-console via your command line

`cd terminusdb-console`

Then install all dependencies via an npm install

`npm install `

In order to kick start the console, create an .env file under terminusdb-console/console where you will have to define the server, key and user.

`TERMINUSDB_SERVER=http://127.0.0.1:6363/
TERMINUSDB_KEY=root
TERMINUSDB_USER=admin`

After creating your .env file, in your command line you are ready to fire the console on your browser by running the below command

`npm run serve`

By running `npm run serve`, this command will automatically kick start your local console in dev mode - `http://localhost:3005/`

If you also want to have local versions of the dependencies of console, such as `@terminusdb/terminusdb-client`, then you should clone those repos locally and use `npm link` to make npm use the local version.

Use `npmlink` if you want to use local packages, or set `.npmrc` if you want to use our
dev packages.