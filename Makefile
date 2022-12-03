ECHO=echo
MKDIR=mkdir
RM=rm
PYTHON=python
RSCRIPT=Rscript

DATA_RAW_DIR=data/raw
DATA_RAW_ORIG_URL=https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-01-18/chocolate.csv
EDA_SOURCE_DIR=src
EDA_OUTPUT_DIR=src/eda_files
MODEL_DIR=results/models
RESULT_DIR=results
RESULT_CV_DIR=results/cv_scores_summary
FINAL_REPORT_DIR=doc

DATA_RAW_ORIG := ${DATA_RAW_DIR}/chocolate.csv
DATA_RAW_TRAIN := ${DATA_RAW_DIR}/train_df.csv
DATA_RAW_TEST := ${DATA_RAW_DIR}/test_df.csv
DATA_RAW := ${DATA_RAW_ORIG} ${DATA_RAW_TRAIN} ${DATA_RAW_TEST}

#EDA_REPORT_SOURCE := ${EDA_SOURCE_DIR}/chocolate_eda.Rmd
#EDA_REPORT_OUTPUT := ${EDA_OUTPUT_DIR}/chocolate_eda.pdf

MODEL_DECISION_TREE := ${MODEL_DIR}/tuned_decision_tree.joblib
MODEL_KNN := ${MODEL_DIR}/tuned_knn.joblib
MODEL_RIDGE := ${MODEL_DIR}/tuned_ridge.joblib
MODEL_SVM_RBF := ${MODEL_DIR}/tuned_svm_rbf.joblib
MODEL_RANDOM_FOREST := ${MODEL_DIR}/tuned_rand_forest.joblib
MODEL_ALL := ${MODEL_DECISION_TREE} ${MODEL_KNN} ${MODEL_RIDGE} ${MODEL_SVM_RBF} ${MODEL_RANDOM_FOREST}

RESULT_CV_DECISION_TREE := ${RESULT_CV_DIR}/cv_results_decision_tree.csv
RESULT_CV_KNN := ${RESULT_CV_DIR}/cv_results_knn.csv
RESULT_CV_RIDGE := ${RESULT_CV_DIR}/cv_results_ridge.csv
RESULT_CV_SVM_RBF := ${RESULT_CV_DIR}/cv_results_svm_rbf.csv
RESULT_CV_RANDOM_FOREST := ${RESULT_CV_DIR}/cv_results_rand_forest.csv
RESULT_CV_ALL := ${RESULT_CV_DECISION_TREE} ${RESULT_CV_KNN} ${RESULT_CV_RIDGE} ${RESULT_CV_SVM_RBF} ${RESULT_CV_RANDOM_FOREST}

RESULT_SUMMARY_SCORE := ${RESULT_DIR}/cv_scores_summary.csv
RESULT_SUMMARY_TEST := ${RESULT_DIR}/test_data_results.csv
RESULT_SUMMARY_ALL := ${RESULT_SUMMARY_SCORE} ${RESULT_SUMMARY_TEST}

FINAL_REPORT_SOURCE := ${FINAL_REPORT_DIR}/chocolate_exploration_results.Rmd
FINAL_REPORT_OUTPUT := ${FINAL_REPORT_DIR}/chocolate_exploration_results.pdf

# ---------------------------------------------------------------------

# Phony targets

.PHONY : all dataset model performance report clean

all : dataset model performance report

dataset : ${DATA_RAW}

# TODO: Implement me!
# Note: remember to update `.PHONY`, `all`, and `clean` targets, too!
# eda : ${EDA}

model : ${MODEL_ALL}

performance : ${RESULT_SUMMARY_ALL}

report : ${FINAL_REPORT_OUTPUT}

clean :
	@echo "\033[0;37m>> \033[0;33mCleaning up intermediate and final outputs\033[0m"
	${RM} -rf ${DATA_RAW} ${MODEL_ALL} ${RESULT_CV_ALL} ${FINAL_REPORT_OUTPUT}

# ---------------------------------------------------------------------

# Dataset

