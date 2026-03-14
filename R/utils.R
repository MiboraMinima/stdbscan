#' Check stdbscan inputs
#'
#' @description
#' Check the inputs provided by the user.
#'
#' @param data matrix. A matrix containing, in that order, x, y and t.
#' @param eps_spatial Numeric. The spatial radius threshold. Points closer than
#' this in space may belong to the same cluster.
#' @param eps_temporal Numeric. The temporal threshold. Points closer than this
#' in time may belong to the same cluster.
#' @param min_pts Integer. Minimum number of points required to form a core
#' point (standard DBSCAN parameter).
#'
#' @noRd
check_inputs <- function(data, eps_spatial, eps_temporal, min_pts=NULL) {
  check_data(data)
  check_params(eps_spatial, eps_temporal, min_pts)
}

#' Check stdbscan data
#'
#' @description
#' Check the data provided by the user.
#'
#' @param data matrix. A matrix containing, in that order, x, y and t.
#'
#' @noRd
check_data <- function(data) {
  if (ncol(data) != 3)
    stop("`data` must have 3 columns : x, y and t", call. = FALSE)

  for (n in seq_len(ncol(data))) {
    if (!is.numeric(data[[n]]))
      stop(paste0("`", n, "` must be a numeric vector"), call. = FALSE)
  }

  # Check t
  t <- data[, 3]
  if (any(t < 0))
    stop(
      "There is negative values in the temporal variable. Make sure that the temporal variable is the third column of `data`.",
      call. = FALSE
    )

  if (!all(diff(t) >= 0))
    stop(paste0(
      "The temporal variable must be cumulative time since an origin. Make sure that the temporal variable is the third column of `data`."
    ), call. = FALSE)
}

#' Check stdbscan parameters
#'
#' @description
#' Check the parameters provided by the user.
#'
#' @param eps_spatial Numeric. The spatial radius threshold. Points closer than
#' this in space may belong to the same cluster.
#' @param eps_temporal Numeric. The temporal threshold. Points closer than this
#' in time may belong to the same cluster.
#' @param min_pts Integer. Minimum number of points required to form a core
#' point (standard DBSCAN parameter).
#'
#' @noRd
check_params <- function(eps_spatial, eps_temporal, min_pts = NULL) {
  pars <- list(
    eps_spatial = eps_spatial,
    eps_temporal = eps_temporal
  )

  if (!is.null(min_pts)) {
    if (!is.numeric(min_pts))
      stop(paste0("`min_pts` must be numeric"), call. = FALSE)
    if (length(min_pts) != 1)
      stop(paste0("`min_pts` must have length 1"), call. = FALSE)

    if (min_pts %% 1 != 0 || min_pts < 1)
      stop("`min_pts` must be a natural number >= 1", call. = FALSE)
  }

  for (n in names(pars)) {
    if (!is.numeric(pars[[n]]))
      stop(paste0("`", n, "` must be numeric"), call. = FALSE)
    if (length(pars[[n]]) != 1)
      stop(paste0("`", n, "` must have length 1"), call. = FALSE)
  }
}
