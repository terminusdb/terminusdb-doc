---
layout: default
title: Other ways of installing TerminusDB
parent: How Tos
nav_order: 2
---

# Other ways of installing TerminusDB
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Linux

This page covers the process of manually building TerminusDB on various
Linux distributions.

### Debian or Ubuntu

The following directions should work on Debian or Ubuntu.

#### Rust

Install Rust by following the following instructions on the [official
Rust installation guide](https://www.rust-lang.org/tools/install).

#### SWIPL

To use Terminus Server, you will need the SWIPL installation of
Prolog. To install this in Debian variants simply use the apt package
manager:

```
apt install swi-prolog
```
Once installed, you will have to install two library dependencies from SWIPL.

This can be done by typing:

```
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.1.10-28-g8a26a53c1)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

1 ?- pack_install(terminus_store_prolog).
% Contacting server ....
```

#### Terminus Server

The Terminus Server source tree should then be cloned from GitHub:

```
git clone https://github.com/terminusdb/terminusdb-server
cd terminusdb-server
```

You need to set the admin user password which is used as a
super-user API key for access. This can be done with the
`db_init` script. The script should also be used to
configure the server name, as shown in the example.

```
utils/db_init -k "my_password_here" -s "my_server_name_here"
```

At this point you can enter the terminusDB directory and start the server:

```
./start.pl
```

Now you are ready to interact with the HTTP server.

### Fedora or Red Hat

These instructions have been tested on Fedora 30 and might result in different results depending on your
Fedora / Red Hat release.


#### Rust

Install Rust by following the following instructions on the [official
Rust installation guide](https://www.rust-lang.org/tools/install).

#### SWIPL

SWI-Prolog is needed to run terminusdb-server. Install SWI-PROLOG with:

```
sudo dnf install pl pl-devel
```

#### SWIPL libraries

Run SWIPL and install the required dependencies, note that you need to have
rust installed to compile the dependencies:

```
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.1.10-28-g8a26a53c1)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

1 ?- pack_install(terminus_store_prolog).
% Contacting server ....
```


#### Terminus Server

The Terminus Server source tree should then be cloned from GitHub:

```
git clone https://github.com/terminusdb/terminusdb-server
cd terminusdb-server
```

You need to set the admin user password which is used as a
super-user API key for access. This can be done with the
`db_init` script. The script should also be used to
configure the server name, as shown in the example.

```
utils/db_init -k "my_password_here" -s "my_server_name_here"
```

At this point you can enter the terminusDB directory and start the server:

```
./start.pl
```

Now you are ready to interact with the HTTP server.


### Arch Linux


#### Rust

Install Rust by following the following instructions on the [official
Rust installation guide](https://www.rust-lang.org/tools/install).

#### Library dependencies

1. Install all dependencies of all the required libraries:

```
sudo pacman -S git swi-prolog make automake autoconf libtool zlib pkgconf gcc
```

#### SWIPL libraries

Run SWIPL and install the required dependencies, note that you need to have
rust installed to compile the dependencies:

```
$ swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.1.10-28-g8a26a53c1)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

1 ?- pack_install(terminus_store_prolog).
% Contacting server ....
```


#### Terminus Server

The Terminus Server source tree should then be cloned from GitHub:

```
git clone https://github.com/terminusdb/terminusdb-server
cd terminusdb-server
```

You need to set the admin user password which is used as a
super-user API key for access. This can be done with the
`db_init` script. The script should also be used to
configure the server name, as shown in the example.

```
utils/db_init -k "my_password_here" -s "my_server_name_here"
```

At this point you can enter the terminusDB directory and start the server:

```
./start.pl
```

Now you are ready to interact with the HTTP server.
