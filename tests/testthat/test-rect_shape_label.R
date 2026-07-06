test_that("rect_shape_label() requires a rectangler plot", {
  expect_error(
    rect_shape_label(ggplot2::ggplot()),
    "`plot` must be a rectangler plot."
  )
})

test_that("rect_shape_label() returns a rectangler plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label()

  expect_true(rect_is_rectangler(p))
  expect_s3_class(p, "ggplot")
})

test_that("rect_shape_label() preserves core rectangler metadata", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  p2 <- p %>%
    rect_shape_label()

  expect_identical(rect_info(p2)$type, rect_info(p)$type)
  expect_identical(rect_info(p2)$plot_type, rect_info(p)$plot_type)
  expect_identical(rect_info(p2)$layout, rect_info(p)$layout)
})

test_that("rect_shape_label() adds one text layer", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  p2 <- p %>%
    rect_shape_label()

  expect_equal(length(p2$layers), length(p$layers) + 1)
  expect_s3_class(
    p2$layers[[length(p2$layers)]]$geom,
    "GeomText"
  )
})

test_that("rect_shape_label() uses default shape_label column", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label()

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, data$shape_label)
})

test_that("rect_shape_label() uses label_col", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    my_label = c("One", "Two", "Three", "Four")
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label(label_col = "my_label")

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, data$my_label)
})

test_that("rect_shape_label() accepts constant label", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label(label = "X")

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, rep("X", 4))
})

test_that("rect_shape_label() accepts vector label", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label(label = c("A", "B", "C", "D"))

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, c("A", "B", "C", "D"))
})

test_that("rect_shape_label() returns unchanged plot when no label is available", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_shape()

  p2 <- p %>%
    rect_shape_label()

  expect_identical(length(p2$layers), length(p$layers))
  expect_true(rect_is_rectangler(p2))
})

test_that("rect_shape_label() accepts constant text style values", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label(
      size = 6,
      colour = "red",
      family = "serif",
      fontface = "bold"
    )

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$size, rep(18, 4))
  expect_equal(label_layer$colour, rep("red", 4))
  expect_equal(label_layer$family, rep("serif", 4))
  expect_equal(label_layer$fontface, rep("bold", 4))
})

test_that("rect_shape_label() accepts column-based text style values", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D"),
    text_size = c(3, 4, 5, 6),
    text_colour = c("red", "blue", "green", "black")
  )

  p <- rect_plot4(data) %>%
    rect_shape() %>%
    rect_shape_label(
      size_col = "text_size",
      colour_col = "text_colour"
    )

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$size, data$text_size * 3)
  expect_equal(label_layer$colour, data$text_colour)
})

test_that("rect_shape_label() keeps labels centred on shapes when position matches", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_shape(position = "top-right") %>%
    rect_shape_label(position = "top-right")

  built <- ggplot2::ggplot_build(p)

  shape_layer <- built$data[[length(built$data) - 1]]
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$x, shape_layer$x)
  expect_equal(label_layer$y, shape_layer$y)
})

test_that("rect_shape_label() works with row, col and pyr plots", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  row_plot <- rect_row(data) %>%
    rect_shape() %>%
    rect_shape_label()

  col_plot <- rect_col(data) %>%
    rect_shape() %>%
    rect_shape_label()

  pyr_plot <- rect_pyr(data) %>%
    rect_shape() %>%
    rect_shape_label()

  expect_true(rect_is_rectangler(row_plot))
  expect_true(rect_is_rectangler(col_plot))
  expect_true(rect_is_rectangler(pyr_plot))

  expect_equal(
    ggplot2::ggplot_build(row_plot)$data[[length(ggplot2::ggplot_build(row_plot)$data)]]$label,
    data$shape_label
  )

  expect_equal(
    ggplot2::ggplot_build(col_plot)$data[[length(ggplot2::ggplot_build(col_plot)$data)]]$label,
    data$shape_label
  )

  expect_equal(
    ggplot2::ggplot_build(pyr_plot)$data[[length(ggplot2::ggplot_build(pyr_plot)$data)]]$label,
    data$shape_label
  )
})

test_that("rect_shape_label() errors when label_col is missing", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape() %>%
      rect_shape_label(label_col = "missing"),
    "must be a column"
  )
})


test_that("rect_shape_label() errors when style columns are missing", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape() %>%
      rect_shape_label(size_col = "missing"),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_shape() %>%
      rect_shape_label(colour_col = "missing"),
    "must be a column"
  )
})

test_that("rect_shape_label() supports different positions", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    shape_label = c("A", "B", "C", "D")
  )

  positions <- c(
    "center",
    "left",
    "right",
    "top",
    "bottom",
    "top-left",
    "top-right",
    "bottom-left",
    "bottom-right",
    "corner"
  )

  for (pos in positions) {
    p <- rect_plot4(data) %>%
      rect_shape(position = pos) %>%
      rect_shape_label(position = pos)

    built <- ggplot2::ggplot_build(p)

    shape_layer <- built$data[[length(built$data) - 1]]
    label_layer <- built$data[[length(built$data)]]

    expect_equal(label_layer$x, shape_layer$x)
    expect_equal(label_layer$y, shape_layer$y)
  }
})
