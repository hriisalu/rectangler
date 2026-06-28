rect_style <- function(plot,
                       fill = NULL,
                       colour = NULL,
                       linewidth = NULL,
                       linetype = NULL,
                       alpha = NULL) {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  info <- rect_info(plot)
  layout <- info$layout
  n <- nrow(layout)

  fill <- if (is.null(fill)) rep("grey85", n) else rect_recycle(fill, n)
  colour <- if (is.null(colour)) rep("white", n) else rect_recycle(colour, n)
  linewidth <- if (is.null(linewidth)) rep(0.5, n) else rect_recycle(linewidth, n)
  linetype <- if (is.null(linetype)) rep("solid", n) else rect_recycle(linetype, n)
  alpha <- if (is.null(alpha)) rep(1, n) else rect_recycle(alpha, n)

  style_data <- layout
  style_data$.rect_fill <- fill
  style_data$.rect_colour <- colour
  style_data$.rect_linewidth <- linewidth
  style_data$.rect_linetype <- linetype
  style_data$.rect_alpha <- alpha

  plot <- plot +
    ggplot2::geom_rect(
      data = style_data,
      ggplot2::aes(
        xmin = xmin,
        xmax = xmax,
        ymin = ymin,
        ymax = ymax,
        fill = .rect_fill,
        colour = .rect_colour,
        linewidth = .rect_linewidth,
        linetype = .rect_linetype,
        alpha = .rect_alpha
      ),
      inherit.aes = FALSE,
      show.legend = FALSE
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_colour_identity() +
    ggplot2::scale_linewidth_identity() +
    ggplot2::scale_linetype_identity() +
    ggplot2::scale_alpha_identity()

  rect_metadata(
    p = plot,
    plot_type = info$plot_type,
    layout = info$layout,
    settings = info$settings
  )
}
