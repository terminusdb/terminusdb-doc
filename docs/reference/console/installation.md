---
title: Installation
layout: default
parent: Console
grand_parent: Reference
nav_order: 1
---
# Installation

{: .no_toc }

Here we are going to explain how to install console into your local machine. Console is dependent on the below modules as well... 

[@terminusdb/terminusdb-client](https://github.com/terminusdb/terminusdb-client)

[@terminusdb/terminusdb-react-table](https://github.com/terminusdb/terminusdb-react-table)

[@terminusdb/terminusdb-react-graph](https://github.com/terminusdb/terminusdb-react-graph)

Most likely, if you are running console locally, it's because you are a developer, and thus will be working with the `dev` branch of console. This means that you will have to point to dev branch of the above mentioned modules as well. In order to do so, simply add this line to your `.npmrc` inside your terminusdb-console folder.

`@terminusdb:registry=https://api.bintray.com/npm/terminusdb/npm-dev`

## Table of contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

- - -



## Clone from GitHub

You can clone the repository into your local machine via git clone. Follow the below steps 

* Clone the Repo
* Hop into the directory terminusdb-console
* Install all dependencies 
* Hope into console folder

```shell
git clone https://github.com/terminusdb/terminusdb-console.git
cd terminusdb-console
npm install 
cd ./console

```

In order to kick start the console, create an .env file inside console folder, where you will have to define the server end point, key and user.

`TERMINUSDB_SERVER=https://127.0.0.1:6363/
TERMINUSDB_KEY=my_key
TERMINUSDB_USER=my_user_name`

After creating your .env file, in your command line you are ready to fire the console on your browser by running the below command

```shell
npm run serve
```

This command will automatically kick start your local console in dev mode - `http://localhost:3005/`

If you also want to have local versions of the dependencies of console, such as `@terminusdb/terminusdb-client`, then you should clone those repos locally and use `npm link` to make npm use the local version.