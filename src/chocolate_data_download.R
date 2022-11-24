# author: Julie Song ,Kelvin Wong, Manvir Kohli
# date: 2022-11-17

"This script takes the url of a dataset as an input and saves it to the specified 
filepath .

Usage: chocolate_data_download.R --url = <url> --file_path = <file_path>

Options:
--url = <url>              URL from wher to download file
--file_path = <file_path>  Destination folder and name of the file (example: data/raw/filename.csv)
" -> doc

library(docopt)
library(tidyverse)
library(dplyr)
library(testthat)

opt <- docopt(doc)

#' Function to download and save dataset
#'
#' @param url url to the dataset to be downlaoded 
#' @param file_path file path where the downloaded dataset must be saved
#'
#' @return None
#' @export
#'
#' @examples main('http://flavorsofcacao.com/chocolate_database.html','data/chocolate.csv')
main <- function(url, file_path) {
  
  # read in data
  data <- read_csv(url)
  
  # save data to specified file_path
  write_csv(data,file_path)
  
}

main(opt$url, opt$file_path)