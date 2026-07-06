rect_ratio <- function(aspect_ratio = "square") {

  if (is.null(aspect_ratio)) {
    return(c(1, 1))
  }

  if (identical(aspect_ratio, "square")) {
    return(c(1, 1))
  }

  if (identical(aspect_ratio, "golden")) {
    return(c(1.618, 1))
  }

  if (is.character(aspect_ratio) && length(aspect_ratio) == 1) {

    if (!grepl("^\\s*[0-9.]+\\s*:\\s*[0-9.]+\\s*$", aspect_ratio)) {
      stop("`aspect_ratio` must be \"square\", \"golden\", a positive number, or a ratio like \"1:2\".", call. = FALSE)
    }

    ratio <- as.numeric(strsplit(aspect_ratio, ":", fixed = TRUE)[[1]])

  } else if (is.numeric(aspect_ratio) && length(aspect_ratio) == 1) {

    ratio <- c(aspect_ratio, 1)

  } else if (is.numeric(aspect_ratio) && length(aspect_ratio) == 2) {

    ratio <- aspect_ratio

  } else {
    stop("`aspect_ratio` must be \"square\", \"golden\", a positive number, or a ratio like \"1:2\".", call. = FALSE)
  }

  if (any(!is.finite(ratio)) || any(ratio <= 0)) {
    stop("`aspect_ratio` must define a positive finite ratio.", call. = FALSE)
  }

  ratio
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


rect_layout_plot4 <- function(width,
                              height,
                              gap = 0.05) {

  data.frame(

    xmin = c(
      -width[1] - gap/2,
      gap/2,
      -width[3] - gap/2,
      gap/2
    ),

    xmax = c(
      -gap/2,
      width[2] + gap/2,
      -gap/2,
      width[4] + gap/2
    ),

    ymin = c(
      gap/2,
      gap/2,
      -height[3] - gap/2,
      -height[4] - gap/2
    ),

    ymax = c(
      height[1] + gap/2,
      height[2] + gap/2,
      -gap/2,
      -gap/2
    ),

    .rect_side_v = c("top", "top", "bottom", "bottom"),

    .rect_side_h = c("left", "right", "left", "right")
  )
}




rect_layout_col <- function(width,
                            height,
                            gap = 0.05,
                            align = "left") {

  align <- rect_match_align(
    align = align,
    choices = c("left", "right"),
    synonyms = list(
      l = "left",
      r = "right"
    )
  )

  ymax <- c(
    0,
    -cumsum(height[-length(height)] + gap)
  )

  if (align == "left") {
    xmin <- rep(0, length(width))
    xmax <- width
  } else {
    xmin <- -width
    xmax <- rep(0, length(width))
  }

  data.frame(
    xmin = xmin,
    xmax = xmax,
    ymin = ymax - height,
    ymax = ymax
  )
}


rect_layout_row <- function(width,
                            height,
                            gap = 0.05,
                            align = "bottom") {

  align <- rect_match_align(
    align = align,
    choices = c("bottom", "top"),
    synonyms = list(
      down = "bottom",
      below = "bottom",
      b = "bottom",
      up = "top",
      above = "top",
      t = "top"
    )
  )

  xmin <- c(
    0,
    cumsum(width[-length(width)] + gap)
  )

  if (align == "bottom") {
    ymin <- rep(0, length(height))
    ymax <- height
  } else {
    ymin <- -height
    ymax <- rep(0, length(height))
  }

  data.frame(
    xmin = xmin,
    xmax = xmin + width,
    ymin = ymin,
    ymax = ymax
  )
}


rect_layout_pyr <- function(width,
                            height,
                            gap = 0.05) {

  ymax <- c(
    0,
    -cumsum(height[-length(height)] + gap)
  )

  data.frame(
    xmin = -width / 2,
    xmax = width / 2,
    ymin = ymax - height,
    ymax = ymax
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

