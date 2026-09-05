# Add annotations to rectangles

Adds annotation text outside or near rectangles in a Rectangler plot.
Annotation content and appearance can be set directly or mapped from
columns in the original data.

## Usage

``` r
rect_annotation(
  plot,
  label = NULL,
  label_col = NULL,
  position = NULL,
  offset_x = 0.1,
  offset_y = 0.1,
  angle = 0,
  space = 1,
  hjust = NULL,
  lineheight = 0.9,
  size = NULL,
  size_col = NULL,
  colour = NULL,
  colour_col = NULL,
  family = NULL,
  fontface = NULL
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

- label:

  Annotation text.

- label_col:

  Name of the column containing annotation text.

- position:

  Annotation position. If `NULL`, a default position is chosen based on
  the plot type.

- offset_x:

  Horizontal offset relative to rectangle width.

- offset_y:

  Vertical offset relative to rectangle height.

- angle:

  Text angle.

- space:

  Relative space added around the plot for annotations.

- hjust:

  Horizontal justification. If `NULL`, it is chosen automatically.

- lineheight:

  Line height for multi-line annotation text.

- size:

  Text size.

- size_col:

  Name of the column containing text sizes.

- colour:

  Text colour.

- colour_col:

  Name of the column containing text colours.

- family:

  Font family.

- fontface:

  Font face.

## Value

A Rectangler plot object with an added annotation layer.

## Examples

``` r
rect_plot4(value = c(10, 20, 30, 40)) %>%
  rect_annotation()


rect_plot4(rect_data_demo) %>%
  rect_annotation(position = "vertical", space = 0.2)

```
