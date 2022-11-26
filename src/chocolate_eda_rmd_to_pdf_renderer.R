# author: Julie Song ,Kelvin Wong, Manvir Kohli
# date: 2022-11-23

"This script takes the path to the rmd file containing EDA findings as an input and renders it as a pdf in the same directory as the .Rmd file

Usage: chocolate_eda_rmd_to_pdf_renderer.R --input_file_path = <input_file_path>  

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
#' @examples
main <- function(input_file_path) {
  
  if (!dir.exists("src/eda_files")){
    dir.create("src/eda_files",recursive = T) }
  
  # knitting function
  render(input = input_file_path,
         output_format = "pdf_document",
        output_dir = "src/eda_files")
  
}

main(opt$input_file_path)