---
layout: default
title: Store
parent: Server
grand_parent: Reference
nav_order: 5
---

## Store
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

In a TerminusDB installation, data is stored under the storage/db directory. This section contains a reference of the files that are found there, and what purpose they serve.

For a better idea of how this actually works, please check out the [whitepaper](https://github.com/terminusdb/terminusdb-server/raw/master/docs/terminushub/whitepaper/terminusdb.pdf). For the documentation of the underlying rust storage library, check out the [terminusdb-store library documentation](https://docs.rs/crate/terminus-store/).

## Layers
TerminusDB is an append-only database. This means that when you delete some triples, these triples aren't actually deleted from disk. Instead, all changes are stored as a layer.

Layers have a 160 bit id that is used to refer to them. On disk, layers are stored in a directory under this id, represented as a 40 character hexadecimal number. These directories are further grouped into directories named after the first 3 characters of this hexadecimal number. For example, if there is a layer with id '0123456789abcdef0123456789abcdef01234567', it can be found in the directory 'storage/db/012/0123456789abcdef0123456789abcdef01234567'.

A layer directory contains a set of files to represent this layer. The set of files depends on whether this is a base layer or a child layer. A base layer has no parent, and only has triple additions. All triple data structures will be prefixed with `base_`. A child layer does have a parent (referred to in 'parent.hex'), and contains both triple additions (files prefixed with `pos_`) and triple removals (files prefixed with `neg_`). In addition, child layers store a list of all subjects and objects added and removed in that layer, meaning, if any triple was added with a particular subject, that subject will be stored in the `child_pos_subject.logarray` file, and similarly for `child_neg_subject.logarray`, `child_pos_object.logarray` and `child_neg_object.logarray`.

All data files mentioned so far refer to nodes, predicates and values with a numerical id. Layers also contain dictionary files to translate from a string representation of a node, predicate or value, to a numerical id and back. These files are the same for base and child layers. All node dictionary files are prefixed with `node_dictionary_`, all predicate dictionary files are prefixed with `predicate_dictionary_` and all value dictionary files are prefixed with `value_dictionary_`. Unlike triples, dictionary entries are never removed, so these files always describe additions to the dictionary.

Each file has an extension describing what kind of data structure it is. There are 4 file extensions:
- .pfc files are plain front coding dictionary files.
- .logarray files are compressed arrays of numbers.
- .bitarray files are arrays of bits.
- .hex files contain a hexadecimal number.

## Labels

Labels are used to track changes to named graphs. They link a name to a particular layer id. Labels can be updated to point them at another layer, which is how all updates in the system are done.

Labels are stored in files with the `.label` file extension. All these files can be found directly in the `storage/db` directory.

Label files contain two lines of data:
- an update number, saying how often this file was updated
- a layer id

A freshly initialized terminusdb-server will already contain some label files. Most of these describe schemas for various internal graphs:
- `http%3a%2f%2fterminusdb.com%2fschema%2flayer.label`: layer schema (a schema used in any graph that refers to terminusdb layers, namely the commit graph and the repository metadata graph).
- `http%3a%2f%2fterminusdb.com%2fschema%2fref.label`: commit graph schema.
- `http%3a%2f%2fterminusdb.com%2fschema%2frepository.label`: repository metadata schema.
- `terminusdb%3a%2f%2f%2fsystem%2fschema.label`: system graph schema.

Additionally, there's one so-called inference graph here: `terminusdb%3a%2f%2f%2fsystem%2finference.label`. This label points at a graph describing inference rules for the system graph. Inference rules are currently an undocumented feature of TerminusDB, which is nevertheless used in some internal graphs.

Finally, there's a label for the system graph: `terminusdb%3a%2f%2f%2fsystem%2fdata.label`. The system graph contains information about all users, organizations and databases in the system.

For every created database, an additional label file will be created. This file will be named `{organization}%7c{dbname}.label` (`%7c` is the url-encoded version of the pipe character `|`). This label will point at the repository metadata graph for that database. This graph itself internally points at commit graphs, which themselves in turn point at data graphs.

## Version information

The `storage/db` directory contains one final file: SERVER_VERSION. This file contains a version number, which terminusdb-server uses to keep track of the storage version. This number will be raised any time a backwards-incompatible change is made. If this number does not match what the server expects, the server will refuse to start.
