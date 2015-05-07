library(dplyr)
library(readr)
source("src/arg_helpers.R")

args <- command_args_unless_interactive(
  c("working/train_test_split/_", "input/Train.csv", "input/Machine_Appendix.csv"))

split_dir <- pipeline_output_directory(args[1])
original_train_file <- pipeline_input_file(args[2])
machine_file <- pipeline_input_file(args[3])

original_train <- read_csv(original_train_file)
machine <- read_csv(machine_file)

selected_columns_and_joined <- left_join(original_train[c(1:3, 5:10)], machine, by="MachineID")

split_assignments <- sample(c("train", "test"), replace=TRUE, size=nrow(selected_columns_and_joined))
split <- split(selected_columns_and_joined, split_assignments)

write_csv(split$train, file.path(split_dir, "train.csv"))
write_csv(split$test, file.path(split_dir, "test.csv"))