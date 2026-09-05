#' Style rectangles
#'
#' Changes the fill, border, and transparency of rectangles in a Rectangler plot.
#' Values can be set directly or mapped from columns in the original data.
#'
#' @param plot A Rectangler plot created with `rect_plot4()`, `rect_row()`,
#'   `rect_col()`, or `rect_pyr()`.
#' @param fill Rectangle fill colour.
#' @param fill_col Name of the column containing rectangle fill colours.
#' @param border_colour Rectangle border colour.
#' @param border_color Alias for `border_colour`.
#' @param border_colour_col Name of the column containing rectangle border colours.
#' @param border_color_col Alias for `border_colour_col`.
#' @param border_width Rectangle border width.
#' @param border_width_col Name of the column containing rectangle border widths.
#' @param border_type Rectangle border line type.
#' @param border_type_col Name of the column containing rectangle border line types.
#' @param alpha Rectangle transparency.
#' @param alpha_col Name of the column containing rectangle transparency values.
#'
#' @return
#' A Rectangler plot object with updated rectangle styling.
#'
#' @examples
#' rect_plot4(rect_data_demo) %>%
#'   rect_style(fill = "grey90", border_colour = "white")
#'
#' rect_plot4(rect_data_demo) %>%
#'   rect_style(fill_col = "fill")
#'
#' @export
rect_style <- function(plot,
                       fill = NULL,
                       fill_col = NULL,
                       border_colour = NULL,
                       border_color = NULL,
                       border_colour_col = NULL,
                       border_color_col = NULL,
                       border_width = NULL,
                       border_width_col = NULL,
                       border_type = NULL,
                       border_type_col = NULL,
                       alpha = NULL,
                       alpha_col = NULL) {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  border_colour <- rect_colour(border_colour, border_color)
  border_colour_col <- rect_colour(border_colour_col, border_color_col)

  info <- rect_info(plot)
  layout <- info$layout
  n <- nrow(layout)

  fill <- rect_prepare_value(
    data = layout,
    value = fill,
    value_col = fill_col,
    default = info$settings$base_fill,
    n = n,
    arg = "fill"
  )

  border_colour <- rect_prepare_value(
    data = layout,
    value = border_colour,
    value_col = border_colour_col,
    default = info$settings$base_border_colour,
    n = n,
    arg = "border_colour"
  )

  border_width <- rect_prepare_value(
    data = layout,
    value = border_width,
    value_col = border_width_col,
    default = info$settings$base_border_width,
    n = n,
    arg = "border_width",
    size = TRUE
  )

  border_type <- rect_prepare_value(
    data = layout,
    value = border_type,
    value_col = border_type_col,
    default = info$settings$base_border_type,
    n = n,
    arg = "border_type"
  )

  alpha <- rect_prepare_value(
    data = layout,
    value = alpha,
    value_col = alpha_col,
    default = info$settings$base_alpha,
    n = n,
    arg = "alpha"
  )

  style_data <- layout
  style_data$.rect_fill <- fill
  style_data$.rect_border_colour <- border_colour
  style_data$.rect_border_width <- border_width
  style_data$.rect_border_type <- border_type
  style_data$.rect_alpha <- alpha

  plot <- plot +
    ggplot2::geom_rect(
      data = style_data,
      ggplot2::aes(
        xmin = .data[["xmin"]],
        xmax = .data[["xmax"]],
        ymin = .data[["ymin"]],
        ymax = .data[["ymax"]],
        fill = .data[[".rect_fill"]],
        colour = .data[[".rect_border_colour"]],
        linewidth = .data[[".rect_border_width"]],
        linetype = .data[[".rect_border_type"]],
        alpha = .data[[".rect_alpha"]]
      ),
      inherit.aes = FALSE,
      show.legend = FALSE
    )

  plot <- rect_add_identity_scale(plot, "fill")
  plot <- rect_add_identity_scale(plot, "colour")
  plot <- rect_add_identity_scale(plot, "linewidth")
  plot <- rect_add_identity_scale(plot, "linetype")
  plot <- rect_add_identity_scale(plot, "alpha")

  rect_metadata(
    p = plot,
    plot_type = info$plot_type,
    layout = info$layout,
    settings = info$settings
  )
}
