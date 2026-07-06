test_that("rect_style() requires a rectangler plot", {
  p <- ggplot2::ggplot()

  expect_error(
    rect_style(p),
    "`plot` must be a rectangler plot."
  )
})


test_that("rect_style() returns a rectangler plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  p2 <- rect_style(p)

  expect_s3_class(p2, "ggplot")
  expect_true(rect_is_rectangler(p2))
})


test_that("rect_style() preserves metadata", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  p2 <- rect_style(p)

  expect_equal(
    attr(p, "rectangler")$layout,
    attr(p2, "rectangler")$layout
  )

  expect_equal(
    attr(p, "rectangler")$settings,
    attr(p2, "rectangler")$settings
  )
})


test_that("rect_style() adds one geom_rect layer", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  p2 <- rect_style(p)

  expect_equal(length(p$layers) + 1, length(p2$layers))
})

test_that("rect_style() stores constant style values in layer data", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  p <- rect_style(
    p,
    fill = "red",
    border_colour = "blue",
    border_width = 2,
    border_type = "dashed"
  )

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(layer_data$.rect_fill, c("red", "red", "red"))
  expect_equal(layer_data$.rect_border_colour, c("blue", "blue", "blue"))
  expect_equal(layer_data$.rect_border_width, c(1, 1, 1))
  expect_equal(layer_data$.rect_border_type, c("dashed", "dashed", "dashed"))
})

test_that("rect_style() uses fill_col from data", {
  data <- tibble::tibble(
    value = c(1, 2, 3),
    my_fill = c("red", "green", "blue")
  )

  p <- rect_row(data)
  p <- rect_style(p, fill_col = "my_fill")

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(
    layer_data$.rect_fill,
    c("red", "green", "blue")
  )
})

test_that("rect_style() uses border_colour_col from data", {
  data <- tibble::tibble(
    value = c(1, 2, 3),
    my_border = c("red", "green", "blue")
  )

  p <- rect_row(data)
  p <- rect_style(p, border_colour_col = "my_border")

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(layer_data$.rect_border_colour, c("red", "green", "blue"))
})


test_that("rect_style() uses border_width_col from data", {
  data <- tibble::tibble(
    value = c(1, 2, 3),
    my_width = c(1, 2, 3)
  )

  p <- rect_row(data)
  p <- rect_style(p, border_width_col = "my_width")

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(layer_data$.rect_border_width, c(0.5, 1, 1.5))
})


test_that("rect_style() uses border_type_col from data", {
  data <- tibble::tibble(
    value = c(1, 2, 3),
    my_type = c("solid", "dashed", "dotted")
  )

  p <- rect_row(data)
  p <- rect_style(p, border_type_col = "my_type")

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(layer_data$.rect_border_type, c("solid", "dashed", "dotted"))
})

test_that("rect_style() stores constant alpha value in layer data", {
  data <- tibble::tibble(
    value = c(1, 2, 3)
  )

  p <- rect_row(data)
  p <- rect_style(p, alpha = 0.5)

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(layer_data$.rect_alpha, c(0.5, 0.5, 0.5))
})


test_that("rect_style() uses alpha_col from data", {
  data <- tibble::tibble(
    value = c(1, 2, 3),
    my_alpha = c(0.2, 0.5, 0.8)
  )

  p <- rect_row(data)
  p <- rect_style(p, alpha_col = "my_alpha")

  layer_data <- p$layers[[length(p$layers)]]$data

  expect_equal(layer_data$.rect_alpha, c(0.2, 0.5, 0.8))
})
