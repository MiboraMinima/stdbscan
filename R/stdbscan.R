#' Spatio-Temporal DBSCAN
#'
#' @description
#' Perform **ST-DBSCAN** clustering on points with spatial and temporal
#' coordinates. This algorithm identifies clusters of points that are close both
#' in space and time.
#'
#' @param x Numeric vector of x-coordinates (spatial).
#' @param y Numeric vector of y-coordinates (spatial).
#' @param t Numeric vector of time values. `t` is expected to represent elapsed
#' time since a common origin (*e.g.* c(0, 6, 10)).
#' @param eps_spatial Numeric. The spatial radius threshold. Points closer than
#' this in space may belong to the same cluster.
#' @param eps_temporal Numeric. The temporal threshold. Points closer than this
#' in time may belong to the same cluster.
#' @param min_pts Integer. Minimum number of points required to form a core
#' point (standard DBSCAN parameter).
#'
#' @return
#' An integer vector of length `length(x)` with cluster assignments:
#'
#' * `-1`: noise point
#' * `>=1`: cluster ID
#'
#' @details
#' ST-DBSCAN extends classical DBSCAN by incorporating a temporal constraint.
#' Two points are considered neighbors if they are within `eps_spatial` in
#' space **and** within `eps_temporal` in time. Clusters are expanded from core
#' points recursively following the DBSCAN algorithm.
#'
#' This function is implemented in C++ via Rcpp for performance.
#'
#' @references
#' Birant, D., & Kut, A. (2007). ST-DBSCAN: An algorithm for clustering
#' spatial–temporal data. Data & Knowledge Engineering, 60(1), 208–221.
#' https://doi.org/10.1016/j.datak.2006.01.013
#'
#' @examples
#' x <- c(0, 0.1, -0.1, 5, 5.1)
#' y <- c(0, 0.1, -0.1, 5, 5.1)
#' t <- c(0, 5, 6, 7, 10)
#'
#' st_dbscan(x, y, t, eps_spatial = 0.3, eps_temporal = 2, min_pts = 2)
#'
#' @export
st_dbscan <- function(x, y, t, eps_spatial, eps_temporal, min_pts) {
  vars <- list(x = x, y = y, t = t)
  pars <- list(
    eps_spatial = eps_spatial,
    eps_temporal = eps_temporal,
    min_pts = min_pts
  )

  for (n in names(vars)) {
    if (!is.numeric(vars[[n]]))
      stop(paste0("`", n, "` must be a numeric vector"), call. = FALSE)
  }

  for (n in names(pars)) {
    if (!is.numeric(pars[[n]]))
      stop(paste0("`", n, "` must be numeric"), call. = FALSE)
    if (length(pars[[n]]) != 1)
      stop(paste0("`", n, "` must have length 1"), call. = FALSE)
  }

  # Check length
  if (length(x) != length(y) || length(x) != length(t))
    stop("`x`, `y` and `t` must have the same length", call. = FALSE)

  # Check min_pts
  if (min_pts %% 1 != 0 || min_pts < 1)
    stop("`min_pts` must be a natural number >= 1", call. = FALSE)

  # Check t
  if (any(t < 0))
    warning("There are negative values in `t`", call. = FALSE)

  st_dbscan_cpp(
    x = as.double(x),
    y = as.double(y),
    t = as.double(t),
    eps_spatial = eps_spatial,
    eps_temporal = eps_temporal,
    min_pts = min_pts
  )
}
