# Chocolate Exploration

> Project complete in accordance with DSCI 522 for the UBC MDS Program 2022-23 for Group 15
## Introduction

"Given the characteristics of a new dark chocolate, what will be its predicted rating on a scale of 1 to 5?" This is the predictive research question that we have set out to answer. Using this information, perhaps we can predict how well-received a new brand of chocolate may be.

## Usage

Before we start, make sure your computer has R and Python development environment set up. IDEs like [R Studio](https://posit.co/products/open-source/rstudio/) and [Visual Studio Code](https://code.visualstudio.com/) are optional but recommended.

### Download the code

The latest copy of this code can be downloaded by:

```{bash}
git clone https://github.com/UBC-MDS/chocolate_exploration.git
cd chocolate_exploration
```

### Install the dependencies

The EDAs are written in R, and the packages can be installed by:

```{bash}
R -e 'install.packages(c("docopt", "tidyverse", "dplyr", "caTools", "cowplot", "knitr", "kableExtra"))'
```

The versions used in the development can be confirmed by:

```{bash}
R -e 'for (p in c("docopt", "tidyverse", "dplyr", "caTools", "cowplot", "knitr", "kableExtra")) { print(paste0(p, "==", packageVersion(p)))}'
[1] "docopt==0.7.1"
[1] "tidyverse==1.3.2"
[1] "dplyr==1.0.10"
[1] "caTools==1.18.2"
[1] "cowplot==1.1.1"
[1] "knitr==1.41"
[1] "kableExtra==1.3.4"
```

The actual analyses are written in Python. A conda file can be found at `src/environment.yml` (TBD in Milestone 2)

### Download the data set

The data set is from [Flavors of Cacao](http://flavorsofcacao.com/chocolate_database.html), where the Manhattan Chocolate Society (headed by Brady Brelinski) has reviewed 2,500+ bars of craft chocolate since 2006. The findings have been compiled into a copy-paste-able table that lists each bar's manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The data set we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday) using the following raw URL:

```
https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv
```

You may also use the included `chocolate_data_download.R` to download the dataset, using the following:

```{bash}
Rscript src/chocolate_data_download.R --url = https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv --file_path = data/raw/chocolate.csv
```

### Split the data set

A `train_test_split.Rmd` file is provided in the `src/` folder, which processes the `chocolate.csv` into a `train_df.csv` and a `test_df.csv` using a 70%-30% split.

## Analysis

During our exploratory data analysis (EDA), which was performed on the training portion of the data set, we conducted some data processing to ensure the features columns had the correct data type, and to check for any missing values. We also determined which features may be the most relevant for modelling purposes, and which ones may be unique identifiers that would not be suitable for generalization. A glimpse of the final, processed data set is shown as a table, as well as several bar charts and histograms to show the distributions for our numerical, discrete, and categorical features.

To answer our research question, we are planning to use a Naive Bayes classifier. This is because most of our data is categorical or discrete, and we also using a text feature. We will also be predicting a discrete value, so this is a multi-class classification problem. Naive Bayes can easily handle these considerations, so we plan to first explore this type of model. We will need to explore the degree of Laplace Smoothing required for our model, beginning with an alpha value of 1, based on the training and cross-validation scores.

Once our hyperparameters have been optimized, we will make predictions using the test data set. To see how many predicted ratings were accurate, were over-predicted, or were under-predicted by our model, we can present these values in a table, along with the final test score for our test data.

## Copyright and Licensing

The CSV files under `data/raw/` directories are works/direct derivative of works from the [Chocolate Bar Ratings database](http://flavorsofcacao.com/chocolate_database.html).

Copyright (c) 2011-2022 Brady Brelinski

Unless otherwise specified, the materials in this repository are covered under this copyright statement:

Copyright (c) 2022 Manvir Kohli, Julie Song, Kelvin Wong

The software and associated documentation files are licensed under the MIT License. You may find a copy of the license as [`LICENSE.md`](./LICENSE.md).

The report texts are licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 (CC BY-NC-ND 4.0) License. A copy of the license can be found as [`LICENSE-CC-BYNCND.md`](./LICENSE-CC-BYNCND.md).
