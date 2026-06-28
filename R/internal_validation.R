rect_is_rectangler <- function(p) {
  inherits(p, "ggplot") &&
    !is.null(rect_info(p)) &&
    identical(rect_info(p)$type, "rectangler")
}


rect_check_plot4_data <- function(data, value_col) {
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }

  if (!value_col %in% names(data)) {
    stop("`value_col` must be a column in `data`.", call. = FALSE)
  }

  if (nrow(data) < 4) {
    stop("`data` must contain at least four rows.", call. = FALSE)
  }

  if (!is.numeric(data[[value_col]])) {
    stop("`value_col` must be numeric.", call. = FALSE)
  }

  invisible(TRUE)
}
