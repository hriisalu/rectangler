rect_plot4 <- function(data = rect_data_demo,
                       value_col = "value",
                       aspect_ratio = "square",
                       gap = 0.05,
                       padding = 0.05) {

  rect_check_plot4_data(data, value_col)

  data <- data[1:4, ]

  sides <- rect_sides(
    value = data[[value_col]],
    aspect_ratio = aspect_ratio
  )

  gap_abs <- mean(c(sides$width, sides$height), na.rm = TRUE) * gap

  layout <- cbind(
    data,
    sides,
    rect_layout_plot4(
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
    ggplot2::scale_x_continuous(limits = limits$x, expand = ggplot2::expansion(mult = 0)) +
    ggplot2::scale_y_continuous(limits = limits$y, expand = ggplot2::expansion(mult = 0)) +
    ggplot2::theme_void()

  p <- rect_metadata(
    p = p,
    plot_type = "plot4",
    layout = layout,
    settings = list(
      value_col = value_col,
      aspect_ratio = aspect_ratio,
      gap = gap,
      gap_abs = gap_abs,
      padding = padding,
      limits = limits,
      base_fill = "grey85",
      base_colour = "white",
      base_linewidth = 0.5
    )
  )

  p
}
