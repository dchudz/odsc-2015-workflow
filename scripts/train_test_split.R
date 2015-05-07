library(dplyr)
library(readr)
source("src/arg_helpers.R")

set.seed(0)

args <- command_args_unless_interactive(
  c("working/train_test_split/_", "working//cleaned_input.csv"))

split_dir <- pipeline_output_directory(args[1])
cleaned_input_file <- pipeline_input_file(args[2])
cleaned_input <- read_csv(cleaned_input_file)

split_assignments <- sample(c("train", "test"), replace=TRUE, size=nrow(cleaned_input))
split <- split(cleaned_input, split_assignments)
  
write_csv(split$train, file.path(split_dir, "train.csv"))
write_csv(split$test, file.path(split_dir, "test.csv"))
