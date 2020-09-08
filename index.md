---
layout: default
title: Home
nav_order: 1
description: "Documentation for TerminusDB - an open-source graph database that stores data like git."
permalink: /
---
<!-- ![Cowduck](/docs/assets/images/cowduck_sitting_logo.png) -->
<!-- # TerminusDB Documentation -->
{: .fs-9 }

Documentation for TerminusDB - an open-source graph database that stores data like git.
{: .fs-6 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }  [View it on GitHub](https://github.com/terminusdb/terminusdb-server){: .btn .fs-5 .mb-4 .mb-md-0 } [Visit Homepage](https://terminusdb.com){: .btn .fs-5 .mb-4 .mb-md-0 }



---

## Getting started

### Dependencies

- Docker
- Git

### Quickstart: install with docker

Get the script in the [terminusdb-bootstrap repo](https://github.com/terminusdb/terminusdb-bootstrap), cd to it

```
git clone https://github.com/terminusdb/terminusdb-bootstrap
cd terminusdb-bootstrap
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

For details, go to [bootstrap](https://github.com/terminusdb/terminusdb-bootstrap)

---

## About the project

©2020 - TerminusDB.

### License

TerminusDB is Distributed by an [GPL-3.0 license](https://github.com/terminusdb/terminusdb-server/blob/master/LICENSE)


#### Thank you to the contributors!

<ul class="list-style-none">
{% for contributor in site.github.contributors %}
  <li class="d-inline-block mr-1">
     <a href="{{ contributor.html_url }}"><img src="{{ contributor.avatar_url }}" width="32" height="32" alt="{{ contributor.login }}"/></a>
  </li>
{% endfor %}
</ul>

### Code of Conduct

TerminusDB is committed to an inclusive and welcoming community. Please follow [Berlin Code of Conduct](https://berlincodeofconduct.org/).
