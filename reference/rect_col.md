# Create a column layout of rectangles

Creates a vertical layout where rectangles are stacked from top to
bottom. Rectangle areas are proportional to the supplied numeric values.
Values can be supplied directly with `value` or taken from a column in
`data` using `value_col`.

## Usage

``` r
rect_col(
  data = NULL,
  value = NULL,
  value_col = "value",
  aspect_ratio = "square",
  gap = rect_defaults$gap,
  padding = rect_defaults$padding,
  align = "left"
)
```

## Arguments

- data:

  Optional data frame containing one row for each rectangle. If omitted,
  supply rectangle values directly with `value`.

- value:

  Numeric value or vector of values used to determine rectangle areas.

- value_col:

  Name of the column in `data` containing rectangle values.

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

## Details

The returned plot can be further customised by adding Rectangler layers,
such as
[`rect_style()`](https://hriisalu.github.io/rectangler/reference/rect_style.md),
[`rect_label()`](https://hriisalu.github.io/rectangler/reference/rect_label.md),
[`rect_shape()`](https://hriisalu.github.io/rectangler/reference/rect_shape.md),
[`rect_shape_label()`](https://hriisalu.github.io/rectangler/reference/rect_shape_label.md),
or
[`rect_annotation()`](https://hriisalu.github.io/rectangler/reference/rect_annotation.md).

## Examples

``` r
rect_col(value = c(10, 20, 30, 40))


rect_col(rect_data_demo, value_col = "value", align = "right")

```
