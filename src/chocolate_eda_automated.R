# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-23

"This script performs EDA on the train data created using train_test_split.R

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
    ggplot(aes(x=cocoa_percent,color = 'white')) +
    geom_histogram(bins=25, fill = "green") +
    theme_bw() +
    labs(x="Amount of Cocoa (%)", 
         y= "Count")+
    theme(legend.position = 'none')
  
  
  rating_plot <- eda_data_final |>
    ggplot(aes(x=rating)) +
    geom_bar(fill = "red") +
    theme_bw() +
    labs(x="Rating", 
         y= "Count")
  
  num_ingred_plot <- eda_data_final |>
    ggplot(aes(x=num_of_ingredients)) +
    geom_bar(fill="aquamarine") +
    theme_bw() +
    labs(x="Number of Ingredients", 
         y= "Count")
  
  year_plot <- eda_data_final |>
    ggplot(aes(x=review_date)) +
    geom_bar(fill= "lightblue") +
    theme_bw() +
    labs(x="Review Date", 
         y= "Count")
  
  
  num_title <- ggdraw(ylim = c(1,1)) + 
    draw_label("Figure 1: Numeric Plots", fontface='bold',size = 15)
  
  numeric_plots <- plot_grid(num_title,plot_grid(cocoa_plot, rating_plot, 
                                                 num_ingred_plot, year_plot),ncol=1,rel_heights = c(0.2,1))
  
  
  ggsave(filename="src/eda_files/Numeric_Plots.png", plot=numeric_plots)
  
  ## scatter plots
  eda_data_final$num_of_ingredients <- as.numeric(eda_data_final$num_of_ingredients)
  
  numeric_data <-  eda_data_final |> select_if(is.numeric)
  
  scatter_plots <-  GGally::ggpairs(numeric_data, progress=FALSE) +
    ggtitle("Figure 2: Pairwise Scatter Plots") +
    theme(plot.title = element_text(hjust = 0.5))
  
  ggsave(filename="src/eda_files/Scatter_Plots.png", plot=scatter_plots,
         width = 8, height = 10, units = "in")
  
  ##Categorical Features
  
  location_plot <- eda_data_final |>
    add_count(company_location) |>
    ggplot(aes(y=reorder(company_location, -n))) +
    geom_bar(fill = "orange",color = 'white') +
    theme_bw() +
    labs(y="Company Location", 
         x= "Count")
  
  bean_origin_plot <- eda_data_final |>
    add_count(country_of_bean_origin) |>
    ggplot(aes(y=reorder(country_of_bean_origin, -n))) +
    geom_bar(fill = "red",color = 'white') +
    theme_bw() +
    labs(y="Country of Bean Origin", 
         x= "Count")
  
  
  manufactuer_plot <- eda_data_final |>
    add_count(company_manufacturer) |>
    ggplot(aes(y=reorder(company_manufacturer, -n))) +
    geom_bar(fill = 'violet',color = 'white') +
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
         width = 8, height = 15, units = "in")
  
  ## boxplots
  boxplot_beans <- 
    eda_data_final |> ggplot(aes(x = beans, y = rating,color = beans)) +
    geom_boxplot()  + ggtitle('Chocolate rating based on \n beans as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Beans", y = "Rating")
  
  
  boxplot_sugar <- 
    eda_data_final |> ggplot(aes(x = sugar, y = rating,color = sugar)) +
    geom_boxplot()  + ggtitle('Chocolate rating based on \n sugar as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Sugar", y = "Rating")
  
  boxplot_sweet_oth <- 
    eda_data_final |> 
    ggplot(aes(x = sweetener_other, y = rating,color = sweetener_other)) +
    geom_boxplot()  + 
    ggtitle('Chocolate rating based on \n other sweeteners as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Sweetener (Other)", y = "Rating")
  
  boxplot_cocoa_butter <- 
    eda_data_final |> 
    ggplot(aes(x = cocoa_butter,y = rating,color = cocoa_butter)) +
    geom_boxplot()  + 
    ggtitle('Chocolate rating based on \n cocoa butter as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Cocoa Butter", y = "Rating")
  
  
  boxplot_vanilla <- 
    eda_data_final |> 
    ggplot(aes(x = vanilla,y = rating,color = vanilla)) +
    geom_boxplot()  + 
    ggtitle('Chocolate rating based on \n vanilla as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Vanilla", y = "Rating")
  
  
  boxplot_lecithin <- 
    eda_data_final |> 
    ggplot(aes(x = lecithin,y = rating,color = lecithin)) +
    geom_boxplot()  + 
    ggtitle('Chocolate rating based on \n lecithin as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Lecithin", y = "Rating")
  
  boxplot_salt <- 
    eda_data_final |> 
    ggplot(aes(x = salt,y = rating,color = salt)) +
    geom_boxplot()  + 
    ggtitle('Chocolate rating based on \n salt as an ingredient ') +
    theme(legend.position="none") +
    labs(x = "Salt", y = "Rating")
  
  boxplot_company_location <-  eda_data_final |> 
    ggplot(aes(x = company_location,y = rating,color = company_location)) +
    geom_boxplot()  + 
    ggtitle('Chocolate rating by Company Location ') +
    labs(x = "Company Location", y = "Rating") +
    theme(legend.position="none",
          axis.text.x = element_text(angle = 90, vjust = 0.5))
  
  box_title <- ggdraw(ylim = c(1,1)) + 
    draw_label("Figure 4: Boxplots by Rating", fontface='bold',size = 15)
  
  boxplots <- plot_grid( boxplot_beans,boxplot_cocoa_butter,
                         boxplot_sugar, boxplot_lecithin,
                         boxplot_salt, boxplot_sweet_oth,boxplot_vanilla,
                         boxplot_company_location,
                         
                         ncol=2,nrow = 4,rel_heights = c(1,1,1,1.5))
  
  
  boxplots_final <- plot_grid( box_title,boxplots, 
                               ncol=1,rel_heights = c(0.1,1))
  
  ggsave(filename="src/eda_files/Boxplots.png", plot=boxplots_final,
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
