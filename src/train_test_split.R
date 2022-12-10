# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-23

"This script creates a train test split of the entire data. The split data is stored in the user specified directory.
The train and test data are named train.csv and test.csv.

Usage: train_test_split.R --input_file_path = <input_file_path> --output_file_dir = <output_file_dir>

Options:
--input_file_path = <input_file_path>  File path of the complete dataset to be split into train and test.
--output_file_dir = <output_file_dir>  Directory where the train and test data sets are to be stored. Should be set as 'data/raw/'
" -> doc

library(docopt)
library(tidyverse)
library(dplyr)
library(testthat)
library(caTools)

opt <- docopt(doc)


#' Function to split dataset into 70-30 train-test split
#'
#' @param file_path file path of the complete dataset to be split into train and test
#'
#' @return None
#' @export
#'
#' @examples main("data/raw/chocolate.csv")
main <- function(input_file_path,output_file_dir) {
    chocolate_data = read_csv(file= input_file_path)
    head(chocolate_data)
    nrow(chocolate_data)
    # # creating a train_test split of 70-30
    set.seed(522)
    sample <- sample.split(Y = chocolate_data$rating, SplitRatio = 0.7)  
    
    # check if sample is true 
    train_df  <- subset(chocolate_data, sample == TRUE)
    test_df   <- subset(chocolate_data, sample == FALSE)
    
    dim(train_df)
    dim(test_df)
    (nrow(train_df) + nrow(test_df) == nrow(chocolate_data)) 
    
    setwd(output_file_dir)
    write_csv(train_df,"train_df.csv")
    write_csv(test_df,"test_df.csv")
    
}

main(opt$input_file_path,opt$output_file_dir)