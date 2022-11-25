from sklearn.base import TransformerMixin
from sklearn.preprocessing import MultiLabelBinarizer


class MyMultiLabelBinarizer(TransformerMixin):
    """
    A wrapper for `MultiLabelBinarizer` that does not mind taking 3 positional arguments

    This is to resolve `fit_transform() takes 2 positional arguments but 3 were given` error.

    Adopted from https://stackoverflow.com/a/46619402

    Attributes
    ----------
    encoder : MultiLabelBinarizer
        The wrapped `MultiLabelBinarizer`

    Methods
    -------
    fit(x, y = None)
        Run `encoder.fit(x)`.
    transform(x, y = None)
        Run `encoder.transform(x)`

    """
    def __init__(self, *args, **kwargs):
        self.encoder = MultiLabelBinarizer(*args, **kwargs)

    def fit(self, x, y = None):
        self.encoder.fit(x)
        return self

    def transform(self, x, y = None):
        return self.encoder.transform(x)
