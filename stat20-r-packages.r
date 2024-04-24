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
  "fs", "1.6.3",
  "vcd", "1.4-12",
  "optmatch", "0.10.7"
  #"cobalt", "4.5.5", unsure why these don't work in this image. Installing from github instead.
  #"MatchIt", "4.5.5"
)

set_libs_install_version(set_name, set_libs)

remotes::install_github("stat20/stat20data@25f1bae")
remotes::install_github("hadley/emo")
remotes::install_github("ngreifer/cobalt")
remotes::install_github("kosukeimai/MatchIt")

print(paste("Done installing packages for", set_name))
