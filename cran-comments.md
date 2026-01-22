## R CMD check results

R-CMD-check passed under these configurations :

* ubuntu-latest, R-devel, R-release, R-oldrel
* ubuntu-22.04, R-release
* macOS-latest, R-release
* Windows-latest, R-release

GitHub Actions [results](https://github.com/MiboraMinima/stdbscan/actions/workflows/R-CMD-check.yaml).

## Notes to CRAN maintainers

- On Ubuntu, GCC 13 produces a benign C++ compiler warning during package
installation. To avoid spurious warnings in continuous integration, the GitHub
Actions workflow uses GCC 12 for Ubuntu with R-release and R-oldrel, and GCC 14
for Ubuntu with R-devel.
- This package is a response to propositions made
[here](https://github.com/mlr-org/mlr3cluster/issues/83) and
[here](https://github.com/mhahsler/dbscan/issues/83).
