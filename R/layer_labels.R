rect_label <- function(plot,
                       label_text = NULL,
                       label_col = NULL,
                       size = 4,
                       colour = "black") {

  if (!rect_is_rectangler(plot)) {
    stop("`plot` must be a rectangler plot.", call. = FALSE)
  }

  info <- rect_info(plot)
  layout <- info$layout

  if (!is.null(label_col)) {
    label_text <- layout[[label_col]]
  }

  if (is.null(label_text)) {
    if ("label" %in% names(layout)) {
      label_text <- layout$label
    } else {
      return(plot)
    }
  }

  label_text <- rect_recycle(label_text, nrow(layout))

  plot <- plot +
    ggplot2::geom_text(
      data = layout,
      ggplot2::aes(
        x = (xmin + xmax) / 2,
        y = (ymin + ymax) / 2,
        label = label_text
      ),
      size = size,
      colour = colour,
      inherit.aes = FALSE
    )

  rect_metadata(
    p = plot,
    plot_type = info$plot_type,
    layout = info$layout,
    settings = info$settings
  )
}
