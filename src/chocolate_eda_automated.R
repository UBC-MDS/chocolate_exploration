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

#' Function to perform eda on train_data.csv and save results as plots and tables
#'
#' @return None
#' @export
#'
#' @examples main()
main <- function() {
  ## creating directory where results will be saved
  if (!dir.exists("src/eda_files")){
    dir.create("src/eda_files")
  }
  
  ##Glimpsing the Data
  
  eda_data <- read_csv("data/raw/train_df.csv")
  glimpse(eda_data)
  
  
  ##Data Processing    
  eda_data_converted <- eda_data|> 
    select(-c(ref,specific_bean_origin_or_bar_name)) |>
    separate(col=ingredients, sep ="-", into = c('num_of_ingredients','ingredients'))
  
  
  
  eda_data_converted <- eda_data_converted |>  
    mutate(ingred_new = gsub("S*","O",ingredients,fixed = T),
           ingred_new = gsub("Sa","Na",ingred_new,fixed = T)) |>
    
    mutate(beans = case_when(grepl("B",ingred_new)==TRUE~1,
                             !grepl("B",ingred_new)==TRUE~0),
           
           sugar = case_when(grepl("S",ingred_new)==TRUE~1,
                             !grepl("S",ingred_new)==TRUE~0),
           
           sweetener_other = case_when(grepl("O",ingred_new)==TRUE~1,
                                       !grepl("O",ingred_new)==TRUE~0),
           
           cocoa_butter = case_when(grepl("C",ingred_new)==TRUE~1,
                                    !grepl("C",ingred_new)==TRUE~0),
           
           vanilla = case_when(grepl("V",ingred_new)==TRUE~1,
                               !grepl("V",ingred_new)==TRUE~0),
           
           lecithin = case_when(grepl("L",ingred_new)==TRUE~1,
                                !grepl("L",ingred_new)==TRUE~0),
           
           salt = case_when(grepl("Na",ingred_new)==TRUE~1,
                            !grepl("Na",ingred_new)==TRUE~0)
           
    ) |> select (-c(ingredients,ingred_new))
  
  
  check_null <- eda_data_converted |> summarise(across(everything(), ~ sum(is.na(.))))
  check_null <-  t(check_null)
  colnames(check_null) <- 'Null_Count'
  rownames(check_null) <- NULL
  
  
  null_table <- cbind(Variable =colnames(eda_data_converted),
                      check_null)
  
  null_table <- kable(null_table, format = "html",  booktabs=TRUE,
                      col.names = c("Feature", "Null Count"),
                      table.attr = "style='width:50%;'",
                      caption = "Null Count by Feature") |> kable_classic_2()
  
  save_kable(x = null_table,file = 'src/eda_files/1.Nulls_table.html')   
   
  ## Exploring Categorical Columns Further
  
  manufacturer_groups <- eda_data_converted |> 
                        group_by(company_manufacturer) |> 
                        summarize(count = n()) |> arrange(-count) 
  
  location_groups <- eda_data_converted |> 
                      group_by(company_location) |> 
                      summarize(count = n()) |> 
                      arrange(-count)
                    
  bean_origin_groups <- eda_data_converted |> 
                      group_by(country_of_bean_origin) |>
                      summarize(count = n()) |> 
                      arrange(-count)
  
  top_locations <-  eda_data_converted |> 
                    group_by(company_location) |> 
                    summarize(count = n()) |>
                    filter(count >=20) |> pull(company_location)
                  
  top_countries <-  eda_data_converted |> 
                    group_by(country_of_bean_origin) |> 
                    summarize(count = n()) |> 
                    filter(count >=10) |> 
                    pull(country_of_bean_origin)
                                        
  
  top_50_manufacturers <-  eda_data_converted |> 
                          group_by(company_manufacturer) |> 
                          summarize(count = n()) |> arrange(-count) |> 
                          top_n(50) |> pull(company_manufacturer)
                        
  
  top_locations <-  as.vector(top_locations)
  top_countries <-  as.vector(top_countries)
  top_50_manufacturers <- as.vector(top_50_manufacturers)
  
  
  eda_data_converted <- eda_data_converted |>
                      mutate(
    company_location = case_when(!company_location %in% top_locations ~ "Other",
                                 TRUE ~ company_location) ,
    country_of_bean_origin = case_when(!country_of_bean_origin %in% top_countries ~ "Other",
                                   TRUE ~ country_of_bean_origin),
    company_manufacturer = case_when(!company_manufacturer 
                                     %in% top_50_manufacturers ~ "Other",
                                     TRUE ~ company_manufacturer)) 
  
  ## Converting Data Types
  
  
  eda_data_final <-   eda_data_converted |> mutate(
    company_location = as.factor(company_location),
    country_of_bean_origin = as.factor(country_of_bean_origin),
    cocoa_percent = str_replace(cocoa_percent,"%",""),
    cocoa_percent = as.numeric(cocoa_percent)/100,
    company_manufacturer = as.factor(company_manufacturer),
    beans = as.factor(beans),
    sugar = as.factor(sugar),
    salt = as.factor(salt),
    vanilla = as.factor(vanilla),
    cocoa_butter = as.factor(cocoa_butter),
    lecithin = as.factor(lecithin),
    sweetener_other = as.factor(sweetener_other)
  ) 
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
  
  num_title <- ggdraw(ylim = c(1,1)) + 
    draw_label("Figure 1: Numeric Plots", fontface='bold',size = 15)
  
  numeric_plots <- plot_grid(num_title,plot_grid(cocoa_plot, rating_plot, 
                     num_ingred_plot, year_plot),ncol=1,rel_heights = c(0.2,1))
  
  
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
  
  
  manufactuer_plot <- eda_data_final |>
    add_count(company_manufacturer) |>
    ggplot(aes(y=reorder(company_manufacturer, -n))) +
    geom_bar() +
    theme_bw() +
    labs(y="Manufacturer", 
         x= "Count")
  
  
  cat_title <- ggdraw(ylim = c(1,1)) + 
    draw_label("Figure 2: Categorical Plots", fontface='bold',size = 15)
  
  categ_plots <- plot_grid( cat_title,location_plot, 
                            bean_origin_plot, manufactuer_plot, ncol=1,nrow = 4, 
                            rel_widths = c(0.5,2,2,2 ),
                            rel_heights = c(0.1,1.5,2,3))
  
  
  ggsave(filename="src/eda_files/Categorical_Plots.png", plot=categ_plots,
         width = 8, height = 10, units = "in")
  
  ## final results
  eda_data_final <- eda_data_final |> select(-company_manufacturer)
  
  eda_data_final_feats <-  eda_data_final |> select(-rating)
  
  ftypes <- cbind(Feature =colnames(eda_data_final_feats),
                  Type = c("Factor", "Numeric", "Factor", 
                           "Numeric", "Numeric", 
                           "Character(Text)",rep(c("Factor (Binary)"),7)))
  
  
  final_features_table <- kable(ftypes, format="html", booktabs=TRUE, 
        col.names = c("Feature", "Type"), table.attr = "style='width:30%;'",
        caption = "Final Features and Data Types") |> kable_classic_2()
    
  
  save_kable(x = final_features_table,file = 'src/eda_files/2.Final_Features_Table.html')   
  
  
  final_dataset_table <- kable(head(eda_data_final,10), format="html", booktabs=TRUE, 
        col.names = colnames(eda_data_final), table.attr = "style='width:70%;'",
        caption = "Preview of final train_data")|> kable_classic_2()
  
  save_kable(x = final_dataset_table,file = 'src/eda_files/3.Final_Dataset_View.html')
  
}

main()
