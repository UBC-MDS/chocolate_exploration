# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-26

"""This script creates an SVM RBF (Support Vector Machine with Radial Basis Function kernel) model using the preprocessed input features from the chocolate exploration dataset.
It outputs a tuned SVM RBF model.

Usage: src/chocolate_svmrbf_model.py --train=<training_ds> --output=<output_folder>

Options:
--train=<training_ds>          Path to the training dataset, which is a .csv file
--output=<output_folder>       Path to the folder to save the modelling output to
""" 

from docopt import docopt
from ..preprocessor.chocolate import preprocessor
from sklearn.svm import SVR
from sklearn.model_selection import cross_validate
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint, loguniform
import pickle
import dill
import pandas as pd
import os

opt = docopt(__doc__)

def main(train, output):
    # Load data, split into features and target
    train_df = pd.read_csv(train)
    X_train = train_df.drop(columns=["rating"])
    y_train = train_df["rating"]
    
    # Create the pipeline for modelling
    pipe = make_pipeline(preprocessor, SVR())
    pipe.fit(X_train, y_train)
    
    # Tune hyperparameters
    len_vocab = len(
    pipe.named_steps["columntransformer"]
        .named_transformers_["countvectorizer"]
        .get_feature_names_out()
    )
    
    param_dist = {
    "svr__C": loguniform(1e-3, 1e4),
    "columntransformer__countvectorizer__max_features": randint(low=100, high=len_vocab)
    }
    
    random_search_svc = RandomizedSearchCV(
        pipe,
        param_distributions=param_dist,
        n_iter=20,
        cv=5,
        n_jobs=-1,
        random_state=522
    )
    
    random_search_svc.fit(X_train, y_train);
    
    # Check if the directory already exists
    try:
        os.makedirs(output)
    except FileExistsError:
        pass
    
    # Save the model
    with open(f'{output}/tuned_svm_rbf.joblib', 'wb') as file:
        dill.dump(random_search_svc, file)
    
if __name__ == "__main__":
    main(opt["--train"], opt["--output"])
