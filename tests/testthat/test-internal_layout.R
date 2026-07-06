test_that("rect_ratio() parses supported aspect ratios", {
  expect_equal(rect_ratio("square"), c(1, 1))
  expect_equal(rect_ratio("golden"), c(1.618, 1))
  expect_equal(rect_ratio("1:2"), c(1, 2))
  expect_equal(rect_ratio(c(2, 3)), c(2, 3))
})

test_that("rect_ratio() errors on unsupported aspect ratios", {
  expect_error(rect_ratio("wide"), "positive number")
  expect_error(rect_ratio(c(1, 2, 3)), "positive number")
})

test_that("rect_sides() preserves rectangle area", {
  value <- c(1, 4, 9)

  sides <- rect_sides(value)

  expect_equal(sides$width * sides$height, value)
})

test_that("rect_sides() respects aspect ratio", {
  sides <- rect_sides(2, aspect_ratio = "1:2")

  expect_equal(
    sides$width / sides$height,
    1 / 2
  )
})

test_that("rect_limits() adds padding around layout", {
  layout <- data.frame(
    xmin = c(0, 1),
    xmax = c(1, 2),
    ymin = c(0, -1),
    ymax = c(1, 0)
  )

  limits <- rect_limits(layout, padding = 0.1)

  expect_true(limits$x[1] < min(layout$xmin))
  expect_true(limits$x[2] > max(layout$xmax))
  expect_true(limits$y[1] < min(layout$ymin))
  expect_true(limits$y[2] > max(layout$ymax))
  expect_true(limits$pad > 0)
})
