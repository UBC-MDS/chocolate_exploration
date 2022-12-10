# author: Manvir Kohli, Julie Song, Kelvin Wong
# date: 2022-11-25

"""This script takes multiple models as inputs and calculates their performance
on test data based on R^2 score and Mean Absolute Percentage Error

Usage: ./src/test_data_performance.py

"""
import numpy as np
import pandas as pd
from docopt import docopt
from scipy.stats import uniform
from sklearn.pipeline import make_pipeline
from sklearn.neighbors import KNeighborsRegressor
from sklearn.svm import SVR
from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import Ridge
from joblib import dump, load
import pickle
import os
from sklearn.metrics import mean_absolute_percentage_error,r2_score
    
def main():
    """
    Checks model performance on test data for 
    Decision Tree, KNN, SVM RBF and Ridge Regression. 
    The function takes no inputs and stores the output to /results

    Parameters
    ----------
    None
    Returns
    -------
    A summary of cross validation scores under 'results/'cv_scores_summary.csv'
    A summary of model performanceon test data  under 'test_data_results.csv'

    Examples
    --------
    >>> main()
    """
    
    ## Loading,aggregating and exporting CV Scores
    
    dt_cv = pd.read_csv('results/cv_scores/cv_results_decision_tree.csv')
    knn_cv = pd.read_csv('results/cv_scores/cv_results_knn.csv')
    ridge_cv = pd.read_csv('results/cv_scores/cv_results_ridge.csv')
    svm_cv = pd.read_csv('results/cv_scores/cv_results_svm_rbf.csv')
    rf_cv = pd.read_csv('results/cv_scores/cv_results_random_forest.csv')
    
    
    dt_cv = pd.DataFrame(dt_cv[[i for i in dt_cv.columns if "mean" in i]].mean(),columns=["Decision Tree"])
    knn_cv = pd.DataFrame(knn_cv[[i for i in knn_cv.columns if "mean" in i]].mean(),columns=["KNN"])
    ridge_cv = pd.DataFrame(ridge_cv[[i for i in ridge_cv.columns if "mean" in i]].mean(),columns=["Ridge"])
    svm_cv = pd.DataFrame(svm_cv[[i for i in svm_cv.columns if "mean" in i]].mean(),columns=["SVM RBF"])
    rf_cv = pd.DataFrame(rf_cv[[i for i in rf_cv.columns if "mean" in i]].mean(),columns=["Random Forest"])
    
    
    cv_results_summary = pd.concat([dt_cv,knn_cv,ridge_cv,svm_cv],axis=1)
    cv_results_summary = (abs(cv_results_summary*100)).round(3)
    cv_results_summary.to_csv('results/cv_scores_summary.csv')

    ## loading test data and models
    test_df = pd.read_csv('data/raw/test_df.csv')
    X_test,y_test = test_df.drop(columns=['rating']),test_df['rating']

    dt_model = load('results/models/tuned_decision_tree.joblib') 
    knn_model = load('results/models/tuned_knn.joblib')
    ridge_model = load('results/models/tuned_ridge.joblib')
    svr_model = load('results/models/tuned_svm_rbf.joblib')
    rf_model = load('results/models/tuned_random_forest.joblib')
    

    ## checking test R^2 scores
#     test_r2_scores = {}
#     dt_r2 =  r2_score(y_test,dt_model.predict(X_test))
#     knn_r2 = r2_score(y_test,knn_model.predict(X_test))
#     ridge_r2 = r2_score(y_test,ridge_model.predict(X_test))
#     svr_r2 = r2_score(y_test,svr_model.predict(X_test))

#     r2_score

#     test_r2_scores['Decision_Tree'] = dt_r2
#     test_r2_scores['KNN'] = knn_r2
#     test_r2_scores['Ridge'] = ridge_r2
#     test_r2_scores['SVM RBF'] = svr_r2

    ## checking MAPE
    test_mapes = {}

    dt_mape =  mean_absolute_percentage_error(y_test,dt_model.predict(X_test))
    knn_mape = mean_absolute_percentage_error(y_test,knn_model.predict(X_test))
    ridge_mape = mean_absolute_percentage_error(y_test,ridge_model.predict(X_test))
    svr_mape = mean_absolute_percentage_error(y_test,svr_model.predict(X_test))
    rf_mape = mean_absolute_percentage_error(y_test,rf_model.predict(X_test))

    test_mapes['Decision_Tree'] = dt_mape
    test_mapes['KNN'] = knn_mape
    test_mapes['Ridge'] = ridge_mape
    test_mapes['SVM RBF'] = svr_mape
    test_mapes['Random Forest'] = rf_mape                    

    # scores_df = pd.DataFrame(test_r2_scores,index=['R^2 (%)'])
    mape_df = pd.DataFrame(test_mapes,index=['MAPE (%)']).T

    # test_data_results = pd.concat([scores_df,mape_df],axis = 0)
    test_data_results = (mape_df*100).round(3)

    test_data_results.to_csv('results/test_data_results.csv')

    test_data_results

    opt = docopt(__doc__)

if __name__ == "__main__":
    main()