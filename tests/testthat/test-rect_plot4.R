test_that("rect_plot4() creates a rectangler plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)

  expect_s3_class(p, "ggplot")
  expect_true(rect_is_rectangler(p))
})


test_that("rect_plot4() stores rectangler metadata", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  info <- attr(p, "rectangler")

  expect_type(info, "list")
  expect_equal(info$type, "rectangler")
  expect_equal(info$plot_type, "plot4")
  expect_true("layout" %in% names(info))
  expect_true("settings" %in% names(info))
})

test_that("rect_plot4() layout has one row per input row", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(nrow(layout), nrow(data))
})


test_that("rect_plot4() layout contains rectangle coordinates", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  layout <- attr(p, "rectangler")$layout

  expect_true("xmin" %in% names(layout))
  expect_true("xmax" %in% names(layout))
  expect_true("ymin" %in% names(layout))
  expect_true("ymax" %in% names(layout))
})


test_that("rect_plot4() layout coordinates define valid rectangles", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  layout <- attr(p, "rectangler")$layout

  expect_true(all(layout$xmin < layout$xmax))
  expect_true(all(layout$ymin < layout$ymax))
})

test_that("rect_plot4() stores plot4 side positions in layout", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  layout <- attr(p, "rectangler")$layout

  expect_equal(layout$.rect_side_v, c("top", "top", "bottom", "bottom"))
  expect_equal(layout$.rect_side_h, c("left", "right", "left", "right"))
})

test_that("rect_plot4() places rectangles around the center gap", {
  data <- tibble::tibble(
    value = c(1, 1, 1, 1)
  )

  p <- rect_plot4(data)
  layout <- attr(p, "rectangler")$layout

  expect_true(all(layout$xmin[c(1, 3)] < 0))
  expect_true(all(layout$xmax[c(1, 3)] < 0))

  expect_true(all(layout$xmin[c(2, 4)] > 0))
  expect_true(all(layout$xmax[c(2, 4)] > 0))

  expect_true(all(layout$ymin[c(1, 2)] > 0))
  expect_true(all(layout$ymax[c(1, 2)] > 0))

  expect_true(all(layout$ymin[c(3, 4)] < 0))
  expect_true(all(layout$ymax[c(3, 4)] < 0))
})
