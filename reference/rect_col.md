# Create a column layout of rectangles

Creates a vertical layout where rectangles are stacked from top to
bottom. Rectangle areas are proportional to the values in `value_col`.
The returned plot can be further customised by adding Rectangler layers,
such as
[`rect_style()`](https://hriisalu.github.io/rectangler/reference/rect_style.md),
[`rect_label()`](https://hriisalu.github.io/rectangler/reference/rect_label.md),
[`rect_shape()`](https://hriisalu.github.io/rectangler/reference/rect_shape.md),
[`rect_shape_label()`](https://hriisalu.github.io/rectangler/reference/rect_shape_label.md),
or
[`rect_annotation()`](https://hriisalu.github.io/rectangler/reference/rect_annotation.md).

## Usage

``` r
rect_col(
  data = rect_data_demo,
  value_col = "value",
  aspect_ratio = "square",
  gap = rect_defaults$gap,
  padding = rect_defaults$padding,
  align = "left"
)
```

## Arguments

- data:

  A data frame containing one row for each rectangle.

- value_col:

  Name of the column containing rectangle values.

- aspect_ratio:

  Desired rectangle aspect ratio. Can be `"square"`, `"golden"`, a ratio
  string such as `"1:2"`, or a numeric vector such as `c(1, 2)`.

- gap:

  Relative spacing between rectangles.

- padding:

  Relative padding around the complete layout.

- align:

  Alignment of rectangles within the column. One of `"left"` or
  `"right"`.

## Value

A Rectangler plot object (a `ggplot`) that can be extended with
additional Rectangler layer functions.

## Examples

``` r
rect_col()


rect_col(rect_data_demo, align = "right")

```
