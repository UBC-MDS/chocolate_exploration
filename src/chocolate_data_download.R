# author: Julie,Kelvin, Manvir
# date: 2022-11-17

"This script takes the url as a dataset as an input and saves it to the specified 
filepath .

Usage: chocolate_data_download.R --url = <url> --file_path = <file_path>

Options:
--url = <url>              URL from wher to download file
--file_path = <file_path>  Destination folder and name of the file (example data/raw/filename.csv)
" -> doc

library(docopt)
library(tidyverse)
library(dplyr)

opt <- docopt(doc)

main <- function(url, file_path) {
  
  # read in data
  data <- read_csv(url)
  
  # save data to specified file_path
  write_csv(data,file_path)
  
}

main(opt$url, opt$file_path)