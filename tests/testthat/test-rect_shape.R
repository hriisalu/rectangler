test_that("rect_shape() requires a rectangler plot", {
  expect_error(
    rect_shape(ggplot2::ggplot()),
    "`plot` must be a rectangler plot."
  )
})

test_that("rect_shape() returns a rectangler plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  expect_true(rect_is_rectangler(p))
  expect_s3_class(p, "ggplot")
})

test_that("rect_shape() preserves core rectangler metadata", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  p2 <- p %>% rect_shape()

  expect_identical(rect_info(p2)$type, rect_info(p)$type)
  expect_identical(rect_info(p2)$plot_type, rect_info(p)$plot_type)
  expect_identical(rect_info(p2)$layout, rect_info(p)$layout)

  expect_true(!identical(rect_info(p2)$settings$limits, rect_info(p)$settings$limits))
})

test_that("rect_shape() adds one point layer", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  p2 <- p %>% rect_shape()

  expect_equal(length(p2$layers), length(p$layers) + 1)
  expect_s3_class(
    p2$layers[[length(p2$layers)]]$geom,
    "GeomPoint"
  )
})

test_that("rect_shape() uses default shape", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$shape, rep(21, 4))
})

test_that("rect_shape() uses default size", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(
    shape_layer$size,
    rep(rect_defaults$shape_size * 4, 4)
  )
})


test_that("rect_shape() uses default fill", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(
    shape_layer$fill,
    rep(rect_defaults$shape_fill, 4)
  )
})

test_that("rect_shape() uses default border style", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(
    shape_layer$colour,
    rep(rect_defaults$shape_border_colour, 4)
  )

  expect_equal(
    shape_layer$stroke,
    rep(rect_defaults$shape_border_width / 2, 4)
  )
})


test_that("rect_shape() accepts shape", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape(shape = 22)

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$shape, rep(22, 4))
})


test_that("rect_shape() accepts size", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape(size = 8)

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$size, rep(32, 4))
})


test_that("rect_shape() accepts fill", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape(fill = "red")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$fill, rep("red", 4))
})


test_that("rect_shape() accepts border colour", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape(border_colour = "blue")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$colour, rep("blue", 4))
})


test_that("rect_shape() accepts border width", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape(border_width = 2)

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$stroke, rep(1, 4))
})


test_that("rect_shape() accepts shape_col", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_type = c(21, 22, 23, 24)
  )

  p <- rect_plot4(data) %>%
    rect_shape(shape_col = "shape_type")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$shape, data$shape_type)
})


test_that("rect_shape() accepts size_col", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_size = c(2, 4, 6, 8)
  )

  p <- rect_plot4(data) %>%
    rect_shape(size_col = "shape_size")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$size, data$shape_size * 4)
})


test_that("rect_shape() accepts fill_col", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_fill = c("red", "blue", "green", "yellow")
  )

  p <- rect_plot4(data) %>%
    rect_shape(fill_col = "shape_fill")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$fill, data$shape_fill)
})


test_that("rect_shape() accepts border_colour_col", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_border = c("red", "blue", "green", "black")
  )

  p <- rect_plot4(data) %>%
    rect_shape(border_colour_col = "shape_border")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$colour, data$shape_border)
})


test_that("rect_shape() accepts border_width_col", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_border_width = c(0.5, 1, 1.5, 2)
  )

  p <- rect_plot4(data) %>%
    rect_shape(border_width_col = "shape_border_width")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(shape_layer$stroke, data$shape_border_width / 2)
})

test_that("rect_shape() places shapes left and right of center", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  center_plot <- rect_plot4(data) %>%
    rect_shape(position = "center")

  left_plot <- rect_plot4(data) %>%
    rect_shape(position = "left")

  right_plot <- rect_plot4(data) %>%
    rect_shape(position = "right")

  center_data <- ggplot2::ggplot_build(center_plot)$data[[length(ggplot2::ggplot_build(center_plot)$data)]]
  left_data <- ggplot2::ggplot_build(left_plot)$data[[length(ggplot2::ggplot_build(left_plot)$data)]]
  right_data <- ggplot2::ggplot_build(right_plot)$data[[length(ggplot2::ggplot_build(right_plot)$data)]]

  expect_true(all(left_data$x < center_data$x))
  expect_true(all(right_data$x > center_data$x))
})

test_that("rect_shape() places shapes above and below center", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  center_plot <- rect_plot4(data) %>%
    rect_shape(position = "center")

  top_plot <- rect_plot4(data) %>%
    rect_shape(position = "top")

  bottom_plot <- rect_plot4(data) %>%
    rect_shape(position = "bottom")

  center_data <- ggplot2::ggplot_build(center_plot)$data[[length(ggplot2::ggplot_build(center_plot)$data)]]
  top_data <- ggplot2::ggplot_build(top_plot)$data[[length(ggplot2::ggplot_build(top_plot)$data)]]
  bottom_data <- ggplot2::ggplot_build(bottom_plot)$data[[length(ggplot2::ggplot_build(bottom_plot)$data)]]

  expect_true(all(top_data$y > center_data$y))
  expect_true(all(bottom_data$y < center_data$y))
})

