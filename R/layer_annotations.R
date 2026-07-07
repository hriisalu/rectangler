
#' Add annotations to rectangles
#'
#' Adds annotation text outside or near rectangles in a Rectangler plot.
#' Annotation content and appearance can be set directly or mapped from columns
#' in the original data.
#'
#' @param plot A Rectangler plot created with `rect_plot4()`, `rect_row()`,
#'   `rect_col()`, or `rect_pyr()`.
#' @param label Annotation text.
#' @param label_col Name of the column containing annotation text.
#' @param position Annotation position. If `NULL`, a default position is chosen
#'   based on the plot type.
#' @param offset_x Horizontal offset relative to rectangle width.
#' @param offset_y Vertical offset relative to rectangle height.
#' @param angle Text angle.
#' @param space Relative space added around the plot for annotations.
#' @param hjust Horizontal justification. If `NULL`, it is chosen automatically.
#' @param lineheight Line height for multi-line annotation text.
#' @param size Text size.
#' @param size_col Name of the column containing text sizes.
#' @param colour Text colour.
#' @param colour_col Name of the column containing text colours.
#' @param family Font family.
#' @param fontface Font face.
#'
#' @return
#' A Rectangler plot object with an added annotation layer.
#'
#' @examples
#' rect_plot4() %>%
#'   rect_annotation()
#'
#' rect_plot4(rect_data_demo) %>%
#'   rect_annotation(position = "vertical", space = 0.2)
#'
#' @export
rect_annotation <- function(plot,
                            label = NULL,
                            label_col = NULL,
                            position = NULL,
                            offset_x = 0.1,
                            offset_y = 0.1,
                            angle = 0,
                            space = 1,
                            hjust = NULL,
                            lineheight = 0.9,
                            size = NULL,
                            size_col = NULL,
                            colour = NULL,
                            colour_col = NULL,
                            family = NULL,
                            fontface = NULL) {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  info <- rect_info(plot)
  layout <- info$layout
  n <- nrow(layout)

  if (is.null(position)) {
    position <- switch(
      info$plot_type,
      plot4 = "vertical",
      row = "top",
      col = "left",
      pyr = "left"
    )
  }

  position <- rect_match_annotation_position(position, info$plot_type)

  if (is.null(hjust) && angle %in% c(90, 270)) {
    hjust <- 0.5
  }

  if (is.null(label) &&
      is.null(label_col) &&
      !"annotation" %in% names(layout)) {
    return(plot)
  }

  text <- rect_prepare_text(
    layout = layout,
    n = n,
    label = label,
    label_col = label_col,
    default_label_col = "annotation",
    size = size,
    size_col = size_col,
    default_size = rect_defaults$text_size,
    colour = colour,
    colour_col = colour_col,
    family = family,
    fontface = fontface
  )

  annotation_data <- layout
  annotation_data$.rect_annotation <- text$label
  annotation_data$.rect_text_size <- text$size
  annotation_data$.rect_text_colour <- text$colour
  annotation_data$.rect_text_family <- text$family
  annotation_data$.rect_text_fontface <- text$fontface

  if (position == "vertical") {
    annotation_data$.rect_annotation_x <- (annotation_data$xmin + annotation_data$xmax) / 2

    annotation_data$.rect_annotation_y <- dplyr::if_else(
      annotation_data$.rect_side_v == "top",
      annotation_data$ymax + offset_y * annotation_data$height,
      annotation_data$ymin - offset_y * annotation_data$height
    )

    annotation_data$.rect_annotation_hjust <- 0.5

    annotation_data$.rect_annotation_vjust <- dplyr::if_else(
      annotation_data$.rect_side_v == "top",
      0,
      1
    )
  }

  if (position == "horizontal") {
    annotation_data$.rect_annotation_x <- dplyr::if_else(
      annotation_data$.rect_side_h == "left",
      annotation_data$xmin - offset_x * annotation_data$width,
      annotation_data$xmax + offset_x * annotation_data$width
    )

    annotation_data$.rect_annotation_y <- (annotation_data$ymin + annotation_data$ymax) / 2

    annotation_data$.rect_annotation_hjust <- dplyr::if_else(
      annotation_data$.rect_side_h == "left",
      1,
      0
    )

    annotation_data$.rect_annotation_vjust <- 0.5
  }

  if (position == "top") {
    annotation_data$.rect_annotation_x <- (annotation_data$xmin + annotation_data$xmax) / 2
    annotation_data$.rect_annotation_y <- annotation_data$ymax + offset_y * annotation_data$height
    annotation_data$.rect_annotation_hjust <- 0.5
    annotation_data$.rect_annotation_vjust <- 0
  }

  if (position == "bottom") {
    annotation_data$.rect_annotation_x <- (annotation_data$xmin + annotation_data$xmax) / 2
    annotation_data$.rect_annotation_y <- annotation_data$ymin - offset_y * annotation_data$height
    annotation_data$.rect_annotation_hjust <- 0.5
    annotation_data$.rect_annotation_vjust <- 1
  }

  if (position == "left") {
    annotation_data$.rect_annotation_x <- annotation_data$xmin - offset_x * annotation_data$width
    annotation_data$.rect_annotation_y <- (annotation_data$ymin + annotation_data$ymax) / 2
    annotation_data$.rect_annotation_hjust <- 1
    annotation_data$.rect_annotation_vjust <- 0.5
  }

  if (position == "right") {
    annotation_data$.rect_annotation_x <- annotation_data$xmax + offset_x * annotation_data$width
    annotation_data$.rect_annotation_y <- (annotation_data$ymin + annotation_data$ymax) / 2
    annotation_data$.rect_annotation_hjust <- 0
    annotation_data$.rect_annotation_vjust <- 0.5
  }

  if (!is.null(hjust)) {
    annotation_data$.rect_annotation_hjust <- rect_recycle(hjust, n)
  }

  settings <- info$settings
  limits <- settings$limits

  annotation_space <- rect_annotation_space(
    annotation_data = annotation_data,
    limits = limits,
    position = position,
    space = space
  )

  settings$limits <- rect_expand_limits(
    limits = limits,
    left = annotation_space$left,
    right = annotation_space$right,
    top = annotation_space$top,
    bottom = annotation_space$bottom
  )

  plot <- plot +
    ggplot2::geom_text(
      data = annotation_data,
      ggplot2::aes(
        x = .data[[".rect_annotation_x"]],
        y = .data[[".rect_annotation_y"]],
        label = .data[[".rect_annotation"]],
        size = .data[[".rect_text_size"]],
        colour = .data[[".rect_text_colour"]],
        family = .data[[".rect_text_family"]],
        fontface = .data[[".rect_text_fontface"]],
        hjust = .data[[".rect_annotation_hjust"]],
        vjust = .data[[".rect_annotation_vjust"]]
      ),
      angle = angle,
      lineheight = lineheight,
      inherit.aes = FALSE,
      show.legend = FALSE
    )

  plot <- rect_add_identity_scale(plot, "size")
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
