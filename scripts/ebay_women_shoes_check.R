library(tidyverse)
library(tidymodels)
library(xtable)
library(ghclass)

setwd("C:/Users/gsimchoni/Class_Slides/")

true_df <- read_rds("C:/Users/gsimchoni/Downloads/ebay_women_shoes_test_with_price.rds") %>%
  select(id, price) %>%
  mutate(true = log(price))

pred_df <- read_csv("C:/Users/gsimchoni/Downloads/model01.csv") %>%
  rename(pred = price_pred)

inner_join(true_df, pred_df) %>%
  ggplot(aes(true, pred)) +
  geom_point(alpha = 0.5, color = "red") +
  geom_smooth(method = "lm") +
  theme_bw()

rmse_vec(true_df$true, pred_df$pred)

# update local copy of leaderboard
leaderboard <- read_csv("leaderboard.csv")

leaderboard <- bind_rows(leaderboard, list(Student="gilaltman8", Model="model01",
                                           RMSE=rmse_vec(true_df$true, pred_df$pred)))
leaderboard <- leaderboard %>% arrange(RMSE)
leaderboard

leaderboard %>% write_csv("leaderboard.csv")

# edit leaderboard html
leaderboard_html <- read_lines("leaderboard.html")

start_table <- which(leaderboard_html == "\t\t\t\t\t<tbody>")
end_table <- which(leaderboard_html == "\t\t\t\t\t</tbody>")

added_table_rows <- str_extract_all(print(xtable(leaderboard, digits = 7),
                                          type = "html", print.results=FALSE),
                                    regex("<tr>.*</tr>"))[[1]]
added_table_rows <- added_table_rows[2:length(added_table_rows)]

leaderboard_html_updated <- c(leaderboard_html[1:start_table],
                              added_table_rows,
                              leaderboard_html[end_table:length(leaderboard_html)])

write_lines(leaderboard_html_updated, "leaderboard.html")

# update remote
local_repo_add(".", c("leaderboard.csv", "leaderboard.html"))
local_repo_commit(".", "Updates leaderboard")
local_repo_push(".", branch = "main")
