# tuning without PageValues

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

bt_class_spec <- boost_tree(mtry = tune(), 
                            trees = tune(), 
                            learn_rate = tune()) %>%
  set_engine("xgboost") %>% 
  set_mode("classification")

bt_class_wf <- workflow() %>% 
  add_model(bt_class_spec) %>% 
  add_recipe(data_recipe)

bt_grid <- grid_regular(
  mtry(range = c(2, 20)),           
  trees(range = c(100, 500)), 
  learn_rate(range = c(-3, -1)),     
  levels = 4                      
)

tune_bt_class <- tune_grid(
  bt_class_wf,
  resamples = data_folds,
  grid = bt_grid,
  control = control_grid(verbose = TRUE)
)

save(tune_bt_class, file = "btmodel_no_page_values.rda")