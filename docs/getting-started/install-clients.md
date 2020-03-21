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
$ npm install --save @terminusdb/terminus-client
```

#### Minified Script

Using cdn:

```html
<script src="https://unpkg.com/@terminusdb/terminus-client/dist/terminus-client.min.js"></script>
```
Downloading:

Download the terminus-client.min.js file from the /dist directory and save it to your location of choice, then:
```html
<script src="http://my.saved.location/terminus-client.min.js"></script>
```

---

## Python Client

### Requirements
* TerminusDB
* Python >= 3.6

### Installation

Terminus Client Python can be download form PyPI using pip:
```
python -m pip install terminus-client-python
```
this only include the core Python Client and WOQLQuery.

If you want to use woqlDataframe:
```
python -m pip install terminus-client-python[dataframe]
```

Install from source:
```
python -m pip install git+https://github.com/terminusdb/terminus-client-python.git
```
