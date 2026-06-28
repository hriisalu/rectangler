rect_metadata <- function(p, plot_type, layout, settings = list()) {
  attr(p, "rectangler") <- list(
    type = "rectangler",
    plot_type = plot_type,
    layout = layout,
    settings = settings
  )

  p
}


rect_info <- function(p) {
  attr(p, "rectangler")
}
