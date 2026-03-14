#' Predict newdata
#'
#' Assigns each new observation to an existing cluster from a fitted `stdbscan`
#' object, or marks it as noise if it falls outside any cluster.
#'
#' @param object An object of class `stdbscan`.
#' @param data matrix. The data set used to create the clustering object.
#' @param newdata matrix. New data points for which the cluster membership
#' should be predicted. The data must be in the same format as the input data.
#' @param ... Additional arguments are passed on to `dbscan::frNN()`.
#'
#' @return
#' An integer vector of cluster labels, matching the labels of the input
#' `stdbscan` object.
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
#' res <- st_dbscan(
#'   data = data,
#'   eps_spatial = 3,
#'   eps_temporal = 30,
#'   min_pts = 5
#' )
#'
#' newdata <- cbind(
#'   c(440160,  440165,  440144,  440130,  440160),
#'   c(4428129, 4428135, 4428120, 4428123, 4428122),
#'   c(4617,    4620,    4629,    4635,    4640)
#' )
#' predict(res, data, newdata)
#'
#' @export
predict.stdbscan <- function(object, data, newdata, ...) {
  clusters <- object$cluster
  eps_spatial <- object$eps
  eps_temporal <- object$eps_temporal

  check_params(eps_spatial, eps_temporal)
  check_data(data)
  check_data(newdata)

  # don't use noise
  dt_filter <- data[clusters != 0,]
  clusters <- clusters[clusters != 0]

  # Get only newdata neighbors in original data
  nn <- frNN(
    dt_filter[, 1:2],
    query = newdata[, 1:2],
    eps = eps_spatial,
    sort = TRUE,
    ...
  )
  nn_ids <- nn$id

  # Filter identified spatial neighbors in original data by time in newdata
  # only if there is spatial neighbors
  if (sum(vapply(nn_ids, function(ids) length(ids), integer(1L))) > 0) {
    nn_ids <- temporal_filter_pred_cpp(
      id = nn_ids,
      t = dt_filter[, 3],
      n_t = newdata[, 3],
      eps_temporal = eps_temporal
    )
  }

  # Make prediction
  pred <- vapply(
    nn_ids,
    function(nns) if (length(nns) == 0L) 0L else clusters[nns[1L]],
    integer(1L)
  )

  return(pred)
}
