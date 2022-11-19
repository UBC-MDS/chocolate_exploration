<!-- #region -->
# chocolate_exploration

-   authors: Manvir Kohli, Julie Song, Kelvin Wong

## Introduction

"Given the characteristics of a new dark chocolate, what will be its predicted rating on a scale of 1 to 5?" This is the predictive research question that we have set out to answer. Using this information, perhaps we can predict how well-received a new chocolate may be.

### Download the Data Set

The data set is from [Flavors of Cacao](http://flavorsofcacao.com/chocolate_database.html), where the Manhattan Chocolate Society (headed by Brady Brelinski) has reviewed 2,500+ bars of craft chocolate since 2006. The findings have been compiled into a copy-paste-able table that lists each bar's manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The data set we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday) using the following raw URL:

    https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv

You may also use the included `chocolate_data_download.R` to download the dataset, using the following:

    Rscript src/chocolate_data_download.R --url = https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv --file_path = data/raw/chocolate.csv

A `train_test_split.Rmd` file is provided in the `src/` folder, which processes the `chocolate.csv` into a `train_df.csv` and a `test_df.csv` using a 70%-30% split.

### Analysis

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
