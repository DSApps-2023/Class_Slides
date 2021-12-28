library(tidyverse)
library(tidymodels)

food_test <- read_rds("C:/Users/gsimchoni/Downloads/food_test_with_categ.rds") %>%
  select(idx, category) %>%
  transmute(idx = idx, true = as.factor(category))

file_name <- "model01.txt"
pred_df <- read_csv(str_c("C:/Users/gsimchoni/Downloads/", file_name)) %>%
  select(idx, pred_cat) %>%
  transmute(idx = idx, pred = as.factor(pred_cat))

(cm <- food_test %>%
    inner_join(pred_df) %>%
    conf_mat(truth = true, estimate = pred))

sum(cm$table) == dim(food_test)[1]
sum(is.na(pred_df$pred))
food_test$idx[which(!food_test$idx %in% pred_df$idx)]

autoplot(cm, type = "heatmap")

food_test %>%
  inner_join(pred_df) %>%
  accuracy(truth = true, estimate = pred)

food_test %>%
  inner_join(pred_df) %>%
  accuracy(truth = true, estimate = pred) %>%
  pull(.estimate)
