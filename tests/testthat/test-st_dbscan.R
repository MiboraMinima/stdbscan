test_that("Single spatio-temporal cluster is detected", {
  data <- cbind(c(0, 0.1, -0.1, 0.05), c(0, 0.05, -0.05, -0.1), 1:4)
  res <- st_dbscan(data, eps_spatial = 100, eps_temporal = 100, min_pts = 100)

  expect_equal(length(unique(res$cluster)), 1)
  expect_true(all(res$cluster == 0))
})

test_that("Isolated points are labeled as noise", {
  data <- cbind(c(0, 0.1, 5), c(0, 0.1, 5), 1:3)
  res <- st_dbscan(data, eps_spatial = 0.3, eps_temporal = 2, min_pts = 2)

  expect_equal(res$cluster[3], 0)
  expect_true(all(res$cluster[1:2] == 1))
})

test_that("min_pts is enforced strictly", {
  data <- cbind(c(0, 0.1), c(0, 0.1), c(0, 1))
  res <- st_dbscan(data, eps_spatial = 0.3, eps_temporal = 2, min_pts = 3)

  expect_true(all(res$cluster == 0))
})

test_that("Unknow parameters returns an error", {
  data <- cbind(c(0, 0.1), c(0, 0.1), c(0, 1))

  expect_error(
    st_dbscan(
      data,
      eps_spatial = 0.3,
      eps_temporal = 2,
      min_pts = 3,
      erroneous = 4
    ),
    "Unknown parameter (check `dbscan::dbscan()` documentation) : erroneous",
    fixed=TRUE
  )
})

test_that("Correct corepoints", {
  geolife_traj$date_time <- as.POSIXct(
    paste(geolife_traj$date, geolife_traj$time),
    format = "%Y-%m-%d %H:%M:%S",
    tz = "GMT"
  )
  geolife_traj$t <- as.numeric(
    geolife_traj$date_time - min(geolife_traj$date_time)
  )
  data <- cbind(geolife_traj$x, geolife_traj$y, geolife_traj$t)
  data <- data[290:300,]

  expect_identical(
    st_dbscan_corepoint(
      data,
      eps_spatial = 3,
      eps_temporal = 30,
      min_pts = 5
    ),
    c(FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
  )
})

test_that("st_dban_corepoints stops when unknown parameters", {
  data <- cbind(c(0, 0.1), c(0, 0.1), c(0, 1))

  expect_error(
    st_dbscan_corepoint(
      data,
      eps_spatial = 0.3,
      eps_temporal = 2,
      min_pts = 3,
      erroneous = 4
    ),
    "Unknown parameter (check `dbscan::frNN()` documentation) : erroneous",
    fixed=TRUE
  )
})

test_that("print.stdbscan produces correct output", {
  data <- cbind(c(0, 0.1), c(0, 0.1), c(0, 1))
  res <- st_dbscan(data, eps_spatial = 0.3, eps_temporal = 2, min_pts = 3)

  x <- structure(
    list(
      cluster      = c(0L, 0L),
      eps          = 0.5,
      eps_temporal = 30L,
      minPts       = 3L,
      metric       = "euclidean",
      borderPoints = TRUE
    ),
    class = c("stdbscan", "dbscan_fast", "dbscan")
  )

  expect_output(print(x), "ST-DBSCAN clustering for 2 objects")
  expect_output(print(x), "eps = 0.5")
  expect_output(print(x), "eps_temporal = 30")
  expect_output(print(x), "minPts = 3")
  expect_output(print(x), "euclidean")
  expect_output(print(x), "borderpoints = TRUE")
  expect_output(print(x), "0 cluster")
  expect_output(print(x), "2 noise points")
  expect_output(print(x), "Available fields:")
})
