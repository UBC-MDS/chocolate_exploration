# author: Julie,Kelvin, Manvir
# date: 2022-11-17

"This script takes the url as a dataset as an input and saves it to the specified 
filepath .

Usage: chocolate_data_download.R --url = <url> --download_dir = <download_dir> --file_name = <file_name>

Options:
--url = <url>                    URL from wher to download file
--download_dir = <download_dir>  Destination folder of the file (example data/raw)
--file_name = <file_name>        Name of the file (example chocolate.csv)
" -> doc

library(docopt)
library(tidyverse)
library(dplyr)

opt <- docopt(doc)

main <- function(url, download_dir,file_name) {
  
  ## creating directory where data dwill be donwloaded
  if (!dir.exists(download_dir)){
    dir.create(download_dir,recursive = TRUE)}
    
  # read in data
  data <- read_csv(url)
  
  # save data to specified file_path
  setwd(download_dir)
  write_csv(data,file_name)
  
}

main(opt$url, opt$download_dir, opt$file_name)
