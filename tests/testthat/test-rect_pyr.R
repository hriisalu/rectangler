test_that("rect_pyr() creates a rectangler pyramid plot", {
  data <- tibble::tibble(
    value = c(3, 2, 1)
  )

  p <- rect_pyr(data)

  expect_s3_class(p, "ggplot")
  expect_true(rect_is_rectangler(p))
  expect_equal(attr(p, "rectangler")$plot_type, "pyr")
})


test_that("rect_pyr() layout has one row per input row", {
  data <- tibble::tibble(
    value = c(3, 2, 1)
  )

  p <- rect_pyr(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(nrow(layout), nrow(data))
})


test_that("rect_pyr() stacks rectangles vertically from top to bottom", {
  data <- tibble::tibble(
    value = c(3, 2, 1)
  )

  p <- rect_pyr(data)
  layout <- attr(p, "rectangler")$layout

  expect_true(layout$ymin[2] < layout$ymin[1])
  expect_true(layout$ymin[3] < layout$ymin[2])
})



test_that("rect_pyr() centers rectangles by default", {
  data <- tibble::tibble(
    value = c(3, 2, 1)
  )

  p <- rect_pyr(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(layout$xmin, -layout$xmax)
})


test_that("rect_pyr() creates narrower rectangles for smaller values", {
  data <- tibble::tibble(
    value = c(3, 2, 1)
  )

  p <- rect_pyr(data)
  layout <- attr(p, "rectangler")$layout

  widths <- layout$xmax - layout$xmin

  expect_true(widths[2] < widths[1])
  expect_true(widths[3] < widths[2])
})


test_that("rect_pyr() accepts direct value vector", {
  p <- rect_pyr(value = c(10, 20, 30, 40, 50))

  expect_true(rect_is_rectangler(p))
  expect_s3_class(p, "ggplot")
  expect_equal(nrow(rect_info(p)$layout), 5)
})
