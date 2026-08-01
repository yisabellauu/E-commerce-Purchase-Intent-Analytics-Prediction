# E-commerce Purchase Intent Analytics & Prediction

An end-to-end analytics project combining MySQL, Tableau, R, and
machine learning to analyze e-commerce conversion behavior and predict
whether a browsing session will result in a purchase.

## Quick Links
- **[Prediction Report](https://yisabellauu.github.io/E-commerce-Purchase-Intent-Analytics-Prediction/)
- **[Interactive Tableau dashboard](https://public.tableau.com/views/Onlineshoppers/Dashboard1)

## Project Overview

This project analyzes 12,330 e-commerce browsing sessions to understand conversion patterns and identify sessions with higher purchase intent.

The project combines:

- MySQL data preparation and conversion analysis
- An interactive Tableau conversion dashboard
- Exploratory data analysis in R
- Comparison of four classification models
- Prediction-time leakage assessment
- Cross-validated classification threshold selection

## Business Questions

- What is the overall purchase conversion rate?
- How does conversion differ by visitor type?
- Which traffic sources generate higher-converting sessions?
- How does conversion vary across months?
- How is product-page engagement related to purchase behavior?
- Can browsing behavior be used to predict purchase intent?
- Which probability threshold provides a useful balance between
  precision and recall?

## Tools

- **MySQL:** Data transformation and reusable conversion views
- **Tableau:** Interactive conversion dashboard
- **R:** Exploratory analysis and predictive modeling
- **Tidymodels:** Preprocessing, cross-validation, tuning, and evaluation
- **XGBoost:** Final Gradient-Boosted Trees model


## Project Workflow

1. Imported and transformed the session-level dataset in MySQL.
2. Created reusable SQL views for conversion reporting.
3. Built an interactive Tableau dashboard.
4. Conducted exploratory analysis in R.
5. Compared Elastic Net, Random Forest, Gradient-Boosted Trees, and SVM.
6. Identified and removed `PageValues` because of potential prediction-time
   leakage.
8. Re-trained all four models using five-fold cross-validation.
9. Selected a classification threshold using cross-validated training
   predictions.
10. Evaluated the final model on a held-out test set.

## Interactive Dashboard

[View the interactive Tableau dashboard](https://public.tableau.com/views/Onlineshoppers/Dashboard1)

![E-commerce Conversion Dashboard](images/dashboard_preview.png)

The dashboard explores conversion performance by:

- Visitor type
- Traffic source
- Month
- Product-page engagement level

## Predictive Modeling

Four classification models were compared using mean cross-validated
ROC-AUC.

| Model | Mean ROC-AUC |
|---|---:|
| Gradient-Boosted Trees | 0.783 |
| Random Forest | 0.776 |
| Elastic Net | 0.745 |
| Support Vector Machine | 0.665 |

Gradient-Boosted Trees achieved the highest mean cross-validated
ROC-AUC, although Random Forest produced a closely comparable result.

### Final Model Performance

The deployment-oriented model excluded `PageValues` and was evaluated
on a held-out test set.

| Metric | Result |
|---|---:|
| ROC-AUC | 0.791 |
| PR-AUC | 0.376 |
| Recall | 58.5% |
| Specificity | 79.8% |

The classification threshold was selected using cross-validated
training predictions rather than the held-out test set.

## PageValues and Prediction-Time Leakage

An initial full-feature benchmark achieved a test ROC-AUC of 0.943.
However, `PageValues` dominated feature importance and may contain
information closely associated with completed transactions.

Because its availability before purchase could not be confirmed, it was
excluded from the final deployment-oriented model. Performance decreased
after its removal, showing that the original benchmark relied heavily on
this variable.

The revised model provides a more conservative and operationally
realistic estimate of purchase-prediction performance.

## Key Findings

- The dataset is substantially imbalanced, with approximately 15.5% of
  browsing sessions resulting in a purchase.
- Product-related browsing activity is associated with conversion.
- Conversion performance differs across visitor types, traffic sources,
  months, and engagement levels.
- Gradient-Boosted Trees and Random Forest produced the strongest
  cross-validated ranking performance.
- The default 0.50 classification threshold was too conservative after
  `PageValues` was removed.
- Threshold selection improved the balance between identifying potential
  purchasers and avoiding false-positive targeting.

## Repository Structure

```text

├── analysis/
│   ├── purchase_intent_analysis.Rmd
│   ├── purchase_intent_analysis.html
│   ├── model_tuning_and_results/
├── data/
│   ├── data_dictionary.md
│   └── processed/
├── images/
│   └── dashboard_preview.png
├── sql/
│   ├── 01_create_cleaned_table.sql
│   ├── 02_create_summary_views.sql
│   └── README.md
├── tableau/
│   ├── ecommerce_conversion_dashboard.twbx
│   └── README.md
├── LICENSE
└── README.md
