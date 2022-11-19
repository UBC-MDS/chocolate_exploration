# chocolate_exploration

## Download the dataset

The dataset is from Chocolate bar reviews, where the Manhattan Chocolate Society’s Brady Brelinski has reviewed 2,500+ bars of craft chocolate since 2006, and compiles his findings into a copy-paste-able table that lists each bar’s manufacturer, bean origin, percent cocoa, ingredients, review notes, and numerical rating. The dataset we are using is dated 2022-01-12.

A copy of the file can be found from [TidyTuesday project from the R4DS Community](https://github.com/rfordatascience/tidytuesday), and the raw URL is:

```
https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv
```

You may use the included `chocolate_data_download.R` to download, to use it:

```
Rscript src/chocolate_data_download.R --url = https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv --file_path = data/raw/chocolate.csv
```

A `train_test_split.Rmd` in the src/ folder is provided that processes the `chocolate.csv` into `train_df.csv` and `test_df.csv`.

## Copyright and Licensing

The CSV files under `data/raw/` directories are works/direct derivative of works from the [Chocolate Bar Ratings database](http://flavorsofcacao.com/chocolate_database.html).

Copyright (c) 2011-2022 Brady Brelinski

Unless otherwise specified, the materials in this repository are covered under this copyright statement:

Copyright (c) 2022 Manvir Kohli, Julie Song, Kelvin Wong

The software and associated documentation files are licensed under the MIT License. You may find a copy of the license as [`LICENSE.md`](./LICENSE.md).

The report texts are licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 (CC BY-NC-ND 4.0) License. A copy of the license can be found as [`LICENSE-CC-BYNCND.md`](./LICENSE-CC-BYNCND.md).