context("test-check")

test_that("error if dots not used", {
  f <- function(x, y, ...) {
    check_dots_used()
    x + y
  }

  expect_error(f(1, 2), NA)
  expect_error(f(1, 2, 3), class = "rlib_error_dots_unused")
})

test_that("error if dots not used by another function", {
  g <- function(a = 1, b = 1, ...) {
    a + b
  }
  f <- function(x = 1, ...) {
    check_dots_used()
    x * g(...)
  }

  expect_error(f(x = 10, a = 1), NA)
  expect_error(f(x = 10, c = 3), class = "rlib_error_dots_unused")
})

test_that("error if dots named", {
  f <- function(..., xyz = 1) {
    check_dots_unnamed()
  }

  expect_error(f(xyz = 1), NA)
  expect_error(f(1, 2, 3), NA)
  expect_error(f(1, 2, 3, xyz = 4), NA)
  expect_error(f(1, 2, 3, xy = 4), class = "rlib_error_dots_named")
})

test_that("error if if dots not empty", {
  f <- function(..., xyz = 1) {
    check_dots_empty()
  }

  expect_error(f(xyz = 1), NA)
  expect_error(f(xy = 4), class = "rlib_error_dots_nonempty")
})

test_that("can control the action", {
  f <- function(action, check, ..., xyz = 1) {
    check(action = action)
  }

  expect_error(f(abort, check_dots_used, xy = 4), class = "rlib_error_dots_unused")
  expect_warning(f(warn, check_dots_used, xy = 4), class = "rlib_error_dots_unused")
  expect_message(f(inform, check_dots_used, xy = 4), class = "rlib_error_dots_unused")

  expect_error(f(abort, check_dots_unnamed, xy = 4), class = "rlib_error_dots_named")
  expect_warning(f(warn, check_dots_unnamed, xy = 4), class = "rlib_error_dots_named")
  expect_message(f(inform, check_dots_unnamed, xy = 4), class = "rlib_error_dots_named")

  expect_error(f(abort, check_dots_empty, xy = 4), class = "rlib_error_dots_nonempty")
  expect_warning(f(warn, check_dots_empty, xy = 4), class = "rlib_error_dots_nonempty")
  expect_message(f(inform, check_dots_empty, xy = 4), class = "rlib_error_dots_nonempty")
})
