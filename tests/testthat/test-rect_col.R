test_that("rect_col() creates a rectangler column plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_col(data)

  expect_s3_class(p, "ggplot")
  expect_true(rect_is_rectangler(p))
  expect_equal(attr(p, "rectangler")$plot_type, "col")
})


test_that("rect_col() layout has one row per input row", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_col(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(nrow(layout), nrow(data))
})


test_that("rect_col() places rectangles from top to bottom", {
  data <- tibble::tibble(
    value = c(1, 1, 1)
  )

  p <- rect_col(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(layout$ymax[1], 0)
  expect_true(layout$ymax[2] < layout$ymax[1])
  expect_true(layout$ymax[3] < layout$ymax[2])
})


test_that("rect_col() uses left alignment by default", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_col(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(unique(layout$xmin), 0)
})


test_that("rect_col() supports right alignment", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_col(data, align = "right")
  layout <- attr(p, "rectangler")$layout

  expect_equal(unique(layout$xmax), 0)
  expect_true(all(layout$xmin < 0))
})


test_that("rect_col() stores align setting", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_col(data, align = "right")
  settings <- attr(p, "rectangler")$settings

  expect_equal(settings$align, "right")
})


test_that("rect_col() accepts direct value vector", {
  p <- rect_col(value = c(10, 20, 30, 40, 50))

  expect_true(rect_is_rectangler(p))
  expect_s3_class(p, "ggplot")
  expect_equal(nrow(rect_info(p)$layout), 5)
})
