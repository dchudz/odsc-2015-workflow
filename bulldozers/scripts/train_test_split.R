library(dplyr)
library(readr)

library(pipelinehelpers)

set.seed(0)

args <- command_args_unless_interactive(
  c("working/train_test_split/_", "working//cleaned_input.csv"))

split_dir <- pipeline_output_directory(args[1])
cleaned_input_file <- pipeline_input_file(args[2])
cleaned_input <- read_csv(cleaned_input_file)

cleaned_input$SplitAssignment <- sample(c("Train", "Test"), replace=TRUE, size=nrow(cleaned_input))
split <- split(cleaned_input, cleaned_input$SplitAssignment)

write_csv(split$Train, file.path(split_dir, "train.csv"))
write_csv(split$Test, file.path(split_dir, "test.csv"))
