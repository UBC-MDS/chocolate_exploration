# chocolate_exploration

## Download the dataset

The dataset is from Chocolate bar reviews, where the Manhattan Chocolate Society’s Brady Brelinski has reviewed 2,500+ bars of craft chocolate since 2006, and compiles his findings into a copy-paste-able table that lists each bar’s manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The dataset we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday), and the raw URL is:

```
https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv
```

You may use the included `src/chocolate_data_download.R` to download, to use it:

```
Rscript data/src/chocolate_data_download.R --url = https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv --file_path = data/raw/chocolate.csv
```

A `train_test_split.Rmd` is provided in the src/ folder that processes the `chocolate.csv` into `train_df.csv` and `test_df.csv`.
