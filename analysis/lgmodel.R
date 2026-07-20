# Elastic Net tuning without PageValues

library(tidyverse)
library(tidymodels)
library(glmnet)
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


# Create stratified training and test sets
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


# Specify Elastic Net model
elastic_model <- logistic_reg(
  penalty = tune(),
  mixture = tune()
) %>%
  set_engine("glmnet") %>%
  set_mode("classification")


# Create workflow
elastic_wf <- workflow() %>%
  add_recipe(data_recipe) %>%
  add_model(elastic_model)


# Create tuning grid
en_grid <- grid_regular(
  penalty(),
  mixture(range = c(0, 1)),
  levels = 10
)


# Tune the model
els_tune <- tune_grid(
  elastic_wf,
  resamples = data_folds,
  grid = en_grid,
  metrics = metric_set(roc_auc)
)


# Save tuning results
save(
  els_tune,
  file = "lgmodel_no_page_values.rda"
)
