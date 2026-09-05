
#' Add labels to rectangles
#'
#' Adds text labels to the centre of each rectangle in a Rectangler plot.
#' Label content and appearance can be set directly or mapped from columns
#' in the original data.
#'
#' @param plot A Rectangler plot created with `rect_plot4()`, `rect_row()`,
#'   `rect_col()`, or `rect_pyr()`.
#' @param label Label text.
#' @param label_col Name of the column containing label text.
#' @param size Text size.
#' @param lineheight Line height for multi-line labels.
#' @param size_col Name of the column containing text sizes.
#' @param colour Text colour.
#' @param color Alias for `colour`.
#' @param colour_col Name of the column containing text colours.
#' @param color_col Alias for `colour_col`.
#' @param family Font family.
#' @param fontface Font face.
#'
#' @return
#' A Rectangler plot object with an added label layer.
#'
#' @examples
#' rect_plot4(rect_data_demo) %>%
#'   rect_shape_label()
#'
#' rect_plot4(rect_data_demo) %>%
#'   rect_shape_label(label = c("A", "B", "C", "D"))
#'
#' @export
rect_label <- function(plot,
                       label = NULL,
                       label_col = NULL,
                       size = NULL,
                       lineheight = 0.9,
                       size_col = NULL,
                       colour = NULL,
                       color = NULL,
                       colour_col = NULL,
                       color_col = NULL,
                       family = NULL,
                       fontface = NULL) {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  info <- rect_info(plot)
  layout <- info$layout
  n <- nrow(layout)

  colour <- rect_colour(colour, color)
  colour_col <- rect_colour(colour_col, color_col)

  if (is.null(label) &&
      is.null(label_col) &&
      !"label" %in% names(layout)) {
    return(plot)
  }

  text <- rect_prepare_text(
    layout = layout,
    n = n,
    label = label,
    label_col = label_col,
    default_label_col = "label",
    size = size,
    size_col = size_col,
    colour = colour,
    colour_col = colour_col,
    family = family,
    fontface = fontface
  )

  label_data <- layout
  label_data$.rect_label <- text$label
  label_data$.rect_text_size <- text$size
  label_data$.rect_text_colour <- text$colour
  label_data$.rect_text_family <- text$family
  label_data$.rect_text_fontface <- text$fontface

  plot <- plot +
    ggplot2::geom_text(
      data = label_data,
      ggplot2::aes(
        x = (xmin + xmax) / 2,
        y = (ymin + ymax) / 2,
        label = .data[[".rect_label"]],
        size = .data[[".rect_text_size"]],
        colour = .data[[".rect_text_colour"]],
        family = .data[[".rect_text_family"]],
        fontface = .data[[".rect_text_fontface"]]
      ),
      lineheight = lineheight,
      inherit.aes = FALSE,
      show.legend = FALSE
    )

  plot <- rect_add_identity_scale(plot, "size")
  plot <- rect_add_identity_scale(plot, "colour")

  rect_metadata(
    p = plot,
    plot_type = info$plot_type,
    layout = info$layout,
    settings = info$settings
  )
}

#' Add labels to shapes
#'
#' Adds text labels at the same positions used by `rect_shape()`.
#' Label content and appearance can be set directly or mapped from columns
#' in the original data.
#'
#' @param plot A Rectangler plot created with `rect_plot4()`, `rect_row()`,
#'   `rect_col()`, or `rect_pyr()`.
#' @param position Label position. If `NULL`, the default is `"corner"` for
#'   `rect_plot4()` and `"top-right"` for other layouts.
#' @param offset_x Horizontal offset relative to rectangle width.
#' @param offset_y Vertical offset relative to rectangle height.
#' @param label Label text.
#' @param label_col Name of the column containing label text.
#' @param lineheight Line height for multi-line labels.
#' @param size Text size.
#' @param size_col Name of the column containing text sizes.
#' @param colour Text colour.
#' @param color Alias for `colour`.
#' @param colour_col Name of the column containing text colours.
#' @param color_col Alias for `colour_col`.
#' @param family Font family.
#' @param fontface Font face.
#'
#' @return
#' A Rectangler plot object with an added shape label layer.
#'
#' @examples
#' rect_plot4(rect_data_demo) %>%
#'   rect_shape_label()
#'
#' rect_plot4(rect_data_demo) %>%
#'   rect_shape_label(label = c("A", "B", "C", "D"))
#'
#' @export
rect_shape_label <- function(plot,
                             position = NULL,
                             offset_x = 0,
                             offset_y = 0,
                             label = NULL,
                             label_col = NULL,
                             lineheight = 0.9,
                             size = NULL,
                             size_col = NULL,
                             colour = NULL,
                             color = NULL,
                             colour_col = NULL,
                             color_col = NULL,
                             family = NULL,
                             fontface = NULL) {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  info <- rect_info(plot)
  layout <- info$layout
  n <- nrow(layout)

  colour <- rect_colour(colour, color)
  colour_col <- rect_colour(colour_col, color_col)

  if (is.null(label) &&
      is.null(label_col) &&
      !"shape_label" %in% names(layout)) {
    return(plot)
  }

  if (is.null(position)) {
    position <- if (info$plot_type == "plot4") "corner" else "top-right"
  }

  position <- rect_match_shape_position(
    position = position,
    plot_type = info$plot_type
  )

  offset_x <- rect_recycle(offset_x, n)
  offset_y <- rect_recycle(offset_y, n)

  text <- rect_prepare_text(
    layout = layout,
    n = n,
    label = label,
    label_col = label_col,
    default_label_col = "shape_label",
    size = size,
    size_col = size_col,
    colour = colour,
    colour_col = colour_col,
    family = family,
    fontface = fontface
  )

  label_data <- rect_shape_data(
    layout = layout,
    position = position,
    plot_type = info$plot_type,
    offset_x = offset_x,
    offset_y = offset_y
  )

  label_data$.rect_label <- text$label
  label_data$.rect_text_size <- text$size
  label_data$.rect_text_colour <- text$colour
  label_data$.rect_text_family <- text$family
  label_data$.rect_text_fontface <- text$fontface

  plot <- plot +
    ggplot2::geom_text(
      data = label_data,
      ggplot2::aes(
        x = .data[[".rect_shape_x"]],
        y = .data[[".rect_shape_y"]],
        label = .data[[".rect_label"]],
        size = .data[[".rect_text_size"]],
        colour = .data[[".rect_text_colour"]],
        family = .data[[".rect_text_family"]],
        fontface = .data[[".rect_text_fontface"]]
      ),
      lineheight = lineheight,
      inherit.aes = FALSE,
      show.legend = FALSE
    )

  plot <- rect_add_identity_scale(plot, "size")
  plot <- rect_add_identity_scale(plot, "colour")

  rect_metadata(
    p = plot,
    plot_type = info$plot_type,
    layout = info$layout,
    settings = info$settings
  )
}
