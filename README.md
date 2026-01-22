# stdbscan<img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test coverage](https://codecov.io/gh/MiboraMinima/stdbscan/graph/badge.svg)](https://app.codecov.io/gh/MiboraMinima/stdbscan)
[![R-CMD-check](https://github.com/MiboraMinima/stdbscan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MiboraMinima/stdbscan/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

`stdbscan` provide a function for the ST-DBSCAN (**S**patio-**T**emporal DBSCAN)
algorithm developped by Birant & Kut (2007). It extends DBSCAN by adding a
temporal parameter that allows spatio-temporal clustering.

The function is implemented in C++ via [`Rcpp`](https://www.rcpp.org/) for
performance.

## Installation

The package will be available on CRAN. Once released, install with:

```r
install.packages("stdbscan")
```

In the meantime, you can install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("MiboraMinima/stdbscan")
```

## Usage

An example of the application of `stdbscan` is available in the
[vignette](https://miboraminima.github.io/stdbscan/articles/stop-identification.html)
on stop identification.

## Problems and Issues

- Please report any issues or bugs you may encounter on the [dedicated
  page on github](https://github.com/paul-carteron/happign/issues).

## System Requirements

`stdbscan` requires [`R`](https://cran.r-project.org) v \>= 3.5.0.

## Alternatives

`R` :

- [ST-DBSCAN](https://github.com/CKerouanton/ST-DBSCAN)
- [stdbscanr](https://github.com/gdmcdonald/stdbscanr)

`python` :

- [st_dbscan](https://github.com/eren-ck/st_dbscan)
- [py-st-dbscan](https://github.com/eubr-bigsea/py-st-dbscan)

## References

Birant, D., & Kut, A. (2007). ST-DBSCAN: An algorithm for clustering
spatial–temporal data. *Data & Knowledge Engineering*, 60(1), 208–221.
<https://doi.org/10.1016/j.datak.2006.01.013>
