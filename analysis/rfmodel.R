# Random Forest tuning without PageValues

library(tidyverse)
library(tidymodels)
library(ranger)
library(janitor)


# Load and prepare data
data <- read_csv(
  file.choose(),
  show_col_types = FALSE
) %>%
  clean_names() %>%
  mutate(
    revenue = factor(
      revenue,
      levels = c("TRUE", "FALSE")
    ),
    across(
      c(
        month,
        weekend,
        visitor_type,
        operating_systems,
        browser,
        region,
        traffic_type
      ),
      as.factor
    )
  )


# Create stratified training set
set.seed(2026)

data_split <- initial_split(
  data,
  prop = 0.75,
  strata = revenue
)

data_train <- training(data_split)


# Create preprocessing recipe
data_recipe <- recipe(
  revenue ~ .,
  data = data_train
) %>%
  step_rm(page_values) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())


# Create stratified cross-validation folds
data_folds <- vfold_cv(
  data_train,
  v = 5,
  strata = revenue
)


# Specify Random Forest model
rf_model <- rand_forest(
  mtry = tune(),
  trees = 500,
  min_n = tune()
) %>%
  set_engine(
    "ranger",
    importance = "impurity"
  ) %>%
  set_mode("classification")


# Create workflow
rf_wf <- workflow() %>%
  add_recipe(data_recipe) %>%
  add_model(rf_model)


# Create tuning grid
rf_grid <- grid_regular(
  mtry(range = c(2, 20)),
  min_n(range = c(5, 30)),
  levels = 5
)


# Tune the model
tune_class <- tune_grid(
  rf_wf,
  resamples = data_folds,
  grid = rf_grid,
  metrics = metric_set(roc_auc)
)


# Save tuning results
save(
  tune_class,
  file = "rfmodel_no_page_values.rda"
)