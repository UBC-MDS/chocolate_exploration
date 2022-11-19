# Chocolate Exploration
authors: Manvir Kohli, Julie Song, Kelvin Wong


> Project complete in accordance with DSCI 522 for the UBC MDS Program 2022-23 for Group 15
## Introduction

"Given the characteristics of a new dark chocolate, what will be its predicted rating on a scale of 1 to 5?" This is the predictive research question that we have set out to answer. Using this information, perhaps we can predict how well-received a new chocolate may be.

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

During our exploratory data analysis (EDA), we aim to check if the dataset is read correctly and if the features are read in the correct data types. If features are read as incorrect data types, we will have to convert them into the correct types. Using a table, we will check if any of the features contain nulls. Further, we will aim to identify features that are relevant and irrelevant to our problem statement of predicting the chocolate rating (for example we may drop identifier columns). We will also look at the distributions of our numeric and categorical columns by plotting graphs (histograms for numeric features and barplots for categorical features)

To answer our research question,since our target variable is continuous, we have a regression problem. To make our predictions we will be using different regressors on our training dataset like Ridge regression, SVM RBF, KNN Regressor and Decision Tree Regressor. We will compare the performance of each of these models by carrying out cross validation on the training dataset. Based on the cross-validation scores we will decide on the best performing model and will then tune the hyperparameters of this model with the aim of getting better predictions. Once the hyperparameters have been optimized using cross validation on the training dataset, we will use the optimized model to make predictions on the test data set. Finally we will assess our model performance based on the test data predictions, using regression metrics like R^2, MSE, RMSE and MAPE.


## Copyright and Licensing

The CSV files under `data/raw/` directories are works/direct derivative of works from the [Chocolate Bar Ratings database](http://flavorsofcacao.com/chocolate_database.html).

Copyright (c) 2011-2022 Brady Brelinski

Unless otherwise specified, the materials in this repository are covered under this copyright statement:

Copyright (c) 2022 Manvir Kohli, Julie Song, Kelvin Wong

The software and associated documentation files are licensed under the MIT License. You may find a copy of the license as [`LICENSE.md`](./LICENSE.md).

The report texts are licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 (CC BY-NC-ND 4.0) License. A copy of the license can be found as [`LICENSE-CC-BYNCND.md`](./LICENSE-CC-BYNCND.md).
<!-- #endregion -->
