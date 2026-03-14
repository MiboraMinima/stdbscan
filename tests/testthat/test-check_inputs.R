test_that("check_inputs() doesn't returns any error in correct specification", {
  data <- cbind(1:3, 1:3, 1:3)

  expect_no_error(
    check_inputs(data, 1, 1, 2)
  )
})

test_that("There must be 3 columns", {
  data <- cbind(c(0, 1, 2))

  expect_error(
    check_data(data),
    "`data` must have 3 columns : x, y and t"
  )
})

test_that("t must be positive", {
  data <- cbind(c(0, 1, 2), c(0, 1, 2), -1:1)

  expect_error(
    check_data(data),
    "There are negative values in the temporal variable. Make sure that the temporal variable is the third column of `data`"
  )
})

test_that("t must be cumulative", {
  data <- cbind(c(0, 1, 2), c(0, 1, 2), c(1, 0, 5))

  expect_error(
    check_data(data),
    "The temporal variable must be cumulative time since an origin. Make sure that the temporal variable is the third column of `data`"
  )
})

test_that("non-numeric x, y, t are rejected", {
  data <- cbind(
    c("a", "b", "c"),
    c(0, 1, 2),
    c(0, 1, 2)
  )

  expect_error(
    check_data(data),
    "`1` must be a numeric vector"
  )
})

test_that("scalar parameters must be numeric", {
  expect_error(
    check_params(eps_spatial = "a", 1, 2),
    "`eps_spatial` must be numeric"
  )

  expect_error(
    check_params(1, eps_temporal = NA, 2),
    "`eps_temporal` must be numeric"
  )

  expect_error(
    check_params(1, 1, min_pts = "3"),
    "`min_pts` must be numeric"
  )
})

test_that("scalar parameters must have length 1", {
  expect_error(
    check_params(eps_spatial = c(1, 2), 1, 2),
    "`eps_spatial` must have length 1"
  )

  expect_error(
    check_params(1, eps_temporal = c(1, 2), 2),
    "`eps_temporal` must have length 1"
  )

  expect_error(
    check_params(1, 1, min_pts = c(2, 3)),
    "`min_pts` must have length 1"
  )
})

test_that("min_pts must be a natural number", {
  expect_error(
    check_params(1, 1, min_pts = 0),
    "natural number"
  )

  expect_error(
    check_params(1, 1, min_pts = -1),
    "natural number"
  )

  expect_error(
    check_params(1, 1, min_pts = 2.5),
    "natural number"
  )
})