test_that("rect_shape() places shapes in corners", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  center_plot <- rect_plot4(data) %>%
    rect_shape(position = "center")

  top_left_plot <- rect_plot4(data) %>%
    rect_shape(position = "top-left")

  top_right_plot <- rect_plot4(data) %>%
    rect_shape(position = "top-right")

  bottom_left_plot <- rect_plot4(data) %>%
    rect_shape(position = "bottom-left")

  bottom_right_plot <- rect_plot4(data) %>%
    rect_shape(position = "bottom-right")

  center_data <- ggplot2::ggplot_build(center_plot)$data[[length(ggplot2::ggplot_build(center_plot)$data)]]
  top_left_data <- ggplot2::ggplot_build(top_left_plot)$data[[length(ggplot2::ggplot_build(top_left_plot)$data)]]
  top_right_data <- ggplot2::ggplot_build(top_right_plot)$data[[length(ggplot2::ggplot_build(top_right_plot)$data)]]
  bottom_left_data <- ggplot2::ggplot_build(bottom_left_plot)$data[[length(ggplot2::ggplot_build(bottom_left_plot)$data)]]
  bottom_right_data <- ggplot2::ggplot_build(bottom_right_plot)$data[[length(ggplot2::ggplot_build(bottom_right_plot)$data)]]

  expect_true(all(top_left_data$x < center_data$x))
  expect_true(all(top_left_data$y > center_data$y))

  expect_true(all(top_right_data$x > center_data$x))
  expect_true(all(top_right_data$y > center_data$y))

  expect_true(all(bottom_left_data$x < center_data$x))
  expect_true(all(bottom_left_data$y < center_data$y))

  expect_true(all(bottom_right_data$x > center_data$x))
  expect_true(all(bottom_right_data$y < center_data$y))
})

test_that("rect_shape() accepts corner position", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape(position = "corner")

  built <- ggplot2::ggplot_build(p)
  shape_layer <- built$data[[length(built$data)]]

  expect_equal(nrow(shape_layer), 4)
  expect_true(all(!is.na(shape_layer$x)))
  expect_true(all(!is.na(shape_layer$y)))
})

test_that("rect_shape() accepts offset_x and offset_y", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  base_plot <- rect_plot4(data) %>%
    rect_shape(position = "center")

  offset_plot <- rect_plot4(data) %>%
    rect_shape(
      position = "center",
      offset_x = 0.1,
      offset_y = 0.2
    )

  base_data <- ggplot2::ggplot_build(base_plot)$data[[length(ggplot2::ggplot_build(base_plot)$data)]]
  offset_data <- ggplot2::ggplot_build(offset_plot)$data[[length(ggplot2::ggplot_build(offset_plot)$data)]]

  expect_true(all(offset_data$x > base_data$x))
  expect_true(all(offset_data$y > base_data$y))
})

test_that("rect_shape() works with row, col and pyr plots", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  row_plot <- rect_row(data) %>%
    rect_shape()

  col_plot <- rect_col(data) %>%
    rect_shape()

  pyr_plot <- rect_pyr(data) %>%
    rect_shape()

  expect_true(rect_is_rectangler(row_plot))
  expect_true(rect_is_rectangler(col_plot))
  expect_true(rect_is_rectangler(pyr_plot))

  row_built <- ggplot2::ggplot_build(row_plot)
  col_built <- ggplot2::ggplot_build(col_plot)
  pyr_built <- ggplot2::ggplot_build(pyr_plot)

  row_shape_layer <- row_built$data[[length(row_built$data)]]
  col_shape_layer <- col_built$data[[length(col_built$data)]]
  pyr_shape_layer <- pyr_built$data[[length(pyr_built$data)]]

  expect_equal(nrow(row_shape_layer), 4)
  expect_equal(nrow(col_shape_layer), 4)
  expect_equal(nrow(pyr_shape_layer), 4)

  expect_true(all(!is.na(row_shape_layer$x)))
  expect_true(all(!is.na(row_shape_layer$y)))

  expect_true(all(!is.na(col_shape_layer$x)))
  expect_true(all(!is.na(col_shape_layer$y)))

  expect_true(all(!is.na(pyr_shape_layer$x)))
  expect_true(all(!is.na(pyr_shape_layer$y)))
})


test_that("rect_shape() errors when column arguments are missing from data", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape(shape_col = "missing"),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape(size_col = "missing"),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape(fill_col = "missing"),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape(border_colour_col = "missing"),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape(border_width_col = "missing"),
    "must be a column"
  )
})
