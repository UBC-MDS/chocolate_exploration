# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-26

"""This script creates a kNN using the preprocessed input features from the
chocolate exploration dataset. It dumps a tuned kNN model.

Usage: ./src/models/chocolate_knn.py --train=<training_ds> --output=<output_folder> --output-cv=<output_cv_folder>

Options:
--train=<training_ds>          Path to the training dataset, which is a .csv file
--output=<output_folder>       Path to the folder to save the modelling output to
--output-cv=<output_cv_folder> Path to the folder to save the CV score files to
"""

import numpy as np
from docopt import docopt
from scipy.stats import uniform, randint
from sklearn.pipeline import make_pipeline
from sklearn.neighbors import KNeighborsRegressor
import os

from ..preprocessor.chocolate import preprocessor
from .base_chocolate_model_tuner import BaseChocolateModelTuner


class ChocolateKNNTuner(BaseChocolateModelTuner):
    def __init__(self):
        super().__init__()
        self.tuned_file_name = "tuned_knn.joblib"
        self.cv_file_name = "cv_results_knn.csv"

    def create_pipeline(self):
        """
        Create pipeline

        Returns
        -------
        sklearn.pipeline.Pipeline : the pipeline to run tuning on
        """
        return make_pipeline(preprocessor, KNeighborsRegressor())

    def param_distribution(self):
        """
        Get param distribution

        Returns
        -------
        dict :
            a dictionary pair to be passed to `RandomizedSearchCV` as
            `param_dist`
        """
        # `columntransformer__countvectorizer__max_features` is inherited
        return super().param_distribution() | {
            "kneighborsregressor__leaf_size": uniform(5, 500),
            "kneighborsregressor__n_neighbors": randint(low=1, high=100),
            "kneighborsregressor__weights": ['uniform', 'distance']
        }


opt = docopt(__doc__)

if __name__ == "__main__":
    train_df_path = opt["--train"]
    assert os.path.isfile(train_df_path), "Please check the input filepath"
    tuner = ChocolateKNNTuner()
    tuner.tune_and_dump(
        train_df_path=train_df_path, model_dump_dir=opt["--output"],
        cv_score_output_dir=opt["--output-cv"])
