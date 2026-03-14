#' Spatio-Temporal DBSCAN
#'
#' @description
#' Perform **ST-DBSCAN** clustering on points with spatial and temporal
#' coordinates. This algorithm identifies clusters of points that are close both
#' in space and time.
#'
#' @param data matrix. A matrix containing, **in that order**, `x`, `y` and
#' `t`. `x` (longitude) and `y` (latitude) are the spatial coordinates and `t`
#' is the cumulative time since a common origin (*e.g.* `c(0, 6, 10)`). `t`
#' must be sorted.
#' @param eps_spatial Numeric. The spatial radius threshold. Points closer than
#' this in space may belong to the same cluster.
#' @param eps_temporal Numeric. The temporal threshold. Points closer than this
#' in time may belong to the same cluster.
#' @param min_pts Integer. Minimum number of points required to form a core
#' point.
#' @param ... Additional arguments are passed on to `dbscan::frNN()` and
#' `dbscan::dbscan()`.
#'
#' @return
#' `st_dbscan()` returns an object of class `stdbscan` with the following
#' components:
#'
#' \item{cluster }{Integer vector with cluster assignments. Zero indicates
#' noise points.}
#' \item{eps }{Value of the `eps_spatial` parameter.}
#' \item{minPts }{Value of the `minPts` parameter.}
#' \item{metric }{Used distance metric.}
#' \item{boderPoints }{Whether border points are considered as noise (`FALSE`) or not (`TRUE`).}
#' \item{eps_temporal }{Value of the `eps_temporal` parameter.}
#'
#' This class is a simple extension of the `dbscan` class. For more details,
#' see \code{\link[dbscan:dbscan]{dbscan}} documentation.
#'
#' @details
#' ST-DBSCAN extends classical DBSCAN by incorporating a temporal constraint.
#' Two points are considered neighbors if they are within `eps_spatial` in
#' space **and** within `eps_temporal` in time. Clusters are expanded from core
#' points recursively following the DBSCAN algorithm.
#'
#' ST-DBSCAN is implemented using the following approach :
#'
#' \enumerate{
#'   \item Find the spatial neighbors using Fixed Radius Nearest Neighbors
#'   (`dbscan::frNN()`)
#'   \item Filter the spatial neighbors by the temporal constraint
#'   \item Apply DBSCAN on the filtered neighbors using `dbscan::dbscan()`
#' }
#'
#' @references
#' Birant, D., & Kut, A. (2007). ST-DBSCAN: An algorithm for clustering
#' spatial–temporal data. Data & Knowledge Engineering, 60(1), 208–221.
#' https://doi.org/10.1016/j.datak.2006.01.013
#'
#' @importFrom dbscan frNN
#' @importFrom dbscan dbscan
#'
#' @examples
#' data(geolife_traj)
#'
#' geolife_traj$date_time <- as.POSIXct(
#'   paste(geolife_traj$date, geolife_traj$time),
#'   format = "%Y-%m-%d %H:%M:%S",
#'   tz = "GMT"
#' )
#' geolife_traj$t <- as.numeric(
#'   geolife_traj$date_time - min(geolife_traj$date_time)
#' )
#' data <- cbind(geolife_traj$x, geolife_traj$y, geolife_traj$t)
#'
#' st_dbscan(
#'   data = data,
#'   eps_spatial = 3,
#'   eps_temporal = 30,
#'   min_pts = 3,
#'   # Extra arguments
#'   splitRule = "STD",
#'   search = "kdtree",
#'   approx = 1
#' )
#'
#' @export
st_dbscan <- function(data, eps_spatial, eps_temporal, min_pts, ...) {
  check_inputs(data, eps_spatial, eps_temporal, min_pts)

  # Check extra parameters
  extra <- list(...)
  frnn_args <- c("sort", "search", "bucketSize", "splitRule", "approx",
                 "decreasing", "query")
  dbscan_args <- c("borderPoints", "weights")
  all_args <- c(frnn_args, dbscan_args)
  m_idx <- pmatch(names(extra), all_args)
  if (anyNA(m_idx)) {
    stop(
      "Unknown parameter (check `dbscan::dbscan()` documentation) : ",
      toString(names(extra)[is.na(m_idx)])
    )
  }

  # Isolate extra arguments for frNN() and dbscan()
  extra_frnn <- extra[names(extra) %in% frnn_args]
  extra_dbscan <- extra[names(extra) %in% dbscan_args]

  # Find spatial neighbors with frNN
  nn <- do.call(frNN, c(list(data[, 1:2], eps = eps_spatial), extra_frnn))

  # Filter spatial neighbors with the temporal constraint
  nn_temporal <- temporal_filter_cpp(
    id = nn$id,
    dist = nn$dist,
    t = data[, 3],
    eps_temporal = eps_temporal
  )

  # Update frNN object
  nn$id <- nn_temporal$id
  nn$dist <- nn_temporal$dist

  # Identify clusters
  stdb <- do.call(dbscan, c(list(nn, minPts = min_pts), extra_dbscan))

  return(update_class(stdb, eps_temporal))
}

