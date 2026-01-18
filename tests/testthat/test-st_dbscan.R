test_that("single spatio-temporal cluster is detected", {
  x <- c(0, 0.1, -0.1, 0.05)
  y <- c(0, 0.05, -0.05, -0.1)
  t <- c(10, 11, 9, 10)

  labels <- st_dbscan(
    x, y, t,
    eps_spatial = 0.3,
    eps_temporal = 2,
    min_pts = 3
  )

  expect_equal(length(unique(labels)), 1)
  expect_true(all(labels == 1))
})

test_that("isolated points are labeled as noise", {
  x <- c(0, 0.1, 5)
  y <- c(0, 0.1, 5)
  t <- c(0, 1, 0)

  labels <- st_dbscan(
    x, y, t,
    eps_spatial = 0.3,
    eps_temporal = 2,
    min_pts = 2
  )

  expect_equal(labels[3], -1)
  expect_true(all(labels[1:2] == 1))
})

test_that("min_pts is enforced strictly", {
  x <- c(0, 0.1)
  y <- c(0, 0.1)
  t <- c(0, 1)

  labels <- st_dbscan(
    x, y, t,
    eps_spatial = 0.3,
    eps_temporal = 2,
    min_pts = 3
  )

  expect_true(all(labels == -1))
})

test_that("results are invariant to input order", {
  set.seed(42)

  x <- c(0, 0.1, -0.1, 5, 5.1)
  y <- c(0, 0.1, -0.1, 5, 5.1)
  t <- c(0, 1, 2, 0, 1)

  labels1 <- st_dbscan(
    x, y, t,
    eps_spatial = 0.3,
    eps_temporal = 2,
    min_pts = 2
  )

  perm <- sample(seq_along(x))
  labels2 <- st_dbscan(
    x[perm], y[perm], t[perm],
    eps_spatial = 0.3,
    eps_temporal = 2,
    min_pts = 2
  )

  expect_equal(
    as.integer(sort(table(labels1))),
    as.integer(sort(table(labels2)))
  )
})

