import dill
import os
import pandas as pd
from scipy.stats import randint
from sklearn.model_selection import RandomizedSearchCV


class BaseChocolateModelTuner():
    """
    Encapsulates all the logic needed to tune a particular family of models.

    It uses `RandomizedSearchCV` in its core. Subclasses should provide their
    own implementation for `create_pipeline` and `param_distribution` for this
    to work.

    Attributes
    ----------
    pipeline : sklearn.pipeline.Pipeline or None
        The pipeline object to run the training with
    search_n_iter : int
        Number of iterations to run our `RandomizedSearchCV` with, defaulted
        to 20
    search_cv : int
        Number of slices in CV, defaulted to 5
    tuned_file_name : str
        Name of the tuned model file, defaulted to `"model.joblib"`
    cv_file_name : str
        Name of the model cross-validation results file, defaulted to `"cv.csv"`
    """

    def __init__(self):
        self.pipeline = None
        self.search_n_iter = 20
        self.search_cv = 5
        self.tuned_file_name = 'model.joblib'
        self.cv_file_name = 'cv.csv'

    def tune_and_dump(self, train_df_path, model_dump_dir):
        """
        Tune a model and then dump to specific directory

        Parameters
        ----------
        train_df_path : str
            Path to the training dataframe CSV file
        model_dump_dir : str
            Path to dump the model to
        """
        TARGET = 'rating'

        # Load data and split into features and target
        train_df = pd.read_csv(train_df_path)
        X_train = train_df.drop(columns=["rating"])
        y_train = train_df["rating"]

        # Create the pipeline for modelling
        self.pipeline = self.create_pipeline()
        self.pipeline.fit(X_train, y_train)

        # Tune hyperparameters
        param_dist = self.param_distribution()

        # Perform `RandomizedSearchCV`
        random_search_cv = RandomizedSearchCV(
            self.pipeline,
            param_distributions=param_dist,
            n_iter=self.search_n_iter,
            cv=self.search_cv,
            n_jobs=-1,
            random_state=522
        )

        random_search_cv.fit(X_train, y_train)

        # Check if the directory already exists
        try:
            os.makedirs(model_dump_dir)
        except FileExistsError:
            pass

        # Save the model
        with open(f'{model_dump_dir}/{self.tuned_file_name}', 'wb') as file:
            dill.dump(random_search_cv, file)
        
        # Create a dataframe with the cross-validation results
        cv_all_results = (
            pd.DataFrame(random_search_cv.cv_results_)
            .set_index("rank_test_score")
            .sort_index()
        )
        
        # Save the cross-validation results
        cv_all_results.to_csv(f'{model_dump_dir}/{self.cv_file_name}')  

    def create_pipeline(self):
        """
        Create pipeline

        Raises
        ------
        NotImplementedError
        """
        raise NotImplementedError("create_pipeline() not properly implemented")

    def param_distribution(self):
        """
        Get param distribution

        Returns
        -------
        dict :
            a dictionary pair to be passed to `RandomizedSearchCV` as
            `param_dist`
        """
        len_vocab = len(
            self.pipeline.named_steps["columntransformer"]
                .named_transformers_["countvectorizer"]
                .get_feature_names_out()
        )

        return {
            "columntransformer__countvectorizer__max_features":
                randint(low=100, high=len_vocab)
        }
