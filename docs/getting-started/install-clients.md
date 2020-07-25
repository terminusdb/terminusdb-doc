---
layout: default
title: Installation of JS/ Python Clients
parent: Getting started
nav_order: 3
---

# Installation of JS/ Python Clients
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Javascript Client

### Requirements

* TerminusDB
* [NodeJS 8.1.4+](https://nodejs.org/en/)


### Installation

Terminus Client can be used as either a Node.js module available through the npm registry, or directly included in web-sites by including the script tag below.

#### NPM Module

Before installing, download and install Node.js. Node.js 0.10 or higher is required.

Installation is done using the npm install command:

Using npm:

```
$ npm install --save @terminusdb/terminusdb-client
```

#### Minified Script

Using cdn:

```html
<script src="https://unpkg.com/@terminusdb/terminusdb-client/dist/terminusdb-client.min.js"></script>
```
Downloading:

Download the terminusdb-client.min.js file from the /dist directory and save it to your location of choice, then:
```html
<script src="http://my.saved.location/terminusdb-client.min.js"></script>
```

[JavaScript Client Documentaiton](https://terminusdb.github.io/terminusdb-client/){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }

---

## Python Client

**Note that this Python Client works with TerminusDB v1.0. Python Client for new version coming soon.**

### Requirements
* TerminusDB
* Python >= 3.6

### Installation

Terminus Client Python can be download form PyPI using pip:
```
python -m pip install terminusdb-client
```
this only include the core Python Client and WOQLQuery.

If you want to use woqlDataframe:
```
python -m pip install terminusdb-client[dataframe]
```

*if you are installing form zsh you have to quote the argument like this:*
```
python -m pip install 'terminusdb-client[dataframe]'
```

Install from source:
```
python -m pip install git+https://github.com/terminusdb/terminusdb-client-python.git
```

[Python Client Documentation](https://terminusdb.github.io/terminusdb-client-python/){: .btn .fs-5 .mb-4 .mb-md-0 }
