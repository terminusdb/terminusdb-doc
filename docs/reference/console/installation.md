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

You can clone the repo into your local machine via git clone

```shell
git clone https://github.com/terminusdb/terminusdb-console.git
```



If you also want to have local versions of the dependencies of console, such as `@terminusdb/terminusdb-client`, then you should clone those repos locally and use `npm link` to make npm use the local version.

**Do not edit `package.json` or the webpack config with file paths** Use `npm
link` if you want to use local packages, or set `.npmrc` if you want to use our
dev packages.

etc