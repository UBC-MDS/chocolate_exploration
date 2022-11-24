# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-26

"""This script creates a Decision Tree model using the preprocessed input features from the chocolate exploration dataset.
It outputs a tuned decision tree model.

Usage: src/chocolate_DecisionTree.py --train=<training_ds> --output=<output_folder>

Options:
--train=<training_ds>          Path to the training dataset, which is a .csv file
--output=<output_folder>       Path to the folder to save the modelling output to
""" 

from docopt import docopt
from preprocessor import preprocessor
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_validate
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint
from joblib import dump, load
import pandas as pd
import os

opt = docopt(__doc__)

def main(train, output):
    # Load data, split into features and target
    train_df = pd.read_csv(train) #training filepath is "data/raw/train_df.csv"
    X_train = train_df.drop(columns=["rating"])
    y_train = train_df["rating"]
    
    # Create the pipeline for modelling
    pipe = make_pipeline(preprocessor, DecisionTreeClassifier())
    pipe.fit(X_train, y_train)
    
    # Tune hyperparameters
    len_vocab = len(
    pipe.named_steps["columntransformer"]
        .named_transformers_["countvectorizer"]
        .get_feature_names_out()
    )
    
    param_dist = {
    "decisiontreeclassifier__max_depth": randint(low=1, high=30),
    "columntransformer__countvectorizer__max_features": randint(low=100, high=len_vocab)
    }
    
    random_search_dt = RandomizedSearchCV(
        pipe,
        param_distributions=param_dist,
        n_iter=20,
        cv=5,
        n_jobs=-1,
        random_state=522
    )
    
    random_search_dt.fit(X_train, y_train);
    
    try:
        os.makedirs(output)
    except FileExistsError:
        pass
    
    dump(random_search_dt, f'{output}/BestDecisionTreeModel.joblib')
    
if __name__ == "__main__":
    main(opt["--train"], opt["--output"])
