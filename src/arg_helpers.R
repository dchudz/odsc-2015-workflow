command_args_unless_interactive <- function(args_if_interactive = stop("I need interactive args for interactive use")) {
  args <- if (interactive()) args_if_interactive else command_args()
  return(args)
}

command_args <- function(trailingOnly = TRUE, ...) {
  args <- commandArgs(trailingOnly = trailingOnly, ...)
  cat("    Input arguments: ")
  dput(args)
  return(args)
}

pipeline_output_directory <- function(path, sentinel = "_") {
  stopifnot(length(path) == 1)
  
  # Check that we have an actual value
  if (is.na(path) || is.null(path)) {
    stop(sprintf("The directory parameter %s is missing or null", path))
  }
  
  # Accept a sentinel file in place of the directory
  if (!is.null(sentinel) && basename(path) == sentinel) {
    path = dirname(path)
  }
  
  directory <- ensure_empty_directory_exists(path)  
  return(directory)
}

ensure_empty_directory_exists <- function(directoryPath) {
  # Make sure a directory exists and is empty, creating or deleting as needed.
  # Example: subpathDir <- EnsureEmptyDirectoryExists(outputDir, "This", "That")

  if (file.exists(directoryPath)) {
    unlink(directoryPath, recursive = TRUE)
  }
  
  dir.create(directoryPath, showWarnings = TRUE, recursive = TRUE)
  
  return(directoryPath)
}

pipeline_input_file <- function(file) {
  assert_is_single_value(file)

  # Input files are checked to make sure they exist
  if(!file.exists(file) || file.info(file)$isdir) {
    stop(sprintf("The file parameter '%s' does not exist", file))
  }
  
  return(file)
}

assert_is_single_value <- function(should_be_single_value) {
  stopifnot(length(should_be_single_value) == 1)
  stopifnot(!is.na(should_be_single_value))
  stopifnot(!is.null(should_be_single_value))
}

pipeline_output_file <- function(path) {
  # Ensure that the parent directory for output files exists and delete existing versions of the file.
  file <- ensure_parent_directory_exists(path)
  
  return(file)
}

ensure_parent_directory_exists <- function(filePath) {
  # Make sure the parent directory of some path exists.
  # Returns the path as a convenience for inline use.
  #
  # Example: Save(content, ensure_parent_directory_exists(path))
  directoryPath <- dirname(filePath)
  
  if (!file.exists(directoryPath)) {
    dir.create(directoryPath, showWarnings = TRUE, recursive = TRUE)
  }
  
  return(filePath)
}

pipeline_input_file_vector <- function(space_separated_paths) {
  split_arg <- function(arg) Filter(function(s) nchar(s) > 0, strsplit(arg, " ")[[1]])
  paths <- split_arg(space_separated_paths)
  stopifnot(length(paths) > 0)
  files <- sapply(paths, pipeline_input_file, USE.NAMES = FALSE)
  return(files)
}
