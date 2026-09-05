rect_construct <- function(data = NULL,
                           value = NULL,
                           value_col = NULL,
                           aspect_ratio,
                           gap,
                           padding,
                           layout_fun,
                           settings = list(),
                           plot_type) {

  # If no data frame is supplied, create a minimal internal data frame
  # from the supplied values.
  if (is.null(data)) {

    if (is.null(value)) {
      stop(
        "Supply either `data` with `value_col`, or supply `value`.",
        call. = FALSE
      )
    }

    data <- data.frame(
      .rect_id = seq_along(value)
    )
  }

  rect_check_data(
    data = data,
    value = value,
    value_col = value_col
  )

  values <- rect_prepare_value(
    data = data,
    value = value,
    value_col = value_col,
    default = NULL,
    n = nrow(data),
    arg = "value"
  )

  sides <- rect_sides(
    value = values,
    aspect_ratio = aspect_ratio
  )

  gap_abs <- mean(c(sides$width, sides$height), na.rm = TRUE) * gap

  layout <- cbind(
    data,
    sides,
    layout_fun(
      width = sides$width,
      height = sides$height,
      gap = gap_abs
    )
  )

  limits <- rect_limits(layout, padding)

  p <- ggplot2::ggplot(layout) +
    ggplot2::geom_rect(
      ggplot2::aes(
        xmin = xmin,
        xmax = xmax,
        ymin = ymin,
        ymax = ymax
      ),
      fill = "grey85",
      colour = "white",
      linewidth = 0.5
    ) +
    ggplot2::coord_fixed(clip = "off") +
    ggplot2::scale_x_continuous(
      limits = limits$x,
      expand = ggplot2::expansion(mult = 0)
    ) +
    ggplot2::scale_y_continuous(
      limits = limits$y,
      expand = ggplot2::expansion(mult = 0)
    ) +
    ggplot2::theme_void()

  rect_metadata(
    p = p,
    plot_type = plot_type,
    layout = layout,
    settings = c(
      list(
        value = values,
        value_col = value_col,
        aspect_ratio = aspect_ratio,
        gap = gap,
        gap_abs = gap_abs,
        padding = padding,
        limits = limits,
        base_fill = "grey85",
        base_border_colour = "white",
        base_border_width = 0.5,
        base_border_type = "solid",
        base_alpha = 1
      ),
      settings
    )
  )
}

#' Create a 2×2 rectangle layout
#'
#' Creates a plot consisting of four rectangles arranged in a 2×2 layout.
#' Rectangle areas are proportional to the supplied numeric values.
#' Values can be supplied directly with `value` or taken from a column
#' in `data` using `value_col`.
#'
#' The returned plot can be further customised by adding Rectangler layers,
#' such as `rect_style()`, `rect_label()`, `rect_shape()`,
#' `rect_shape_label()`, or `rect_annotation()`.
#'
#' @param data Optional data frame containing one row for each rectangle.
#'   Only the first four rows are used. If omitted, supply rectangle values
#'   directly with `value`.
#' @param value Numeric value or vector of values used to determine rectangle
#'   areas. When `data` is omitted, at least four values must be supplied and
#'   only the first four are used.
#' @param value_col Name of the column in `data` containing rectangle values.
#' @param aspect_ratio Desired rectangle aspect ratio.
#'   Can be `"square"`, `"golden"`, a ratio string such as `"1:2"`,
#'   or a numeric vector such as `c(1, 2)`.
#' @param gap Relative spacing between rectangles.
#' @param padding Relative padding around the complete layout.
#'
#' @return
#' A Rectangler plot object (a `ggplot`) that can be extended with
#' additional Rectangler layer functions.
#'
#' @examples
#' rect_plot4(value = c(10, 20, 30, 40))
#'
#' rect_plot4(rect_data_demo, value_col = "value")
#'
#' @export
rect_plot4 <- function(data = NULL,
                       value = NULL,
                       value_col = "value",
                       aspect_ratio = "square",
                       gap = rect_defaults$gap,
                       padding = rect_defaults$padding) {

  if (is.null(data) && is.null(value)) {
    stop(
      "Supply either `data` with `value_col`, or supply `value`.",
      call. = FALSE
    )
  }

  if (!is.null(value) && missing(value_col)) {
    value_col <- NULL
  }

  if (is.null(data)) {
    if (length(value) < 4) {
      stop("`rect_plot4()` requires at least four values.", call. = FALSE)
    }

    value <- value[1:4]
  } else {

    rect_check_plot4_data(
      data = data,
      value = value,
      value_col = value_col
    )

    data <- data[1:4, ]

    if (!is.null(value) && length(value) > 1) {
      value <- value[1:4]
    }
  }

  rect_construct(
    data = data,
    value = value,
    value_col = value_col,
    aspect_ratio = aspect_ratio,
    gap = gap,
    padding = padding,
    plot_type = "plot4",
    layout_fun = rect_layout_plot4
  )
}


