library(readr)

train <- read_csv("working/train_test_split//train.csv")

train$ProductGroupDesc %>% table %>% sort
