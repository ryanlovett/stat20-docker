# https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions

# https://github.com/rocker-org/rocker-versioned2/wiki/
# https://github.com/rocker-org/rocker-versioned2/wiki/verse_d85fa9b368e5
FROM rocker/verse:4.5.2

ENV TZ=Etc/UTC

# And set ENV for R! It doesn't read from the environment...
RUN echo "TZ=${TZ}" >> /usr/local/lib/R/etc/Renviron.site
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron.site

# Add PATH to /etc/profile so it gets picked up by the terminal
RUN echo "PATH=${PATH}" >> /etc/profile
RUN echo "export PATH" >> /etc/profile

RUN apt-get update && \
    apt-get install --yes \
        rsync \
        libcurl4-openssl-dev \
        texlive-xetex \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        texlive-plain-generic \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# While quarto is included with rocker/verse, we sometimes need different
# versions than the default. For example a newer version might fix bugs.
ENV _QUARTO_VERSION=1.8.27
RUN curl -L -o /tmp/quarto.deb https://github.com/quarto-dev/quarto-cli/releases/download/v${_QUARTO_VERSION}/quarto-${_QUARTO_VERSION}-linux-amd64.deb
RUN apt-get install /tmp/quarto.deb && \
    rm -f /tmp/quarto.deb

# Switch to rstudio user for R package installation
USER rstudio

# Set snapshot date for reproducible package management
# Update this date to get newer package versions - format: YYYY-MM-DD
# See https://packagemanager.posit.co/client/#/repos/cran/setup for available dates
ENV SNAPSHOT_DATE=2025-10-01

# Configure R to use Posit Package Manager with binary packages for Ubuntu Noble
RUN echo "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/${SNAPSHOT_DATE}'))" > ~/.Rprofile && \
    echo "options(HTTPUserAgent = sprintf('R/%s R (%s)', getRversion(), paste(getRversion(), R.version['platform'], R.version['arch'], R.version['os'])))" >> ~/.Rprofile

# Copy and run package installation script
COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R

WORKDIR /home/rstudio

# RStudio port
EXPOSE 8787
