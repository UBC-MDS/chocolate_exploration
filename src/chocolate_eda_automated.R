# author: Julie Song ,Kelvin Wong, Manvir Kohli
# date: 2022-11-23

"This script performs EDA on the train data created using .... .

Usage: chocolate_eda_automated.R

" -> doc

library(dplyr)
library(tidyverse)
library(cowplot)
library(knitr)
library(kableExtra)
library(docopt)
library(magick)
library(webshot)
#webshot::install_phantomjs()

opt <- docopt(doc)

main <- function() {
  ## creating directory where results will be saved
  if (!dir.exists("src/eda_files")){
    dir.create("src/eda_files")
  }
  ##Glimpsing the Data
  
  eda_data <- read_csv("data/raw/train_df.csv")
  glimpse(eda_data)
  
  
  ##Data Processing    
  eda_data_converted <- eda_data |> 
  select(-c(ref,specific_bean_origin_or_bar_name)) |>
  separate(col=ingredients, sep ="-", into = c('num_of_ingredients','ingredients'))

  
  check_null <- eda_data_converted |> summarise(across(everything(), ~ sum(is.na(.))))
  check_null <-  t(check_null)
  colnames(check_null) <- 'Null_Count'
  rownames(check_null) <- NULL
  
  
  null_table <- cbind(Variable = c("Manufacturing Company", "Company Location", "Review Date", 
                                   "Country of Bean Origin", "Amount of Cocoa (%)",
                                   "Number of Ingredients", "Ingredients Present",
                                   "Most Memorable Characteristics", "Rating (1-5)"), 
                      check_null)
  
  null_table <- kable(null_table, format = "html",  booktabs=TRUE,
                      col.names = c("Feature", "Null Count"),
                      caption = "Null Count by Feature") |> kable_classic_2()
  
  save_kable(x = null_table,file = 'src/eda_files/Nulls_table.html')   
   
  ## Exploring Categorical Columns Further
  
  manufacturer_groups <- eda_data_converted |> group_by(company_manufacturer) |> summarize(count = n()) |> arrange(-count) 
  
  location_groups <- eda_data_converted |> group_by(company_location) |> summarize(count = n()) |> arrange(-count)
  
  bean_origin_groups <- eda_data_converted |> group_by(country_of_bean_origin) |> summarize(count = n()) |> arrange(-count)
  
  ingred_groups <- eda_data_converted |> group_by(ingredients) |> summarize(count = n()) |> arrange(-count)
  
  top_10_locations <-  eda_data_converted |> group_by(company_location) |> summarize(count = n()) |> arrange(-count) |> 
    top_n(10) |> pull(company_location)
  
  top_25_countries <-  eda_data_converted |> group_by(country_of_bean_origin) |> summarize(count = n()) |> arrange(-count) |> 
    top_n(25) |> pull(country_of_bean_origin)
  
  top_5_ingredients <-  eda_data_converted |> group_by(ingredients) |> summarize(count = n()) |> arrange(-count) |> 
    top_n(5) |> pull(ingredients)
  
  top_50_manufacturers <-  eda_data_converted |> group_by(company_manufacturer) |> summarize(count = n()) |> arrange(-count) |> 
    top_n(50) |> pull(company_manufacturer)
  
  
  top_10_locations <-  as.vector(top_10_locations)
  top_25_countries <-  as.vector(top_25_countries)
  top_5_ingredients <- as.vector(top_5_ingredients)
  top_50_manufacturers <- as.vector(top_50_manufacturers)
  
  
  eda_data_converted <- eda_data_converted |>
    mutate(
      company_location = case_when(!company_location %in% top_10_locations ~ "Other",
                                   TRUE ~ company_location) ,
      country_of_bean_origin = case_when(!country_of_bean_origin %in% top_25_countries ~ "Other",
                                         TRUE ~ country_of_bean_origin),
      ingredients = case_when(!ingredients %in% top_5_ingredients ~ "Other",
                              TRUE ~ ingredients),
      company_manufacturer = case_when(!company_manufacturer 
                                       %in% top_50_manufacturers ~ "Other",
                                       TRUE ~ company_manufacturer)) 
  
  ## Converting Data Types
  
  eda_data_final <-   eda_data_converted |> mutate(
    company_location = as.factor(company_location),
    country_of_bean_origin = as.factor(country_of_bean_origin),
    cocoa_percent = str_replace(cocoa_percent,"%",""),
    cocoa_percent = as.numeric(cocoa_percent)/100,
    ingredients = as.factor(ingredients),
    company_manufacturer = as.factor(company_manufacturer))
  glimpse(eda_data_final)
  
  ## Data Distributions
  ## Numerical and Discrete Features
  
  cocoa_plot <- eda_data_final |>
    ggplot(aes(x=cocoa_percent)) +
    geom_histogram(bins=25) +
    theme_bw() +
    labs(x="Amount of Cocoa (%)", 
         y= "Count")
  
  rating_plot <- eda_data_final |>
    ggplot(aes(x=rating)) +
    geom_bar() +
    theme_bw() +
    labs(x="Rating", 
         y= "Count")
  
  num_ingred_plot <- eda_data_final |>
    ggplot(aes(x=num_of_ingredients)) +
    geom_bar() +
    theme_bw() +
    labs(x="Number of Ingredients", 
         y= "Count")
  
  year_plot <- eda_data_final |>
    ggplot(aes(x=review_date)) +
    geom_bar() +
    theme_bw() +
    labs(x="Review Date", 
         y= "Count")
  
  numeric_plots <- plot_grid(cocoa_plot, rating_plot, 
                             num_ingred_plot, year_plot)
  
  ggsave(filename="src/eda_files/Numeric_Plots.png", plot=numeric_plots)
  
  ##Categorical Features
  
  location_plot <- eda_data_final |>
    add_count(company_location) |>
    ggplot(aes(y=reorder(company_location, -n))) +
    geom_bar() +
    theme_bw() +
    labs(y="Company Location", 
         x= "Count")
  
  bean_origin_plot <- eda_data_final |>
    add_count(country_of_bean_origin) |>
    ggplot(aes(y=reorder(country_of_bean_origin, -n))) +
    geom_bar() +
    theme_bw() +
    labs(y="Country of Bean Origin", 
         x= "Count")
  
  ingred_plot <- eda_data_final |>
    add_count(ingredients) |>
    ggplot(aes(y=reorder(ingredients, -n))) +
    geom_bar() +
    theme_bw() +
    labs(y="Ingredients", 
         x= "Count")
  
  manufactuer_plot <- eda_data_final |>
    add_count(company_manufacturer) |>
    ggplot(aes(y=reorder(company_manufacturer, -n))) +
    geom_bar() +
    theme_bw() +
    labs(y="Manufacturer", 
         x= "Count")
  
  cat_title = "Categorical Plots"
  
  categ_plots <- plot_grid(ingred_plot, location_plot, 
                           manufactuer_plot, bean_origin_plot, 
                           ncol=2,
                           rel_widths = c(1, 0.75),
                           rel_heights = c(0.3, 1)
  )
  
  ggsave(filename="src/eda_files/Categorical_Plots.png", plot=categ_plots,
         width = 8, height = 10, units = "in")
  
  eda_data_final <- eda_data_final |> select(-company_manufacturer)
  
  ftypes <- cbind(Feature = c("Company Location", "Review Date", 
                              "Country of Bean Origin", "Amount of Cocoa (%)",
                              "Number of Ingredients", "Ingredients Present",
                              "Most Memorable Characteristics"),
                  Type = c("Factor", "Numeric - Continuous", "Factor", 
                           "Numeric - Continuous", "Numeric - Discrete", 
                           "Factor", "Character(Text)"))
  
  final_features_table <- kable(ftypes, format="html", booktabs=TRUE, 
        col.names = c("Feature", "Type"), table.attr = "style='width:30%;'",
        caption = "Final Features and Data Types") |> kable_classic_2()
    
  
  save_kable(x = final_features_table,file = 'src/eda_files/Final_Features_Table.html')   
  
  
  final_dataset_table <- kable(head(eda_data_final,10), format="html", booktabs=TRUE, 
        col.names = c("Company Location", "Review Date", 
                      "Country of Bean Origin", "Amount of Cocoa (%)", 
                      "Number of Ingredients", "Ingredients Present", 
                      "Most Memorable Characteristics", "Rating (1-5)"),
        caption = "Final Features and Target in the Chocolate Dataset") |>
    kable_classic_2()
  
  save_kable(x = final_dataset_table,file = 'src/eda_files/Final_Dataset_View.html')
  
}

main()
