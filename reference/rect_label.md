# Add labels to rectangles

Adds text labels to the centre of each rectangle in a Rectangler plot.
Label content and appearance can be set directly or mapped from columns
in the original data.

## Usage

``` r
rect_label(
  plot,
  label = NULL,
  label_col = NULL,
  size = NULL,
  lineheight = 0.9,
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

- label:

  Label text.

- label_col:

  Name of the column containing label text.

- size:

  Text size.

- lineheight:

  Line height for multi-line labels.

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

A Rectangler plot object with an added label layer.

## Examples

``` r
rect_plot4() %>%
  rect_label()


rect_plot4(rect_data_demo) %>%
  rect_label(size = 5, colour = "white")

```
