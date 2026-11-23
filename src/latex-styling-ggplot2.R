# Data setup.
library(latex2exp)
labels <- c(
  TeX("$\\eta_2$"), TeX("$\\eta_1$"), TeX("$\\sigma_2$"), TeX("$\\sigma_1$"),
  TeX("$\\mu_2$"), TeX("$\\mu_1$")
)
df <- data.frame(
  x = c(3040, 3040, 3458, 3392, 2758, 4176),
  y = sapply(labels, deparse)
)

# Fonts and PDF driver setup.
extrafont::loadfonts(quiet = TRUE)
file_name <- "plot_example.pdf"
pdf(file_name)

# Build plot.
library(ggplot2)
grid_line <- element_line(
  linewidth = 0.25, linetype = "dashed", color = "grey"
)
plot <- ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  scale_y_discrete(labels = labels) +
  theme_bw() +
  theme(
    axis.text = element_text(color = "black"),
    panel.grid.major = grid_line,
    panel.grid.minor = grid_line,
    text = element_text(family = "CM Roman", size = 10)
  ) +
  xlab(TeX("bulk\U00AD{}$\\textit{n}_{eff}$")) +
  ylab("Mixture parameter")

# Set plot size.
gridExtra::grid.arrange(
  grobs = lapply(
    list(plot),
    egg::set_panel_size,
    width = grid::unit(42, "mm"),
    height = grid::unit(42, "mm")
  )
)

# Close extraneous graphics devices.
while (!is.null(dev.list())) {
  device_num <- as.integer(dev.cur())
  if (device_num != 1) {
    dev.off(which = device_num)
  }
}

# Finalise plot.
extrafont::embed_fonts(file_name)
knitr::plot_crop(file_name)
