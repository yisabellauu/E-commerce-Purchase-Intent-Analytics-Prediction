# Exploratory Analysis and Predictive Modeling

This folder contains the R analysis used to explore online shopping behavior and train models that predict purchase intent.

## Analysis Components

- Data validation and exploratory data analysis
- Feature preprocessing and engineering
- Train-test split and cross-validation
- Classification model training and comparison
- Final model evaluation
- Model interpretation and business recommendations

## Models

The project compares multiple classification approaches, including:

- Elastic Net Logistic Regression
- Random Forest
- Gradient Boosted Trees
- Support Vector Machine

Model performance is evaluated using appropriate classification metrics, with ROC-AUC used as the primary comparison metric.

## Files

- `purchase_intent_analysis.qmd`: Reproducible analysis and modeling report
- `purchase_intent_analysis.html`: Rendered report for convenient viewing
- Model Tuning:
  `btmodel.R`
  `lgmodel.R`
  `rfmodel.R`
  `svmmodel.R`
- Model Results:
  `btmodel_no_page_values.rda`
  `lgmodel_no_page_values.rda`
  `rfmodel_no_page_values.rda`
  `svmmodel_no_page_values.rda`
