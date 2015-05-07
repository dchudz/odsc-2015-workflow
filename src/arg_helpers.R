command_args_unless_interactive <- function(args_if_interactive = stop("I need interactive args for interactive use")) {
  args <- if (interactive()) args_if_interactive else command_args()
  return(args)
}

command_args <- function(trailingOnly = TRUE, ...) {
  args <- commandArgs(trailingOnly = trailingOnly, ...)
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
