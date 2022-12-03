# Chocolate Exploration

> Authors: Manvir Kohli, Julie Song, Kelvin Wong
>
> Project complete in accordance with DSCI 522 for the UBC MDS Program 2022-23 for Group 15

## About

"Given the characteristics of a new dark chocolate, what will be its predicted rating on a scale of 1 to 5?" This is the predictive research question that we have set out to answer. Using this information, perhaps we can predict how well-received a new dark chocolate product may be.

Four regression models were built to answer this question: k-nearest neighbors, RIDGE (linear regression), support vector machines with a radial basis function kernel, and a decision tree. All four models were compared using mean absolute percentage error, and performed fairly well on the test data set. The worst model was the decision tree with 11% error, while the best model was the SVM RBF model with 8.6% error. Although the errors are quite small, because the rating scale only extends from 1 to 5, it would be best to minimize this error as much as possible. Thus, improvements to the model are recommended before it may be put to practical use.

The data set is from [Flavors of Cacao](http://flavorsofcacao.com/chocolate_database.html), where the Manhattan Chocolate Society (headed by Brady Brelinski) has reviewed 2,500+ bars of craft chocolate since 2006. The findings have been compiled into a copy-paste-able table that lists each bar's manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The data set we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday) using the following raw URL:

    https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv

It can also be downloaded using the instructions below.

## Report

The final report can be found [here](doc/chocolate_exploration_results_report.pdf). 

## Usage

If you are interested in just running the exploration project, you can use [Docker](https://www.docker.com/) or [Podman](https://podman.io), by downloading from the Docker Hub:

```bash
# WIP here
# TODO: implement me!
```

You may refer to the [`Dockerfile`](./Dockerfile) for more information.

## Usage (Advanced)

Alternatively, if you are interested in contributing, hacking, or simply running locally without using VMs, make sure your computer has R _and_ Python development environment set up. IDEs like [R Studio](https://posit.co/products/open-source/rstudio/) and [Visual Studio Code](https://code.visualstudio.com/) are optional but recommended.

It is highly recommended to have GNU toolchain configured and set up, in particular [GNU Make](https://www.gnu.org/software/make/).

The following flowchart gives an overview for the script workflow:

![Figure 1, Flowchart for scripts and workflow](flowchart.png)

### Download the code

The latest copy of this code can be downloaded by:

```bash
git clone https://github.com/UBC-MDS/chocolate_exploration.git
cd chocolate_exploration
```

### Install the dependencies

The EDA and report texts are written in R, and the packages can be installed by:

```bash
R -e 'install.packages(c("caTools","cowplot","docopt","dplyr","kableExtra","knitr","magick","rmarkdown","tidyverse","webshot"))'
```

The versions used in the development can be confirmed by:

```bash
R -e 'for (p in c("caTools","cowplot","docopt","dplyr","kableExtra","knitr","magick","rmarkdown","tidyverse","webshot")) { print(paste0(p, "==", packageVersion(p))) }'
```

Which should show:

```
[1] "caTools==1.18.2"
[1] "cowplot==1.1.1"
[1] "docopt==0.7.1"
[1] "dplyr==1.0.10"
[1] "kableExtra==1.3.4"
[1] "knitr==1.41"
[1] "magick==2.7.3"
[1] "rmarkdown==2.18"
[1] "tidyverse==1.3.2"
[1] "webshot==0.5.4"
```

The actual analyses are written in Python. A [Conda](https://conda.io/) environment file can be found at [`environment.yml`](./environment.yaml).

To create the environment, run this at the project root:

```bash
conda env create -f environment.yaml
```

To activate the environment:

```bash
conda activate chocolate_exploration
```

To deactivate the environment:

```bash
conda deactivate
```

For more information, please refer to the [Conda documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

### Download and split the data set

Aside from the raw URL mentioned above, you may run the following at the project root to download and split the raw dataset:

```bash
make dataset
```

Under the hood, it uses [`src/chocolate_data_download.R`](./src/chocolate_data_download.R) to download the dataset, and uses [`src/train_test_split.R`](./src/train_test_split.R) to process the `chocolate.csv` into a `train_df.csv` and a `test_df.csv` using a 70%-30% split.

### Tune the models

To tune the models, run the following command at the project root:

```bash
make model
```

This command generate `tuned_{model_name}.joblib` under the folder `results/models/` and `cv_results_{model_name}.csv` under the folder `results/cv_scores`.

The scripts of the model tuning can be found in the [`src/models`](./src/models/) folder.

### Check model performance on test data

To score the model on test data, run the following commands at the project root:

```bash
make performance
```

The command does the following:
- aggregates and exports the mean of cross validation results as a csv file under `results/cv_scores_summary.csv`;
- scores all the models' performance on the test data; and
- exports the scores for all the models as a csv file under `results/test_data_results.csv`

### Get the final report as PDF

The final report of the analysis is already included as a PDF, as mentioned above. However in case it is not available, you can run the below command to generate a PDF report under `doc/chocolate_exploration_results_report.pdf`:

```bash
Rscript doc/chocolate_exploration_results_pdf_renderer.R --input_file_path = doc/chocolate_exploration_results_report.rmd
```

## EDA Analysis

You can run the EDA of this dataset using the `chocolate_eda_automated.R` script in the `src` folder. Running the command below saves the results of EDA in the `src/eda_files` folder.

```bash
Rscript src/chocolate_eda_automated.R
```

EDA Results stored by the above script include:
- Summary of null values (`Nulls_table.html`)
- Summary of final features used for modelling (`Final_Features_Table.html`)
- View of the final dataset (`Final_Dataset_View.html`)
- Plots for categorical variables (`Numerical_Plots.png`)
- Plots for categorical variables (`Categorical_Plots.png`)

You can also view the complete EDA summary as a PDF using the below script which renders the `src/chocolate_eda.Rmd` file as a PDF:

```bash
Rscript src/chocolate_eda_rmd_to_pdf_renderer.R --input_file_path = src/chocolate_eda.Rmd
```

## Copyright and Licensing

The CSV files under `data/raw/` directories are works/direct derivative of works from the [Chocolate Bar Ratings database](http://flavorsofcacao.com/chocolate_database.html).

Copyright (c) 2011-2022 Brady Brelinski

Unless otherwise specified, the materials in this repository are covered under this copyright statement:

Copyright (c) 2022 Manvir Kohli, Julie Song, Kelvin Wong

The software and associated documentation files are licensed under the MIT License. You may find a copy of the license at [`LICENSE.md`](./LICENSE.md).

The report texts are licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 (CC BY-NC-ND 4.0) License. A copy of the license can be found at [`LICENSE-CC-BYNCND.md`](./LICENSE-CC-BYNCND.md).

## References

The Manhattan Chocolate Society, 2022, "Chocolate Bar Ratings", Flavors of Cocoa [Online]. Available: <http://flavorsofcacao.com/chocolate_database.html>

Thomas Mock (2022). Tidy Tuesday: A weekly data project aimed at the R ecosystem. <https://github.com/rfordatascience/tidytuesday>. 
