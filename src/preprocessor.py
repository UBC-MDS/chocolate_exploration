from sklearn.base import TransformerMixin
from sklearn.compose import make_column_transformer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import FunctionTransformer, MultiLabelBinarizer, OneHotEncoder, StandardScaler


# Ingredient list:
INGREDIENTS = [
    'B',  # Beans
    'S',  # Sugar
    'S*', # Sweetener other than white cane or beet sugar
    'C',  # Cocoa Butter,
    'V',  # Vanilla,
    'L',  # Lecithin,
    'Sa', # Salt
]

# To resolve `fit_transform() takes 2 positional arguments but 3 were given`
# Stolen from: https://stackoverflow.com/a/46619402
class MyMultiLabelBinarizer(TransformerMixin):
    def __init__(self, *args, **kwargs):
        self.encoder = MultiLabelBinarizer(*args, **kwargs)

    def fit(self, x, y = None):
        self.encoder.fit(x)
        return self

    def transform(self, x, y = None):
        return self.encoder.transform(x)

# To use in the models, use `from preprocessor import preprocessor`
preprocessor = make_column_transformer(
    (
        OneHotEncoder(drop='if_binary', handle_unknown="ignore"),
        [
            'company_manufacturer',
            'company_location',
            'country_of_bean_origin'
        ]
    ),
    (
        StandardScaler(),
        [
            'review_date'
        ]
    ),
    (
        # pipeline-1
        make_pipeline(
            # convert ingredients to set
            FunctionTransformer(lambda df: [set(x[3:].split(',')) if isinstance(x, str) else set({}) for x in df['ingredients']]),
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
            FunctionTransformer(lambda df: df.apply(lambda x: x.str[:-1], axis=1)),
            StandardScaler()
        ),
        [
            'cocoa_percent'
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
