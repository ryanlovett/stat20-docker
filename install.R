#!/usr/bin/env Rscript

# Install required packages for STAT course website
# This script is run during Docker build time

cat("Installing required R packages...\n")

# First install renv for package management
if (!requireNamespace('renv', quietly = TRUE)) {
  cat("Installing renv...\n")
  install.packages('renv')
}

# Define all required packages
required_packages <- c(
  "rmarkdown",
  "plotly",
  "patchwork",
  "reshape2",
  "kableExtra",
  "infer",
  "countdown",
  "palmerpenguins",
  "ggrepel",
  "ggthemes",
  "latex2exp",
  "markdown",
  "downlit",
  "xml2",
  "gt",
  "openintro",
  "janitor",
  "quarto",
  "fs",
  "vcd",
  "optmatch",
  "MatchIt",
  "cobalt"
)

cat("Installing", length(required_packages), "packages using renv...\n")
cat("Packages:", paste(required_packages, collapse = ", "), "\n\n")

remotes::install_github("stat20/stat20data@2536a78")
remotes::install_github("hadley/emo")

# Install packages using renv with error handling
tryCatch({
  renv::install(required_packages)
  cat("✓ Package installation completed successfully!\n")
}, error = function(e) {
  cat("✗ renv installation failed:", e$message, "\n")
  cat("Falling back to install.packages()...\n")

  # Fallback to regular install.packages
  tryCatch({
    install.packages(required_packages)
    cat("✓ Fallback installation completed successfully!\n")
  }, error = function(e2) {
    cat("✗ Fallback installation also failed:", e2$message, "\n")
    stop("Package installation failed")
  })
})

# Verify installation
cat("\n=== PACKAGE INSTALLATION VERIFICATION ===\n")
failed_packages <- character()

for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("✓ %-20s installed\n", pkg))
  } else {
    cat(sprintf("✗ %-20s FAILED\n", pkg))
    failed_packages <- c(failed_packages, pkg)
  }
}

if (length(failed_packages) > 0) {
  cat("\nFailed packages:", paste(failed_packages, collapse = ", "), "\n")
  stop("Some packages failed to install")
} else {
  cat("\nAll packages installed successfully!\n")
}
