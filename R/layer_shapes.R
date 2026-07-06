rect_shape_data_plot4 <- function(layout, position, offset_x, offset_y) {

  layout %>%
    dplyr::mutate(
      .rect_shape_x = dplyr::case_when(
        position == "corner" ~ dplyr::if_else(dplyr::row_number() %in% c(1, 3), xmin, xmax),
        position %in% c("top-left", "bottom-left") ~ xmin,
        position %in% c("top-right", "bottom-right") ~ xmax,
        position == "left-right" ~ dplyr::if_else(dplyr::row_number() %in% c(1, 3), xmin, xmax),
        position == "left" ~ xmin,
        position == "right" ~ xmax,
        TRUE ~ (xmin + xmax) / 2
      ),
      .rect_shape_y = dplyr::case_when(
        position == "corner" ~ dplyr::if_else(dplyr::row_number() %in% c(1, 2), ymax, ymin),
        position %in% c("top-left", "top-right") ~ ymax,
        position %in% c("bottom-left", "bottom-right") ~ ymin,
        position == "top-bottom" ~ dplyr::if_else(dplyr::row_number() %in% c(1, 2), ymax, ymin),
        position == "top" ~ ymax,
        position == "bottom" ~ ymin,
        TRUE ~ (ymin + ymax) / 2
      ),
      .rect_offset_x_sign = dplyr::case_when(
        position == "corner" & dplyr::row_number() %in% c(1, 3) ~ -1,
        position == "corner" & dplyr::row_number() %in% c(2, 4) ~ 1,
        position == "left-right" & dplyr::row_number() %in% c(1, 3) ~ -1,
        position == "left-right" & dplyr::row_number() %in% c(2, 4) ~ 1,
        position %in% c("top-left", "bottom-left", "left") ~ -1,
        position %in% c("top-right", "bottom-right", "right") ~ 1,
        TRUE ~ 1
      ),
      .rect_offset_y_sign = dplyr::case_when(
        position == "corner" & dplyr::row_number() %in% c(1, 2) ~ 1,
        position == "corner" & dplyr::row_number() %in% c(3, 4) ~ -1,
        position == "top-bottom" & dplyr::row_number() %in% c(1, 2) ~ 1,
        position == "top-bottom" & dplyr::row_number() %in% c(3, 4) ~ -1,
        position %in% c("top-left", "top-right", "top") ~ 1,
        position %in% c("bottom-left", "bottom-right", "bottom") ~ -1,
        TRUE ~ 1
      ),
      .rect_shape_x = .rect_shape_x + .rect_offset_x_sign * offset_x * width,
      .rect_shape_y = .rect_shape_y + .rect_offset_y_sign * offset_y * height
    )
}

rect_shape_data_linear <- function(layout, position, offset_x, offset_y) {

  layout %>%
    dplyr::mutate(
      .rect_shape_x = dplyr::case_when(
        position %in% c("top-left", "bottom-left") ~ xmin,
        position %in% c("top-right", "bottom-right") ~ xmax,
        position == "left" ~ xmin,
        position == "right" ~ xmax,
        TRUE ~ (xmin + xmax) / 2
      ),
      .rect_shape_y = dplyr::case_when(
        position %in% c("top-left", "top-right") ~ ymax,
        position %in% c("bottom-left", "bottom-right") ~ ymin,
        position == "top" ~ ymax,
        position == "bottom" ~ ymin,
        TRUE ~ (ymin + ymax) / 2
      ),
      .rect_offset_x_sign = dplyr::case_when(
        position %in% c("top-left", "bottom-left", "left") ~ -1,
        position %in% c("top-right", "bottom-right", "right") ~ 1,
        TRUE ~ 1
      ),
      .rect_offset_y_sign = dplyr::case_when(
        position %in% c("top-left", "top-right", "top") ~ 1,
        position %in% c("bottom-left", "bottom-right", "bottom") ~ -1,
        TRUE ~ 1
      ),
      .rect_shape_x = .rect_shape_x + .rect_offset_x_sign * offset_x * width,
      .rect_shape_y = .rect_shape_y + .rect_offset_y_sign * offset_y * height
    )
}

rect_shape_data_row <- function(layout, position, offset_x, offset_y) {

  rect_shape_data_linear(
    layout = layout,
    position = position,
    offset_x = offset_x,
    offset_y = offset_y
  )
}

rect_shape_data_col <- function(layout, position, offset_x, offset_y) {

  rect_shape_data_linear(
    layout = layout,
    position = position,
    offset_x = offset_x,
    offset_y = offset_y
  )
}

rect_shape_data_pyr <- function(layout, position, offset_x, offset_y) {

  rect_shape_data_linear(
    layout = layout,
    position = position,
    offset_x = offset_x,
    offset_y = offset_y
  )
}

rect_shape_data <- function(layout, position, plot_type, offset_x, offset_y) {

  switch(
    plot_type,
    plot4 = rect_shape_data_plot4(layout, position, offset_x, offset_y),
    row = rect_shape_data_row(layout, position, offset_x, offset_y),
    col = rect_shape_data_col(layout, position, offset_x, offset_y),
    pyr = rect_shape_data_pyr(layout, position, offset_x, offset_y),
    stop("Unknown plot type.", call. = FALSE)
  )
}

