# chocolate_exploration

-   authors: Manvir Kohli, Julie Song, Kelvin Wong

## Introduction

"Given the characteristics of a new dark chocolate, what will be its predicted rating on a scale of 1 to 5?" This is the predictive research question that we have set out to answer. Using this information, perhaps we can predict how well-received a new brand of chocolate may be.

### Download the Data Set

The data set is from [Flavors of Cacao](http://flavorsofcacao.com/chocolate_database.html), where the Manhattan Chocolate Society (headed by Brady Brelinski) has reviewed 2,500+ bars of craft chocolate since 2006. The findings have been compiled into a copy-paste-able table that lists each bar's manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The data set we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday) using the following raw URL:

    https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv

You may also use the included `chocolate_data_download.R` to download the dataset, using the following:

    Rscript src/chocolate_data_download.R --url = https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv --file_path = data/raw/chocolate.csv

A `train_test_split.Rmd` file is provided in the `src/` folder, which processes the `chocolate.csv` into a `train_df.csv` and a `test_df.csv` using a 70%-30% split.

### Analysis

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
