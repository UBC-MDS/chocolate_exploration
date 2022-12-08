# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-12-07

has_docopt <- require("docopt")

if (!has_docopt) {
    stop("`docopt` is not installed. Run `install.packages('docopt')` first.")
}

"
deps.R

Usage:
    deps.R [--install | --list]

Options:
    -h --help   Print this help
    --install   Install the dependencies for this software distribution
    --list      List installed versions of the dependencies
" -> doc

library(docopt)

args <- docopt(doc)

dependencies <- c(
    "caTools",
    "cowplot",
    "docopt",
    "dplyr",
    "kableExtra",
    "knitr",
    "magick",
    "rmarkdown",
    "testthat",
    "tidyverse",
    "webshot"
)

repos <- "https://cran.microsoft.com/snapshot/2022-12-08/"

main <- function(args) {
    if (args$list) {
        for (p in dependencies) {
            message(p, "==", packageVersion(p))
        }
    } else if (args$install) {
        install.packages(dependencies, repos = repos)
        # post-install
        library(tinytex)
        tinytex::install_tinytex()
    } else {
        cat(doc)
    }
}
main(args)
