rect_is_rectangler <- function(p) {
  inherits(p, "ggplot") &&
    !is.null(rect_info(p)) &&
    identical(rect_info(p)$type, "rectangler")
}


rect_check_values <- function(data, value = NULL, value_col = NULL, min_rows = 1) {

  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }

  if (nrow(data) < min_rows) {
    stop(
      sprintf("`data` must contain at least %s row%s.",
              min_rows,
              if (min_rows == 1) "" else "s"),
      call. = FALSE
    )
  }

  if (!is.null(value_col)) {

    if (!value_col %in% names(data)) {
      stop("`value_col` must be a column in `data`.", call. = FALSE)
    }

    values <- data[[value_col]]

  } else if (!is.null(value)) {

    values <- value

  } else {

    stop("Supply either `value` or `value_col`.", call. = FALSE)
  }

  if (!is.numeric(values)) {
    stop("Rectangle values must be numeric.", call. = FALSE)
  }

  if (!(length(values) %in% c(1, nrow(data)))) {
    stop(
      "`value` must have length 1 or one value per row in `data`.",
      call. = FALSE
    )
  }

  invisible(TRUE)
}


rect_check_plot4_data <- function(data, value = NULL, value_col = NULL) {

  rect_check_values(
    data = data,
    value = value,
    value_col = value_col,
    min_rows = 4
  )
}


rect_check_data <- function(data, value = NULL, value_col = NULL) {

  rect_check_values(
    data = data,
    value = value,
    value_col = value_col,
    min_rows = 1
  )
}


rect_match_align <- function(align, choices, synonyms = list()) {
  align <- tolower(as.character(align)[1])

  if (align %in% names(synonyms)) {
    align <- synonyms[[align]]
  }

  if (!align %in% choices) {
    stop(
      "`align` must be one of: ",
      paste(choices, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  align
}


rect_match_shape_position <- function(position, plot_type) {

  position <- tolower(as.character(position)[1])

  synonyms <- list(
    l = "left",
    r = "right",
    t = "top",
    b = "bottom",
    up = "top",
    down = "bottom",
    above = "top",
    below = "bottom",
    middle = "center",

    left_center = "left",
    right_center = "right",
    top_center = "top",
    bottom_center = "bottom",
    "left-center" = "left",
    "right-center" = "right",
    "top-center" = "top",
    "bottom-center" = "bottom"
  )

  if (position %in% names(synonyms)) {
    position <- synonyms[[position]]
  }

  if (position == "corner" && plot_type != "plot4") {
    position <- "top-left"
  }

  choices <- switch(
    plot_type,
    plot4 = c(
      "corner",
      "top-left",
      "top-right",
      "bottom-left",
      "bottom-right",
      "left-right",
      "top-bottom",
      "left",
      "right",
      "top",
      "bottom",
      "center"
    ),
    row = c(
      "top-left",
      "top-right",
      "bottom-left",
      "bottom-right",
      "left",
      "right",
      "top",
      "bottom",
      "center"
    ),
    col = c(
      "top-left",
      "top-right",
      "bottom-left",
      "bottom-right",
      "left",
      "right",
      "top",
      "bottom",
      "center"
    ),
    pyr = c(
      "top-left",
      "top-right",
      "bottom-left",
      "bottom-right",
      "left",
      "right",
      "top",
      "bottom",
      "center"
    ),
    stop("Unknown plot type.", call. = FALSE)
  )

  if (!position %in% choices) {
    stop(
      "`position` must be one of: ",
      paste(choices, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  position
}

rect_match_annotation_position <- function(position, plot_type) {

  position <- tolower(as.character(position)[1])

  synonyms <- list(
    l = "left",
    r = "right",
    t = "top",
    b = "bottom",

    up = "top",
    down = "bottom",
    above = "top",
    below = "bottom",

    v = "vertical",
    vert = "vertical",
    vertical = "vertical",
    "top-bottom" = "vertical",
    "top_down" = "vertical",
    "top-down" = "vertical",
    "up-down" = "vertical",
    "up_below" = "vertical",
    "up-below" = "vertical",

    h = "horizontal",
    hor = "horizontal",
    horizontal = "horizontal",
    horisontal = "horizontal",
    "left-right" = "horizontal",
    "left_right" = "horizontal",
    "right-left" = "horizontal",
    "right_left" = "horizontal"
  )

  if (position %in% names(synonyms)) {
    position <- synonyms[[position]]
  }

  choices <- switch(
    plot_type,
    plot4 = c("vertical", "horizontal"),
    row = c("top", "bottom"),
    col = c("left", "right"),
    pyr = c("top", "bottom", "left", "right"),
    stop("Unknown plot type.", call. = FALSE)
  )

  if (!position %in% choices) {
    stop(
      "`position` must be one of: ",
      paste(choices, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  position
}