#' Create a column layout of rectangles
#'
#' Creates a vertical layout where rectangles are stacked from top to bottom.
#' Rectangle areas are proportional to the supplied numeric values.
#' Values can be supplied directly with `value` or taken from a column
#' in `data` using `value_col`.
#'
#' The returned plot can be further customised by adding Rectangler layers,
#' such as `rect_style()`, `rect_label()`, `rect_shape()`,
#' `rect_shape_label()`, or `rect_annotation()`.
#'
#' @param data Optional data frame containing one row for each rectangle.
#'   If omitted, supply rectangle values directly with `value`.
#' @param value Numeric value or vector of values used to determine rectangle
#'   areas.
#' @param value_col Name of the column in `data` containing rectangle values.
#' @param aspect_ratio Desired rectangle aspect ratio.
#'   Can be `"square"`, `"golden"`, a ratio string such as `"1:2"`,
#'   or a numeric vector such as `c(1, 2)`.
#' @param gap Relative spacing between rectangles.
#' @param padding Relative padding around the complete layout.
#' @param align Alignment of rectangles within the column.
#'   One of `"left"` or `"right"`.
#'
#' @return
#' A Rectangler plot object (a `ggplot`) that can be extended with
#' additional Rectangler layer functions.
#'
#' @examples
#' rect_col(value = c(10, 20, 30, 40))
#'
#' rect_col(rect_data_demo, value_col = "value", align = "right")
#'
#' @export
rect_col <- function(data = NULL,
                     value = NULL,
                     value_col = "value",
                     aspect_ratio = "square",
                     gap = rect_defaults$gap,
                     padding = rect_defaults$padding,
                     align = "left") {

  if (is.null(data) && is.null(value)) {
    stop(
      "Supply either `data` with `value_col`, or supply `value`.",
      call. = FALSE
    )
  }

  if (!is.null(value) && missing(value_col)) {
    value_col <- NULL
  }

  align <- rect_match_align(
    align = align,
    choices = c("left", "right"),
    synonyms = list(
      l = "left",
      r = "right"
    )
  )

  rect_construct(
    data = data,
    value = value,
    value_col = value_col,
    aspect_ratio = aspect_ratio,
    gap = gap,
    padding = padding,
    plot_type = "col",
    layout_fun = function(width, height, gap) {
      rect_layout_col(
        width = width,
        height = height,
        gap = gap,
        align = align
      )
    },
    settings = list(
      align = align
    )
  )
}

