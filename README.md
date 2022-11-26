# Chocolate Exploration

> Authors: Manvir Kohli, Julie Song, Kelvin Wong
>
> Project complete in accordance with DSCI 522 for the UBC MDS Program 2022-23 for Group 15

## About

"Given the characteristics of a new dark chocolate, what will be its predicted rating on a scale of 1 to 5?" This is the predictive research question that we have set out to answer. Using this information, perhaps we can predict how well-received a new chocolate may be.

Four regression models were used to answer this question. **<summarize how the models did>**


The data set is from [Flavors of Cacao](http://flavorsofcacao.com/chocolate_database.html), where the Manhattan Chocolate Society (headed by Brady Brelinski) has reviewed 2,500+ bars of craft chocolate since 2006. The findings have been compiled into a copy-paste-able table that lists each bar's manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The data set we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday) using the following raw URL:

    https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv
It can also be downloaded using the instructions below.

## Report
The final report can be found [here](doc/chocolate_exploration_results_report.pdf). 

## Usage

Before we start, make sure your computer has R and Python development environment set up. IDEs like [R Studio](https://posit.co/products/open-source/rstudio/) and [Visual Studio Code](https://code.visualstudio.com/) are optional but recommended.

The following flowchart gives an overview for the script workflow:

![Figure 1, Flowchart for scripts and workflow](flowchart.png)

### Download the code

The latest copy of this code can be downloaded by:

```{bash}
git clone https://github.com/UBC-MDS/chocolate_exploration.git
cd chocolate_exploration
```

### Install the dependencies

The EDAs are written in R, and the packages can be installed by:

```{bash}
R -e 'install.packages(c("docopt", "tidyverse", "dplyr", "caTools", "cowplot", "knitr", "kableExtra", "rmarkdown","magick","webshot"))'
```

The versions used in the development can be confirmed by:

```{bash}
R -e 'for (p in c("docopt", "tidyverse", "dplyr", "caTools", "cowplot", "knitr", "kableExtra", "rmarkdown","magick","webshot")) { print(paste0(p, "==", packageVersion(p)))}'
[1] "docopt==0.7.1"
[1] "tidyverse==1.3.2"
[1] "dplyr==1.0.9"
[1] "caTools==1.18.2"
[1] "cowplot==1.1.1"
[1] "knitr==1.40"
[1] "kableExtra==1.3.4"
[1] "rmarkdown==2.18"
[1] "magick==2.7.3"
[1] "webshot==0.5.4"
```

The actual analyses are written in Python. A Conda environment file can be found at [`environment.yml`](./environment.yaml).

To create the environment, run this at the project root:

```{bash}
conda env create -f environment.yaml
```

To activate the environment:

```{bash}
conda activate chocolate_exploration
```

To deactivate the environment:

```{bash}
conda deactivate
```

For more information, please refer to the [conda documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

### Download the data set

Aside from the raw URL mentioned above, you may also use the included `chocolate_data_download.R` to download the dataset, using the following:

```{bash}
Rscript src/chocolate_data_download.R --url = https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv --download_dir = data/raw --file_name = chocolate.csv```

### Split the data set

Running the script train_test_split.R in the 'src' folder as shown below processes the `chocolate.csv` into a `train_df.csv` and a `test_df.csv` using a 70%-30% split.
```bash
Rscript src/train_test_split.R --input_file = data/raw/chocolate.csv
```

### Tune the models

To tune the models, run the following commands at the project root:

```{bash}
python -m src.models.chocolate_decision_tree --train=data/raw/train_df.csv --output=results/models/
python -m src.models.chocolate_svm_rbf --train=data/raw/train_df.csv --output=results/models/
```

These commands generate `tuned_{model_name}.joblib` under the folder `results/models/`.

## EDA Analysis

You can run the EDA of this dataset using the chocolate_eda_automated.R script in the'src' folder. Running the command below saves the results of EDA in the src/eda_files folder.

``` bash
Rscript src/chocolate_eda_automated.R
```

EDA Results stored by the above script include: 
 - Summary of null values ("Nulls_table.html") 
 - Summary of final features used for modelling ("Final_Features_Table.html") 
 - View of the final dataset ("Final_Dataset_View.html") 
 - Plots for categorical variables ("Numerical_Plots.png") 
 - Plots for categorical variables ("Categorical_Plots.png")

You can also view the complete EDA summary as a PDF using the below script which renders src/chocolate_eda.Rmd file as a PDF

``` bash
Rscript src/chocolate_eda_rmd_to_pdf_renderer.R --input_file_path = src/chocolate_eda.Rmd
```

## Copyright and Licensing

The CSV files under `data/raw/` directories are works/direct derivative of works from the [Chocolate Bar Ratings database](http://flavorsofcacao.com/chocolate_database.html).

Copyright (c) 2011-2022 Brady Brelinski

Unless otherwise specified, the materials in this repository are covered under this copyright statement:

Copyright (c) 2022 Manvir Kohli, Julie Song, Kelvin Wong

The software and associated documentation files are licensed under the MIT License. You may find a copy of the license as [`LICENSE.md`](./LICENSE.md).

The report texts are licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 (CC BY-NC-ND 4.0) License. A copy of the license can be found as [`LICENSE-CC-BYNCND.md`](./LICENSE-CC-BYNCND.md).

## References

The Manhattan Chocolate Society, 2022, "Chocolate Bar Ratings", Flavors of Cocoa [Online]. Available: <http://flavorsofcacao.com/chocolate_database.html>

Thomas Mock (2022). Tidy Tuesday: A weekly data project aimed at the R ecosystem. <https://github.com/rfordatascience/tidytuesday>. 
