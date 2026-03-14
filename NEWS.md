# stdbscan 0.2.0

## Changes

* `st_dbscan()` now uses `dbscan` hunder the hood.

## New features

* Add a fonction for prediction `predict(<stdbcsan>)`.
* Add a fonction to check if points are corepoints `st_dbscan_corepoint()`.
* Add a class (`stdbscan`) for the clustering object based on the `dbscan` class.

## Breaking changes

* Input is now a `matrix` (`x`, `y` and `t`) like in `dbscan::dbscan()`

# stdbscan 0.1.0

* Initial CRAN submission.
