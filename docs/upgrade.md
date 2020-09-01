---
title: Upgrade
layout: default
nav_order: 8
---
# Upgrade from older versions
{: .no_toc }

1. TOC
   {:toc}

- - -

The current version of terminusdb is 3.0. Currently, there is no way
to automatically upgrade to 3.0. We intend to release a migration tool
with our next minor release.

## Manual upgrade
If you currently have a 2.x instance and wish to migrate your data,
you can attempt to do so manually.

Starting from version 3.0, the primary branch of a database is no
longer called 'master', but is instead called 'main'. This means that,
upon starting 3.0 with an old 2.x store, none of your databases will
have a primary branch anymore, which may result in unexpected
behavior.

You can resolve this issue for individual databases by manually
creating the 'main' branch by branching off 'master'. Having done so,
your database once again has a primary branch, and no unexpected
behavior should occur.

## Assistance
Maybe you're unsure about doing the manual upgrade, but do not wish to
wait for the next minor release for the automatic upgrade path. If
that is the case, do not hesitate to get in touch with us! You can
reach us on our community forum and on our discord server. You can
find out more on our [community page](Instructions for joining).
