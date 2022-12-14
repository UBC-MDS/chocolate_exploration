from sklearn.compose import make_column_transformer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import (
    FunctionTransformer, MultiLabelBinarizer, OneHotEncoder, OrdinalEncoder,
    StandardScaler
)
import pandas as pd
import numpy as np
from .my_multi_label_binarizer import MyMultiLabelBinarizer

# Ingredient list
INGREDIENTS = [
    'B',   # Beans
    'S',   # Sugar
    'S*',  # Sweetener other than white cane or beet sugar
    'C',   # Cocoa Butter,
    'V',   # Vanilla,
    'L',   # Lecithin,
    'Sa',  # Salt
]

preprocessor = make_column_transformer(
    (
        OneHotEncoder(handle_unknown='ignore', min_frequency=20),
        [
            'company_location'
        ]
    ),
    (
        OneHotEncoder(handle_unknown='ignore', min_frequency=10),
        [
            'country_of_bean_origin'
        ]
    ),
    (
        OrdinalEncoder(),
        [
            'review_date'
        ]
    ),
    (
        # pipeline-1
        make_pipeline(
            # convert ingredients to set
            FunctionTransformer(lambda df:
                                [set(x[3:].split(',')) if isinstance(x, str)
                                 else set({})
                                 for x in df['ingredients']]),
            MyMultiLabelBinarizer(classes=INGREDIENTS)
        ),
        [
            'ingredients'
        ]
    ),
    (
        # pipeline-2
        make_pipeline(
            # drop the '%' from the strings
            FunctionTransformer(lambda df: df.apply(
                lambda x: x.str[:-1], axis=1)),
            StandardScaler()
        ),
        [
            'cocoa_percent'
        ]
    ),
    (
        # pipeline-3
        make_pipeline(
            # extract number of ingredients in the chocolate
            FunctionTransformer(lambda df: 
                                df.apply(
                                    axis=1, 
                                    func = lambda x: x.str[0])
                                .replace(np.nan,'0')
                                .applymap(ord)-48),
            StandardScaler()
        ),
        [
            'ingredients'
        ]
    ),
    (
        CountVectorizer(stop_words='english'),
        'most_memorable_characteristics'
    ),
    (
        'drop',
        [
            'ref',
            'specific_bean_origin_or_bar_name'
        ]
    )
)
