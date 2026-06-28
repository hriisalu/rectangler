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
    )

  )

}
