test_that("Correct predictions", {
  geolife_traj$date_time <- as.POSIXct(
    paste(geolife_traj$date, geolife_traj$time),
    format = "%Y-%m-%d %H:%M:%S",
    tz = "GMT"
  )
  geolife_traj$t <- as.numeric(
    geolife_traj$date_time - min(geolife_traj$date_time)
  )

  data <- cbind(geolife_traj$x, geolife_traj$y, geolife_traj$t)
  newdata <- cbind(
    c(440160,  440165,  440144,  440130,  440160),
    c(4428129, 4428135, 4428120, 4428123, 4428122),
    c(4617,    4620,    4629,    4635,    4640)
  )
  res <- st_dbscan(data, eps_spatial = 3, eps_temporal = 30, min_pts = 5)

  expect_equal(
    predict(res, data = data, newdata = newdata),
    c(0, 0, 0, 0, 2)
  )
})

