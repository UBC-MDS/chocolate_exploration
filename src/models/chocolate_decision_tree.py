# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-26

"""This script creates a Decision Tree model using the preprocessed input
features from the chocolate exploration dataset. It dumps a tuned decision
tree model.

Usage: src/models/chocolate_decision_tree.py --train=<training_ds> --output=<output_folder> --output-cv=<output_cv_folder>

Options:
--train=<training_ds>          Path to the training dataset, which is a .csv file
--output=<output_folder>       Path to the folder to save the modelling output to
--output-cv=<output_cv_folder> Path to the folder to save the CV score files to
"""

from docopt import docopt
from scipy.stats import randint
from sklearn.pipeline import make_pipeline
from sklearn.tree import DecisionTreeRegressor

from ..preprocessor.chocolate import preprocessor
from .base_chocolate_model_tuner import BaseChocolateModelTuner


class ChocolateDecisionTreeTuner(BaseChocolateModelTuner):
    def __init__(self):
        super().__init__()
        self.tuned_file_name = "tuned_decision_tree.joblib"
        self.cv_file_name = "cv_results_decision_tree.csv"

    def create_pipeline(self):
        """
        Create pipeline

        Returns
        -------
        sklearn.pipeline.Pipeline : the pipeline to run tuning on
        """

        return make_pipeline(preprocessor, DecisionTreeRegressor())

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
            "decisiontreeregressor__max_depth": randint(low=1, high=30)
        }


opt = docopt(__doc__)

if __name__ == "__main__":
    tuner = ChocolateDecisionTreeTuner()
    tuner.tune_and_dump(
        train_df_path=opt["--train"], model_dump_dir=opt["--output"],
        cv_score_output_dir=opt["--output-cv"])
