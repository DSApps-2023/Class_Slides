library(tidyverse)
library(tidymodels)

food_test <- read_rds("C:/Users/gsimchoni/Downloads/food_test_with_categ.rds") %>%
  select(idx, category) %>%
  transmute(idx = idx, true = as.factor(category))

pred_df <- read_csv("C:/Users/gsimchoni/Downloads/model 03-image_model_results.txt") %>%
  select(idx, category) %>%
  transmute(idx = idx, pred = as.factor(category))

(cm <- food_test %>%
    inner_join(pred_df) %>%
    conf_mat(truth = true, estimate = pred))

sum(cm$table) == dim(food_test)[1]

autoplot(cm, type = "heatmap")

food_test %>%
  inner_join(pred_df) %>%
  accuracy(truth = true, estimate = pred)
