# stdbscan

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test coverage](https://codecov.io/gh/MiboraMinima/stdbscan/graph/badge.svg)](https://app.codecov.io/gh/MiboraMinima/stdbscan)
<!-- badges: end -->

## Overview

`stdbscan` provide a function for the ST-DBSCAN (**S**patio-**T**emporal DBSCAN)
algorithm developped by Birant & Kut (2007). It extends DBSCAN by adding a
temporal parameter that allows spatio-temporal clustering.

The function is implemented in C++ via [`Rcpp`](https://www.rcpp.org/) for
performance.

## Installation

You can install the development version of `stdbscan` from github with :

```r
# install.packages("devtools")
devtools::install_github("MiboraMinima/stdbscan")
```

## Problems and Issues

- Please report any issues or bugs you may encounter on the [dedicated
  page on github](https://github.com/paul-carteron/happign/issues).

## System Requirements

`stdbscan` requires [`R`](https://cran.r-project.org) v \>= 3.5.0.

## Alternatives

- [ST-DBSCAN](https://github.com/CKerouanton/ST-DBSCAN)
- [stdbscanr](https://github.com/gdmcdonald/stdbscanr)

