# author: Julie Song ,Kelvin Wong, Manvir Kohli
# date: 2022-11-23

"This script creates a  train test split of the entire data.

Usage: train_test_split.R --input_file = <input_file>

Options:
--input_file = <input_file>  File path of the complete dataset to be split into train and test.
" -> doc

library(docopt)
library(tidyverse)
library(dplyr)
library(testthat)
library(caTools)

opt <- docopt(doc)


main <- function(file_path) {
    chocolate_data = read_csv(file= file_path)
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
    
    write_csv(train_df,"data/raw/train_df.csv")
    write_csv(test_df,"data/raw/test_df.csv")
    
}

main(opt$input_file)