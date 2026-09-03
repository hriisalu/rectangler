# Add shapes to a Rectangler plot

Adds one shape to each rectangle in a Rectangler plot. Shapes can be
placed inside or near the rectangles, and their appearance can be set
directly or mapped from columns in the original data.

## Usage

``` r
rect_shape(
  plot,
  position = NULL,
  offset_x = 0,
  offset_y = 0,
  shape = NULL,
  shape_col = NULL,
  size = NULL,
  size_col = NULL,
  fill = NULL,
  fill_col = NULL,
  border_colour = NULL,
  border_color = NULL,
  border_colour_col = NULL,
  border_color_col = NULL,
  border_width = NULL,
  border_width_col = NULL
)
```

## Arguments

- plot:

  A Rectangler plot created with
  [`rect_plot4()`](https://hriisalu.github.io/rectangler/reference/rect_plot4.md),
  [`rect_row()`](https://hriisalu.github.io/rectangler/reference/rect_row.md),
  [`rect_col()`](https://hriisalu.github.io/rectangler/reference/rect_col.md),
  or
  [`rect_pyr()`](https://hriisalu.github.io/rectangler/reference/rect_pyr.md).

- position:

  Shape position. If `NULL`, the default is `"corner"` for
  [`rect_plot4()`](https://hriisalu.github.io/rectangler/reference/rect_plot4.md)
  and `"top-right"` for other layouts.

- offset_x:

  Horizontal offset relative to rectangle width.

- offset_y:

  Vertical offset relative to rectangle height.

- shape:

  Shape value passed to
  [`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html).

- shape_col:

  Name of the column containing shape values.

- size:

  Shape size.

- size_col:

  Name of the column containing shape sizes.

- fill:

  Shape fill colour.

- fill_col:

  Name of the column containing shape fill colours.

- border_colour:

  Shape border colour.

- border_color:

  Alias for `border_colour`.

- border_colour_col:

  Name of the column containing shape border colours.

- border_color_col:

  Alias for `border_colour_col`.

- border_width:

  Shape border width.

- border_width_col:

  Name of the column containing shape border widths.

## Value

A Rectangler plot object with an added shape layer.

## Examples

``` r
rect_plot4() %>%
  rect_shape()


rect_plot4(rect_data_demo) %>%
  rect_shape(position = "top-right", shape = 21, fill = "white")

```
