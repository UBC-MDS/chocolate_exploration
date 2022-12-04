# author: Julie Song ,Kelvin Wong, Manvir Kohli
# date: 2022-11-23

"This script takes the path to the rmd file containing analysis results as an input
and renders it as a pdf in the same directory as the .Rmd file

Usage: chocolate_exploration_results_pdf_renderer.R --input_file_path = <input_file_path>  

Options:
--input_file_path = <input_file_path>  file path of the .rmd file to be rendered as pdf
" -> doc

library(docopt)
library(tidyverse)
library(dplyr)
library(knitr)
library(rmarkdown)

opt <- docopt(doc)

#' Title
#'
#' @param input_file_path file path of the .Rmd file to be rendered as pdf
#'
#' @return None
#' @export
#'
#' @examples main("chocolate_exploration_results_report.rmd")
main <- function(input_file_path) {
  if (!dir.exists("doc/")){
    dir.create("doc/") }
    
  # knitting function
  render(input = input_file_path,
         output_format = "pdf_document",
         output_dir = "doc/")
  
}

main(opt$input_file_path)
