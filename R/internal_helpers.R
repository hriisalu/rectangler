# rect_utils

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

rect_recycle <- function(x, n) {
  if (length(x) == 0) return(rep(NA, n))
  if (length(x) == 1) return(rep(x, n))
  rep_len(x, n)
}

rect_ratio <- function(aspect_ratio = "square") {

  if (is.character(aspect_ratio)) {
    if (aspect_ratio == "square") return(c(1, 1))
    if (aspect_ratio == "golden") return(c(1.618, 1))

    if (grepl(":", aspect_ratio)) {
      return(as.numeric(strsplit(aspect_ratio, ":")[[1]]))
    }
  }

  if (is.numeric(aspect_ratio) && length(aspect_ratio) == 2) {
    return(aspect_ratio)
  }

  stop("aspect_ratio must be 'square', 'golden', '1:2', or c(1, 2).", call. = FALSE)
}

rect_sides <- function(value, aspect_ratio = "square") {

  ratio <- rect_ratio(aspect_ratio)

  width_prop <- ratio[1]
  height_prop <- ratio[2]

  height <- sqrt((height_prop / width_prop) * value)
  width <- value / height

  data.frame(
    width = width,
    height = height
  )
}

rect_limits <- function(layout, padding = 0.05) {

  xr <- range(c(layout$xmin, layout$xmax), na.rm = TRUE)
  yr <- range(c(layout$ymin, layout$ymax), na.rm = TRUE)

  pad <- max(diff(xr), diff(yr)) * padding

  list(
    x = xr + c(-pad, pad),
    y = yr + c(-pad, pad),
    pad = pad
  )
}
