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

test_that("non-numeric x, y, t are rejected", {
  x <- c("a", "b", "c")
  y <- c(0, 1, 2)
  t <- c(0, 1, 2)

  expect_error(
    st_dbscan(x, y, t, 1, 1, 2),
    "`x` must be a numeric vector"
  )

  expect_error(
    st_dbscan(c(0, 1, 2), y = letters[1:3], t, 1, 1, 2),
    "`y` must be a numeric vector"
  )

  expect_error(
    st_dbscan(c(0, 1, 2), c(0, 1, 2), t = letters[1:3], 1, 1, 2),
    "`t` must be a numeric vector"
  )
})

test_that("scalar parameters must be numeric", {
  x <- y <- t <- c(0, 1, 2)

  expect_error(
    st_dbscan(x, y, t, eps_spatial = "a", 1, 2),
    "`eps_spatial` must be numeric"
  )

  expect_error(
    st_dbscan(x, y, t, 1, eps_temporal = NA_character_, 2),
    "`eps_temporal` must be numeric"
  )

  expect_error(
    st_dbscan(x, y, t, 1, 1, min_pts = "3"),
    "`min_pts` must be numeric"
  )
})

test_that("scalar parameters must have length 1", {
  x <- y <- t <- c(0, 1, 2)

  expect_error(
    st_dbscan(x, y, t, eps_spatial = c(1, 2), 1, 2),
    "`eps_spatial` must have length 1"
  )

  expect_error(
    st_dbscan(x, y, t, 1, eps_temporal = c(1, 2), 2),
    "`eps_temporal` must have length 1"
  )

  expect_error(
    st_dbscan(x, y, t, 1, 1, min_pts = c(2, 3)),
    "`min_pts` must have length 1"
  )
})

test_that("x, y, t must have the same length", {
  expect_error(
    st_dbscan(
      x = c(0, 1),
      y = c(0, 1, 2),
      t = c(0, 1),
      eps_spatial = 1,
      eps_temporal = 1,
      min_pts = 2
    ),
    "`x`, `y` and `t` must have the same length"
  )
})

test_that("min_pts must be a natural number", {
  x <- y <- t <- c(0, 1, 2)

  expect_error(
    st_dbscan(x, y, t, 1, 1, min_pts = 0),
    "natural number"
  )

  expect_error(
    st_dbscan(x, y, t, 1, 1, min_pts = -1),
    "natural number"
  )

  expect_error(
    st_dbscan(x, y, t, 1, 1, min_pts = 2.5),
    "natural number"
  )
})
