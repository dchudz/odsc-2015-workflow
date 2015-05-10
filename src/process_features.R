process_features <- function(df) {
  df$saledate <- as.Date(df$saledate, "%m/%d/%Y")
  df$saledate <- as.double(df$saledate)
  df$ProductGroupDesc <- as.factor(df$ProductGroupDesc)
  return(df)
}