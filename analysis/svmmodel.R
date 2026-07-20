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


# Create preprocessing recipe
data_recipe <- recipe(
  revenue ~ .,
  data = data_train
) %>%
  step_rm(page_values) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())

data_folds <- vfold_cv(data_train, v = 5, strata = revenue)

svm_rbf_spec <- svm_rbf(
  cost = tune()) %>%
  set_mode("classification") %>%
  set_engine("kernlab")

svm_rbf_wkflow <- workflow() %>% 
  add_recipe(data_recipe) %>% 
  add_model(svm_rbf_spec)

svm_grid <- grid_regular(cost(), levels = 5)

svm_tune <- tune_grid(
  svm_rbf_wkflow, 
  resamples = data_folds,       
  grid = svm_grid,
  control = control_grid(verbose = TRUE) 
)

save(svm_tune, file = "svmmodel_no_page_values.rda")