rect_expand_limits <- function(limits,
                               left = 0,
                               right = 0,
                               top = 0,
                               bottom = 0) {

  stopifnot(is.list(limits))
  stopifnot(all(c("x", "y", "pad") %in% names(limits)))

  limits$x[1] <- limits$x[1] - left
  limits$x[2] <- limits$x[2] + right

  limits$y[1] <- limits$y[1] - bottom
  limits$y[2] <- limits$y[2] + top

  limits
}

rect_apply_limits <- function(plot, limits) {

  exp_obj <- ggplot2::expansion(mult = 0)

  scale_x <- plot$scales$get_scales("x")
  if (!is.null(scale_x)) {
    scale_x$limits <- limits$x
    scale_x$expand <- exp_obj
  } else {
    plot <- plot +
      ggplot2::scale_x_continuous(
        limits = limits$x,
        expand = exp_obj
      )
  }

  scale_y <- plot$scales$get_scales("y")
  if (!is.null(scale_y)) {
    scale_y$limits <- limits$y
    scale_y$expand <- exp_obj
  } else {
    plot <- plot +
      ggplot2::scale_y_continuous(
        limits = limits$y,
        expand = exp_obj
      )
  }

  if (!is.null(plot$coordinates)) {
    plot$coordinates$clip <- "off"
  }

  plot
}

rect_shape_space <- function(shape_data,
                             size,
                             limits) {

  xr <- diff(limits$x)
  yr <- diff(limits$y)
  unit <- max(xr, yr, na.rm = TRUE)

  radius <- unit * size * 0.006

  list(
    left = max(0, limits$x[1] - min(shape_data$.rect_shape_x - radius, na.rm = TRUE)),
    right = max(0, max(shape_data$.rect_shape_x + radius, na.rm = TRUE) - limits$x[2]),
    bottom = max(0, limits$y[1] - min(shape_data$.rect_shape_y - radius, na.rm = TRUE)),
    top = max(0, max(shape_data$.rect_shape_y + radius, na.rm = TRUE) - limits$y[2])
  )
}


rect_annotation_space <- function(annotation_data,
                                  limits,
                                  position,
                                  space = 1) {

  base_space <- 0.6

  extra_x <- max(annotation_data$width, na.rm = TRUE) * base_space * space
  extra_y <- max(annotation_data$height, na.rm = TRUE) * base_space * space

  list(
    left = if (position %in% c("horizontal", "left")) extra_x else 0,
    right = if (position %in% c("horizontal", "right")) extra_x else 0,
    bottom = if (position %in% c("vertical", "bottom")) extra_y else 0,
    top = if (position %in% c("vertical", "top")) extra_y else 0
  )
}