#' Create a row layout of rectangles
#'
#' Creates a horizontal layout where rectangles are arranged from left to right.
#' Rectangle areas are proportional to the supplied numeric values.
#' Values can be supplied directly with `value` or taken from a column
#' in `data` using `value_col`.
#'
#' The returned plot can be further customised by adding Rectangler layers,
#' such as `rect_style()`, `rect_label()`, `rect_shape()`,
#' `rect_shape_label()`, or `rect_annotation()`.
#'
#' @param data Optional data frame containing one row for each rectangle.
#'   If omitted, supply rectangle values directly with `value`.
#' @param value Numeric value or vector of values used to determine rectangle
#'   areas.
#' @param value_col Name of the column in `data` containing rectangle values.
#' @param aspect_ratio Desired rectangle aspect ratio.
#'   Can be `"square"`, `"golden"`, a ratio string such as `"1:2"`,
#'   or a numeric vector such as `c(1, 2)`.
#' @param gap Relative spacing between rectangles.
#' @param padding Relative padding around the complete layout.
#' @param align Alignment of rectangles within the row.
#'   One of `"top"` or `"bottom"`.
#'
#' @return
#' A Rectangler plot object (a `ggplot`) that can be extended with
#' additional Rectangler layer functions.
#'
#' @examples
#' rect_row(value = c(10, 20, 30, 40))
#'
#' rect_row(rect_data_demo, value_col = "value", align = "bottom")
#'
#' @export
rect_row <- function(data = NULL,
                     value = NULL,
                     value_col = "value",
                     aspect_ratio = "square",
                     gap = rect_defaults$gap,
                     padding = rect_defaults$padding,
                     align = "bottom") {

  if (is.null(data) && is.null(value)) {
    stop(
      "Supply either `data` with `value_col`, or supply `value`.",
      call. = FALSE
    )
  }

  if (!is.null(value) && missing(value_col)) {
    value_col <- NULL
  }

  align <- rect_match_align(
    align = align,
    choices = c("bottom", "top"),
    synonyms = list(
      down = "bottom",
      below = "bottom",
      b = "bottom",
      up = "top",
      above = "top",
      t = "top"
    )
  )

  rect_construct(
    data = data,
    value = value,
    value_col = value_col,
    aspect_ratio = aspect_ratio,
    gap = gap,
    padding = padding,
    plot_type = "row",
    layout_fun = function(width, height, gap) {
      rect_layout_row(
        width = width,
        height = height,
        gap = gap,
        align = align
      )
    },
    settings = list(
      align = align
    )
  )
}


#' Create a pyramid layout of rectangles
#'
#' Creates a pyramid layout where rectangles are stacked symmetrically.
#' Rectangle areas are proportional to the supplied numeric values.
#' Values can be supplied directly with `value` or taken from a column
#' in `data` using `value_col`.
#'
#' The returned plot can be further customised by adding Rectangler layers,
#' such as `rect_style()`, `rect_label()`, `rect_shape()`,
#' `rect_shape_label()`, or `rect_annotation()`.
#'
#' @param data Optional data frame containing one row for each rectangle.
#'   If omitted, supply rectangle values directly with `value`.
#' @param value Numeric value or vector of values used to determine rectangle
#'   areas.
#' @param value_col Name of the column in `data` containing rectangle values.
#' @param aspect_ratio Desired rectangle aspect ratio.
#'   Can be `"square"`, `"golden"`, a ratio string such as `"1:2"`,
#'   or a numeric vector such as `c(1, 2)`.
#' @param gap Relative spacing between rectangles.
#' @param padding Relative padding around the complete layout.
#'
#' @return
#' A Rectangler plot object (a `ggplot`) that can be extended with
#' additional Rectangler layer functions.
#'
#' @examples
#' rect_pyr(value = c(10, 20, 30, 40))
#'
#' rect_pyr(rect_data_demo, value_col = "value")
#'
#' @export
rect_pyr <- function(data = NULL,
                     value = NULL,
                     value_col = "value",
                     aspect_ratio = "square",
                     gap = rect_defaults$gap,
                     padding = rect_defaults$padding) {

  if (is.null(data) && is.null(value)) {
    stop(
      "Supply either `data` with `value_col`, or supply `value`.",
      call. = FALSE
    )
  }

  if (!is.null(value) && missing(value_col)) {
    value_col <- NULL
  }

  rect_construct(
    data = data,
    value = value,
    value_col = value_col,
    aspect_ratio = aspect_ratio,
    gap = gap,
    padding = padding,
    plot_type = "pyr",
    layout_fun = rect_layout_pyr
  )
}

