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

COPY set-libs.r /tmp/set-libs.r

COPY stat20-r-packages.r /tmp/r-packages/
RUN r /tmp/r-packages/stat20-r-packages.r && \
    rm -rf /tmp/downloaded_packages /tmp/repos*.rds /tmp/file*

# Reduce the side of RSPM packages
# https://rocker-project.org/use/extending.html
RUN strip /usr/local/lib/R/site-library/*/libs/*.so

WORKDIR /home/rstudio

# RStudio port
EXPOSE 8787
