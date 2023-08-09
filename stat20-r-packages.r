#!/usr/bin/env Rscript

source("/tmp/set-libs.r")

set_name <- "Stat 20"

set_libs <- c(
  "rmarkdown", "2.22",
  "plotly", "4.10.1",
  "patchwork", "1.1.2",
  "reshape2", "1.4.4",
  "kableExtra", "1.3.4",
  "infer", "1.0.4",
  "countdown", "0.4.0",
  "palmerpenguins", "0.1.1",
  "ggrepel", "0.9.3",
  "ggthemes", "4.2.4",
  "latex2exp", "0.9.6",
  "markdown", "1.7",
  "downlit", "0.4.3",
  "xml2", "1.3.4",
  "gt", "0.9.0",
  "openintro", "2.4.0",
  "janitor", "2.2.0",
  "quarto", "1.2",
  "fs", "1.6.3"
)

set_libs_install_version(set_name, set_libs)

remotes::install_github("stat20/stat20data")
remotes::install_github("hadley/emo")

print(paste("Done installing packages for", set_name))