${DATA_RAW_ORIG} :
	@${ECHO} "\033[0;37m>> \033[0;33mDownloading dataset\033[0m"
	${MKDIR} -p ${DATA_RAW_DIR}
	${RSCRIPT} src/chocolate_data_download.R --url = ${DATA_RAW_ORIG_URL} --download_dir = ${DATA_RAW_DIR} --file_name = chocolate.csv 

${DATA_RAW_TRAIN} ${DATA_RAW_TEST} : ${DATA_RAW_ORIG}
	@${ECHO} "\033[0;37m>> \033[0;33mSplitting dataset into training and test splits\033[0m"
	${MKDIR} -p ${DATA_RAW_DIR}
	${RSCRIPT} src/train_test_split.R --input_file = ${DATA_RAW_ORIG}

# ---------------------------------------------------------------------

# EDA

# TODO: Replace me!

# ---------------------------------------------------------------------

# Models

${MODEL_DECISION_TREE} ${RESULT_CV_DECISION_TREE} : ${DATA_RAW_TRAIN}
	@${ECHO} "\033[0;37m>> \033[0;33mTuning model: Decision Tree\033[0m"
	${MKDIR} -p ${MODEL_DIR} ${MODEL_CV_DIR}
	${PYTHON} -m src.models.chocolate_decision_tree --train=${DATA_RAW_TRAIN} --output=${MODEL_DIR} --output-cv=${RESULT_CV_DIR}

${MODEL_KNN} ${RESULT_CV_KNN} : ${DATA_RAW_TRAIN}
	@${ECHO} "\033[0;37m>> \033[0;33mTuning model: kNN\033[0m"
	${MKDIR} -p ${MODEL_DIR} ${MODEL_CV_DIR}
	${PYTHON} -m src.models.chocolate_knn --train=${DATA_RAW_TRAIN} --output=${MODEL_DIR} --output-cv=${RESULT_CV_DIR}

${MODEL_RIDGE} ${RESULT_CV_RIDGE} : ${DATA_RAW_TRAIN}
	@${ECHO} "\033[0;37m>> \033[0;33mTuning model: Ridge\033[0m"
	${MKDIR} -p ${MODEL_DIR} ${MODEL_CV_DIR}
	${PYTHON} -m src.models.chocolate_ridge --train=${DATA_RAW_TRAIN} --output=${MODEL_DIR} --output-cv=${RESULT_CV_DIR}

${MODEL_SVM_RBF} ${RESULT_CV_SVM_RBF} : ${DATA_RAW_TRAIN}
	@${ECHO} "\033[0;37m>> \033[0;33mTuning model: SVM RBF\033[0m"
	${MKDIR} -p ${MODEL_DIR} ${MODEL_CV_DIR}
	${PYTHON} -m src.models.chocolate_svm_rbf --train=${DATA_RAW_TRAIN} --output=${MODEL_DIR} --output-cv=${RESULT_CV_DIR}
    
${MODEL_RANDOM_FOREST} ${RESULT_CV_RANDOM_FOREST} : ${DATA_RAW_TRAIN}
	@${ECHO} "\033[0;37m>> \033[0;33mTuning model: Random Forest\033[0m"
	${MKDIR} -p ${MODEL_DIR} ${MODEL_CV_DIR}
	${PYTHON} -m src.models.chocolate_rand_forest --train=${DATA_RAW_TRAIN} --output=${MODEL_DIR} --output-cv=${RESULT_CV_DIR}

# ---------------------------------------------------------------------

# Performance

${RESULT_CV_SUMMARY} ${RESULT_TEST_RESULTS} : ${MODEL_ALL} ${RESULT_CV_ALL}
	@${ECHO} "\033[0;37m>> \033[0;33mMeasuring performance on test data\033[0m"
	${MKDIR} -p ${RESULT_DIR}
	${PYTHON} -m src.test_data_performance

# ---------------------------------------------------------------------

# Report

${FINAL_REPORT_OUTPUT} : {FINAL_REPORT_SOURCE}
	@{ECHO} "\033[0;37m>> \033[0;33mRendering final report\033[0m"
	${MKDIR} -p ${FINAL_REPORT_DIR}
	${RSCRIPT} doc/chocolate_exploration_results_pdf_renderer.R --input_file_path=${FINAL_REPORT_SOURCE}
