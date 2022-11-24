# TODO: Delete me!

import pandas as pd
from sklearn.pipeline import make_pipeline

from preprocessor import preprocessor


train_df = pd.read_csv('./data/raw/train_df.csv')

target = 'rating'

X_train = train_df.drop(columns=[target])
y_train = train_df[target]

pipe = make_pipeline(
    preprocessor,
    # TODO: Model here
)

# For demo purpose only
# TODO: Replace with `RandomizedSearchCV`
transformed = pipe.fit_transform(X_train)
print(transformed.shape)
print(pipe.named_steps['columntransformer'].named_transformers_['pipeline-1'].named_steps['mymultilabelbinarizer'].encoder.classes)
