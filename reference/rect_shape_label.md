# Add labels to shapes

Adds text labels at the same positions used by
[`rect_shape()`](https://hriisalu.github.io/rectangler/reference/rect_shape.md).
Label content and appearance can be set directly or mapped from columns
in the original data.

## Usage

``` r
rect_shape_label(
  plot,
  position = NULL,
  offset_x = 0,
  offset_y = 0,
  label = NULL,
  label_col = NULL,
  lineheight = 0.9,
  size = NULL,
  size_col = NULL,
  colour = NULL,
  color = NULL,
  colour_col = NULL,
  color_col = NULL,
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

- position:

  Label position. If `NULL`, the default is `"corner"` for
  [`rect_plot4()`](https://hriisalu.github.io/rectangler/reference/rect_plot4.md)
  and `"top-right"` for other layouts.

- offset_x:

  Horizontal offset relative to rectangle width.

- offset_y:

  Vertical offset relative to rectangle height.

- label:

  Label text.

- label_col:

  Name of the column containing label text.

- lineheight:

  Line height for multi-line labels.

- size:

  Text size.

- size_col:

  Name of the column containing text sizes.

- colour:

  Text colour.

- color:

  Alias for `colour`.

- colour_col:

  Name of the column containing text colours.

- color_col:

  Alias for `colour_col`.

- family:

  Font family.

- fontface:

  Font face.

## Value

A Rectangler plot object with an added shape label layer.

## Examples

``` r
rect_plot4(rect_data_demo) %>%
  rect_shape_label()


rect_plot4(rect_data_demo) %>%
  rect_shape_label(label = c("A", "B", "C", "D"))

```
