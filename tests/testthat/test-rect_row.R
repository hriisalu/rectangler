test_that("rect_row() creates a rectangler row plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)

  expect_s3_class(p, "ggplot")
  expect_true(rect_is_rectangler(p))
  expect_equal(attr(p, "rectangler")$plot_type, "row")
})


test_that("rect_row() layout has one row per input row", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(nrow(layout), nrow(data))
})


test_that("rect_row() places rectangles from left to right", {
  data <- tibble::tibble(
    value = c(1, 1, 1)
  )

  p <- rect_row(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(layout$xmin[1], 0)
  expect_true(layout$xmin[2] > layout$xmin[1])
  expect_true(layout$xmin[3] > layout$xmin[2])
})


test_that("rect_row() uses bottom alignment by default", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(unique(layout$ymin), 0)
})


test_that("rect_row() supports top alignment", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data, align = "top")
  layout <- attr(p, "rectangler")$layout

  expect_equal(unique(layout$ymax), 0)
  expect_true(all(layout$ymin < 0))
})


test_that("rect_row() stores align setting", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data, align = "top")
  settings <- attr(p, "rectangler")$settings

  expect_equal(settings$align, "top")
})


test_that("rect_row() accepts direct value vector", {
  p <- rect_row(value = c(10, 20, 30, 40, 50, 60))

  expect_true(rect_is_rectangler(p))
  expect_s3_class(p, "ggplot")
  expect_equal(nrow(rect_info(p)$layout), 6)
})

test_that("rect_row() errors when value and value_col are both supplied", {
  expect_error(
    rect_row(
      data = rect_data_demo,
      value = c(10, 20, 30, 40),
      value_col = "value"
    ),
    "Supply either `value` or `value_col`, not both."
  )
})