#' Add shapes to a Rectangler plot
#'
#' Adds one shape to each rectangle in a Rectangler plot. Shapes can be placed
#' inside or near the rectangles, and their appearance can be set directly or
#' mapped from columns in the original data.
#'
#' @param plot A Rectangler plot created with `rect_plot4()`, `rect_row()`,
#'   `rect_col()`, or `rect_pyr()`.
#' @param position Shape position. If `NULL`, the default is `"corner"` for
#'   `rect_plot4()` and `"top-right"` for other layouts.
#' @param offset_x Horizontal offset relative to rectangle width.
#' @param offset_y Vertical offset relative to rectangle height.
#' @param shape Shape value passed to `ggplot2::geom_point()`.
#' @param shape_col Name of the column containing shape values.
#' @param size Shape size.
#' @param size_col Name of the column containing shape sizes.
#' @param fill Shape fill colour.
#' @param fill_col Name of the column containing shape fill colours.
#' @param border_colour Shape border colour.
#' @param border_color Alias for `border_colour`.
#' @param border_colour_col Name of the column containing shape border colours.
#' @param border_color_col Alias for `border_colour_col`.
#' @param border_width Shape border width.
#' @param border_width_col Name of the column containing shape border widths.
#'
#' @return
#' A Rectangler plot object with an added shape layer.
#'
#' @examples
#' rect_plot4() %>%
#'   rect_shape()
#'
#' rect_plot4(rect_data_demo) %>%
#'   rect_shape(position = "top-right", shape = 21, fill = "white")
#'
#' @export
rect_shape <- function(plot,
                       position = NULL,
                       offset_x = 0,
                       offset_y = 0,
                       shape = NULL,
                       shape_col = NULL,
                       size = NULL,
                       size_col = NULL,
                       fill = NULL,
                       fill_col = NULL,
                       border_colour = NULL,
                       border_color = NULL,
                       border_colour_col = NULL,
                       border_color_col = NULL,
                       border_width = NULL,
                       border_width_col = NULL) {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  info <- rect_info(plot)
  layout <- info$layout
  settings <- info$settings
  n <- nrow(layout)

  border_colour <- rect_colour(border_colour, border_color)
  border_colour_col <- rect_colour(border_colour_col, border_color_col)

  if (is.null(position)) {
    position <- if (info$plot_type == "plot4") "corner" else "top-right"
  }

  position <- rect_match_shape_position(
    position = position,
    plot_type = info$plot_type
  )

  offset_x <- rect_recycle(offset_x, n)
  offset_y <- rect_recycle(offset_y, n)

  shape <- rect_prepare_value(
    data = layout,
    value = shape,
    value_col = shape_col,
    default = rect_defaults$shape,
    n = n,
    arg = "shape"
  )

  size <- rect_prepare_value(
    data = layout,
    value = size,
    value_col = size_col,
    default = rect_defaults$shape_size,
    n = n,
    arg = "size",
    size = TRUE
  )

  fill <- rect_prepare_value(
    data = layout,
    value = fill,
    value_col = fill_col,
    default = rect_defaults$shape_fill,
    n = n,
    arg = "fill"
  )

  border_colour <- rect_prepare_value(
    data = layout,
    value = border_colour,
    value_col = border_colour_col,
    default = rect_defaults$shape_border_colour,
    n = n,
    arg = "border_colour"
  )

  border_width <- rect_prepare_value(
    data = layout,
    value = border_width,
    value_col = border_width_col,
    default = rect_defaults$shape_border_width,
    n = n,
    arg = "border_width",
    size = TRUE
  )

  shape_data <- rect_shape_data(
    layout = layout,
    position = position,
    plot_type = info$plot_type,
    offset_x = offset_x,
    offset_y = offset_y
  )

  shape_data$.rect_shape <- shape
  shape_data$.rect_shape_size <- size
  shape_data$.rect_shape_fill <- fill
  shape_data$.rect_shape_border_colour <- border_colour
  shape_data$.rect_shape_border_width <- border_width

  space <- rect_shape_space(
    shape_data = shape_data,
    size = max(size, na.rm = TRUE),
    limits = settings$limits
  )

  settings$limits <- rect_expand_limits(
    limits = settings$limits,
    left = space$left,
    right = space$right,
    top = space$top,
    bottom = space$bottom
  )

  plot <- plot +
    ggplot2::geom_point(
      data = shape_data,
      ggplot2::aes(
        x = .data[[".rect_shape_x"]],
        y = .data[[".rect_shape_y"]],
        shape = .data[[".rect_shape"]],
        size = .data[[".rect_shape_size"]],
        fill = .data[[".rect_shape_fill"]],
        colour = .data[[".rect_shape_border_colour"]],
        stroke = .data[[".rect_shape_border_width"]]
      ),
      inherit.aes = FALSE,
      show.legend = FALSE
    )

  plot <- rect_add_identity_scale(plot, "shape")
  plot <- rect_add_identity_scale(plot, "size")
  plot <- rect_add_identity_scale(plot, "fill")
  plot <- rect_add_identity_scale(plot, "colour")

  plot <- rect_apply_limits(
    plot = plot,
    limits = settings$limits
  )

  rect_metadata(
    p = plot,
    plot_type = info$plot_type,
    layout = info$layout,
    settings = settings
  )
}
