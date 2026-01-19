#' GPS pings from the GeoLife GPS Trajectories dataset
#'
#' @description
#' Extraction of the GeoLife GPS Trajectories dataset. The selected trajectory
#' id is 000-20081023025304.
#'
#' Data manipulation applied to the raw data :
#'
#' * Conversion to EPSG:4586
#' * Manual selection of the pings
#' * Selection of relevant variables
#'
#' @format A `data.frame` with one row per ping and the following columns:
#'
#' - `date` (chr): The date
#' - `time` (chr): The time
#' - `x` (dbl): Longitude (EPSG:4586)
#' - `y` (dbl): Latitude (EPSG:4586)
#'
#' @source https://www.microsoft.com/en-us/download/details.aspx?id=52367
"geolife_traj"
