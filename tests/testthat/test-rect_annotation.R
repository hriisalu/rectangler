test_that("rect_annotation() requires a rectangler plot", {
  expect_error(
    rect_annotation(ggplot2::ggplot()),
    "`plot` must be a rectangler plot."
  )
})

test_that("rect_annotation() returns a rectangler plot", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_annotation(label = "Test")

  expect_true(rect_is_rectangler(p))
  expect_s3_class(p, "ggplot")
})

test_that("rect_annotation() preserves core rectangler metadata", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  p2 <- p %>%
    rect_annotation(label = "Test")

  expect_identical(rect_info(p2)$type, rect_info(p)$type)
  expect_identical(rect_info(p2)$plot_type, rect_info(p)$plot_type)
  expect_identical(rect_info(p2)$layout, rect_info(p)$layout)

  expect_true(!identical(rect_info(p2)$settings$limits, rect_info(p)$settings$limits))
})

test_that("rect_annotation() adds annotation layers", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  p2 <- p %>%
    rect_annotation(label = "Test")

  expect_true(length(p2$layers) > length(p$layers))
  expect_true(rect_is_rectangler(p2))
})


test_that("rect_annotation() uses label column", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    note = c("A", "B", "C", "D")
  )

  p <- rect_plot4(data) %>%
    rect_annotation(label_col = "note")

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, data$note)
})

test_that("rect_annotation() accepts constant label", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_annotation(label = "Test")

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, rep("Test", 4))
})

test_that("rect_annotation() accepts vector label", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  labs <- c("A", "B", "C", "D")

  p <- rect_plot4(data) %>%
    rect_annotation(label = labs)

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$label, labs)
})

test_that("rect_annotation() returns unchanged plot when no label is available", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data)
  p2 <- p %>% rect_annotation()

  expect_identical(length(p$layers), length(p2$layers))
  expect_true(rect_is_rectangler(p2))
})

test_that("rect_annotation() errors when label_col is missing", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  expect_error(
    rect_plot4(data) %>%
      rect_annotation(label_col = "missing"),
    "must be a column"
  )
})

test_that("rect_annotation() accepts constant text style values", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  p <- rect_plot4(data) %>%
    rect_annotation(
      label = "Test",
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

test_that("rect_annotation() accepts column-based text style values", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    note = c("A", "B", "C", "D"),
    text_size = c(3, 4, 5, 6),
    text_colour = c("red", "blue", "green", "black")
  )

  p <- rect_plot4(data) %>%
    rect_annotation(
      label_col = "note",
      size_col = "text_size",
      colour_col = "text_colour"
    )

  built <- ggplot2::ggplot_build(p)
  label_layer <- built$data[[length(built$data)]]

  expect_equal(label_layer$size, data$text_size * 3)
  expect_equal(label_layer$colour, data$text_colour)
})


test_that("rect_annotation() supports plot4 annotation positions", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  positions <- c("vertical", "horizontal")

  for (pos in positions) {
    expect_silent(
      rect_plot4(data) %>%
        rect_annotation(
          label = "Test",
          position = pos
        )
    )
  }
})


test_that("rect_annotation() accepts offset_x and offset_y", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  expect_silent(
    rect_plot4(data) %>%
      rect_annotation(
        label = "Test",
        offset_x = 0.2,
        offset_y = 0.1
      )
  )
})

test_that("rect_annotation() accepts different space values", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  expect_silent(
    rect_plot4(data) %>%
      rect_annotation(
        label = "Test",
        space = 0
      )
  )

  expect_silent(
    rect_plot4(data) %>%
      rect_annotation(
        label = "Test",
        space = 0.2
      )
  )

  expect_silent(
    rect_plot4(data) %>%
      rect_annotation(
        label = "Test",
        space = 1
      )
  )
})

test_that("rect_annotation() accepts plot4 position synonyms", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  positions <- c(
    "v", "vert", "vertical",
    "top-bottom", "top_down", "top-down",
    "up-down", "up_below", "up-below",
    "h", "hor", "horizontal", "horisontal",
    "left-right", "left_right",
    "right-left", "right_left"
  )

  for (pos in positions) {
    expect_silent(
      rect_plot4(data) %>%
        rect_annotation(
          label = "Test",
          position = pos
        )
    )
  }
})

test_that("rect_annotation() works with row, col and pyr plots", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4)
  )

  row_plot <- rect_row(data) %>%
    rect_annotation(label = "Test", position = "top")

  col_plot <- rect_col(data) %>%
    rect_annotation(label = "Test", position = "left")

  pyr_plot <- rect_pyr(data) %>%
    rect_annotation(label = "Test", position = "top")

  expect_true(rect_is_rectangler(row_plot))
  expect_true(rect_is_rectangler(col_plot))
  expect_true(rect_is_rectangler(pyr_plot))

  expect_true(length(row_plot$layers) > 1)
  expect_true(length(col_plot$layers) > 1)
  expect_true(length(pyr_plot$layers) > 1)
})


test_that("rect_annotation() errors when column arguments are missing", {
  data <- tibble::tibble(
    value = c(1, 2, 3, 4),
    note = c("A", "B", "C", "D")
  )

  expect_error(
    rect_plot4(data) %>%
      rect_annotation(label_col = "missing"),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_annotation(
        label_col = "note",
        size_col = "missing"
      ),
    "must be a column"
  )

  expect_error(
    rect_plot4(data) %>%
      rect_annotation(
        label_col = "note",
        colour_col = "missing"
      ),
    "must be a column"
  )
})
