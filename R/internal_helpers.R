# rect_utils

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

rect_recycle <- function(x, n) {
  if (length(x) == 0) return(rep(NA, n))
  if (length(x) == 1) return(rep(x, n))
  rep_len(x, n)
}

rect_size <- function(size, default) {

  if (is.null(size)) {
    return(default)
  }

  default * size
}

rect_has_scale <- function(plot, aesthetic) {

  if (!inherits(plot, "ggplot")) {
    return(FALSE)
  }

  aesthetic <- switch(
    aesthetic,
    color = "colour",
    aesthetic
  )

  !is.null(plot$scales$get_scales(aesthetic))
}

rect_add_identity_scale <- function(plot, aesthetic) {

  aesthetic <- switch(
    aesthetic,
    color = "colour",
    aesthetic
  )

  if (rect_has_scale(plot, aesthetic)) {
    return(plot)
  }

  switch(
    aesthetic,
    fill = plot + ggplot2::scale_fill_identity(),
    colour = plot + ggplot2::scale_colour_identity(),
    linewidth = plot + ggplot2::scale_linewidth_identity(),
    linetype = plot + ggplot2::scale_linetype_identity(),
    alpha = plot + ggplot2::scale_alpha_identity(),
    shape = plot + ggplot2::scale_shape_identity(),
    size = plot + ggplot2::scale_size_identity(),
    plot
  )
}

rect_prepare_value <- function(data,
                               value = NULL,
                               value_col = NULL,
                               default = NULL,
                               n = nrow(data),
                               arg = "value",
                               size = FALSE) {

  # read values from data column
  # if both value and value_col are supplied, value_col wins
  if (!is.null(value_col)) {

    if (!value_col %in% names(data)) {
      stop(
        sprintf("`%s_col` must be a column in the plot data.", arg),
        call. = FALSE
      )
    }

    value <- data[[value_col]]
  }

  # default value
  if (is.null(value)) {
    value <- rep(default, n)
  } else {
    value <- rect_recycle(value, n)
  }

  # convert relative sizes if requested
  if (isTRUE(size)) {
    value <- rect_size(value, default)
  }

  value
}

rect_text_size <- function(size) {
  size * 3
}

rect_prepare_text <- function(layout,
                              n,
                              label = NULL,
                              label_col = NULL,
                              default_label_col = "label",
                              size = NULL,
                              size_col = NULL,
                              default_size = rect_defaults$text_size,
                              colour = NULL,
                              colour_col = NULL,
                              family = NULL,
                              fontface = NULL) {

  if (is.null(label) &&
      is.null(label_col) &&
      default_label_col %in% names(layout)) {
    label_col <- default_label_col
  }

  label <- rect_prepare_value(
    data = layout,
    value = label,
    value_col = label_col,
    default = "",
    n = n,
    arg = "label"
  )

  size <- rect_prepare_value(
    data = layout,
    value = size,
    value_col = size_col,
    default = default_size,
    n = n,
    arg = "size"
  )

  size <- rect_text_size(size)

  colour <- rect_prepare_value(
    data = layout,
    value = colour,
    value_col = colour_col,
    default = rect_defaults$text_colour,
    n = n,
    arg = "colour"
  )

  family <- family %||% rect_defaults$text_family
  fontface <- fontface %||% rect_defaults$text_fontface

  list(
    label = label,
    size = size,
    colour = colour,
    family = family,
    fontface = fontface
  )
}

rect_colour <- function(colour = NULL, color = NULL) {
  colour %||% color
}