#' Check if points are core points
#'
#' @description
#' Check if data points are core points. A core point is a point with more than
#' `min_pts` points in his neighborhood.
#'
#' @param data matrix. A matrix containing, **in that order**, `x`, `y` and
#' `t`. `x` (longitude) and `y` (latitude) are the spatial coordinates and `t`
#' is the cumulative time since a common origin (*e.g.* `c(0, 6, 10)`).
#' @param eps_spatial Numeric. The spatial radius threshold. Points closer than
#' this in space may belong to the same cluster.
#' @param eps_temporal Numeric. The temporal threshold. Points closer than this
#' in time may belong to the same cluster.
#' @param min_pts Integer. Minimum number of points required to form a core
#' point.
#' @param ... Additional arguments are passed on to `dbscan::frNN()`.
#'
#' @return
#' A boolean vector indicating if data points are core points.
#'
#' @examples
#' data(geolife_traj)
#'
#' geolife_traj$date_time <- as.POSIXct(
#'   paste(geolife_traj$date, geolife_traj$time),
#'   format = "%Y-%m-%d %H:%M:%S",
#'   tz = "GMT"
#' )
#' geolife_traj$t <- as.numeric(
#'   geolife_traj$date_time - min(geolife_traj$date_time)
#' )
#' data <- cbind(geolife_traj$x, geolife_traj$y, geolife_traj$t)
#'
#' res <- st_dbscan_corepoint(
#'   data = data,
#'   eps_spatial = 3,
#'   eps_temporal = 30,
#'   min_pts = 3
#' )
#' head(res)
#'
#' @export
st_dbscan_corepoint <- function(data, eps_spatial, eps_temporal, min_pts, ...) {
  check_inputs(data, eps_spatial, eps_temporal, min_pts)

  # Check extra parameters
  extra <- list(...)
  frnn_args <- c("sort", "search", "bucketSize", "splitRule", "approx",
                 "decreasing", "query")
  m_idx <- pmatch(names(extra), frnn_args)
  if (anyNA(m_idx)) {
    stop(
      "Unknown parameter (check `dbscan::frNN()` documentation) : ",
      toString(names(extra)[is.na(m_idx)])
    )
  }

  # Isolate extra arguments for frNN()
  extra_frnn <- extra[names(extra) %in% frnn_args]

  # Find spatial neighbors with frNN
  nn <- do.call(frNN, c(list(data[, 1:2], eps = eps_spatial), extra_frnn))

  # Filter spatial neighbors with the temporal constraint
  nn_temporal <- temporal_filter_cpp(
    id = nn$id,
    dist = nn$dist,
    t = data[, 3],
    eps_temporal = eps_temporal
  )

  iscore <- lengths(nn_temporal$id) >= (min_pts - 1)

  return(iscore)
}

#' Create stdbscan class by updating dbscan class
#' @noRd
update_class <- function(dbscan, eps_temporal) {
  dbscan$eps_temporal <- eps_temporal
  class(dbscan) <- c("stdbscan", class(dbscan))
  return(dbscan)
}

#' Method to print stdbscan class
#'
#' This method is adapted from the print method of `dbscan`
#' (`print.dbscan_fast`).
#'
#' @importFrom dbscan ncluster
#' @importFrom dbscan nnoise
#' @importFrom stats nobs
#'
#' @noRd
#' @export
print.stdbscan <- function(x, ...) {
  writeLines(c(
    paste0("ST-DBSCAN clustering for ", nobs(x), " objects."),
    paste0("Parameters: eps = ", x$eps, ", eps_temporal = ", x$eps_temporal, ", minPts = ", x$minPts),
    paste0(
      "Using ",
      x$metric,
      " distances and borderpoints = ",
      x$borderPoints
    ),
    paste0(
      "The clustering contains ",
      ncluster(x),
      " cluster(s) and ",
      nnoise(x),
      " noise points."
    )
  ))

  print(table(x$cluster))
  cat("\n")

  writeLines(strwrap(paste0(
    "Available fields: ",
    toString(names(x))
  ), exdent = 18))
}
