test_that("rect_match_align() accepts choices and synonyms", {
  expect_equal(
    rect_match_align("left", choices = c("left", "right")),
    "left"
  )

  expect_equal(
    rect_match_align(
      "l",
      choices = c("left", "right"),
      synonyms = list(l = "left", r = "right")
    ),
    "left"
  )

  expect_error(
    rect_match_align("middle", choices = c("left", "right")),
    "`align` must be one of"
  )
})

test_that("rect_match_shape_position() accepts shape position synonyms", {
  expect_equal(rect_match_shape_position("l", "plot4"), "left")
  expect_equal(rect_match_shape_position("r", "plot4"), "right")
  expect_equal(rect_match_shape_position("t", "plot4"), "top")
  expect_equal(rect_match_shape_position("b", "plot4"), "bottom")
  expect_equal(rect_match_shape_position("middle", "plot4"), "center")
  expect_equal(rect_match_shape_position("left-center", "plot4"), "left")
  expect_equal(rect_match_shape_position("top-center", "plot4"), "top")
})

test_that("rect_match_shape_position() handles corner for non-plot4 plots", {
  expect_equal(rect_match_shape_position("corner", "row"), "top-left")
  expect_equal(rect_match_shape_position("corner", "col"), "top-left")
  expect_equal(rect_match_shape_position("corner", "pyr"), "top-left")
})

test_that("rect_match_shape_position() errors on invalid position", {
  expect_error(
    rect_match_shape_position("banana", "plot4"),
    "`position` must be one of"
  )
})

test_that("rect_match_annotation_position() accepts plot4 synonyms", {
  expect_equal(rect_match_annotation_position("v", "plot4"), "vertical")
  expect_equal(rect_match_annotation_position("vert", "plot4"), "vertical")
  expect_equal(rect_match_annotation_position("top-down", "plot4"), "vertical")
  expect_equal(rect_match_annotation_position("up-below", "plot4"), "vertical")

  expect_equal(rect_match_annotation_position("h", "plot4"), "horizontal")
  expect_equal(rect_match_annotation_position("hor", "plot4"), "horizontal")
  expect_equal(rect_match_annotation_position("horisontal", "plot4"), "horizontal")
  expect_equal(rect_match_annotation_position("left-right", "plot4"), "horizontal")
})

test_that("rect_match_annotation_position() accepts row, col and pyr positions", {
  expect_equal(rect_match_annotation_position("above", "row"), "top")
  expect_equal(rect_match_annotation_position("below", "row"), "bottom")

  expect_equal(rect_match_annotation_position("l", "col"), "left")
  expect_equal(rect_match_annotation_position("r", "col"), "right")

  expect_equal(rect_match_annotation_position("top", "pyr"), "top")
  expect_equal(rect_match_annotation_position("bottom", "pyr"), "bottom")
  expect_equal(rect_match_annotation_position("left", "pyr"), "left")
  expect_equal(rect_match_annotation_position("right", "pyr"), "right")
})

test_that("rect_match_annotation_position() errors on invalid position", {
  expect_error(
    rect_match_annotation_position("left", "plot4"),
    "`position` must be one of"
  )

  expect_error(
    rect_match_annotation_position("banana", "row"),
    "`position` must be one of"
  )
})
