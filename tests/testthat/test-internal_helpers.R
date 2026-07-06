test_that("rect_recycle() recycles values", {
  expect_equal(rect_recycle(NULL, 3), rep(NA, 3))
  expect_equal(rect_recycle("A", 3), c("A", "A", "A"))
  expect_equal(rect_recycle(c("A", "B"), 5), c("A", "B", "A", "B", "A"))
})

test_that("rect_size() applies relative size", {
  expect_equal(rect_size(NULL, 4), 4)
  expect_equal(rect_size(2, 4), 8)
  expect_equal(rect_size(c(1, 2), 4), c(4, 8))
})

test_that("rect_text_size() converts text size", {
  expect_equal(rect_text_size(1), 3)
  expect_equal(rect_text_size(c(1, 2)), c(3, 6))
})

test_that("rect_prepare_value() uses constants, columns and defaults", {
  data <- tibble::tibble(
    value = c(1, 2, 3),
    label = c("A", "B", "C")
  )

  expect_equal(
    rect_prepare_value(data, value = "X", n = 3),
    c("X", "X", "X")
  )

  expect_equal(
    rect_prepare_value(data, value_col = "label", n = 3),
    data$label
  )

  expect_equal(
    rect_prepare_value(data, default = "missing", n = 3),
    rep("missing", 3)
  )
})

test_that("rect_prepare_value() lets value_col override value", {
  data <- tibble::tibble(
    label = c("A", "B", "C")
  )

  expect_equal(
    rect_prepare_value(
      data,
      value = "X",
      value_col = "label",
      n = 3
    ),
    data$label
  )
})

test_that("rect_prepare_value() errors when value_col is missing", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  expect_error(
    rect_prepare_value(data, value_col = "missing", arg = "label"),
    "`label_col` must be a column"
  )
})
