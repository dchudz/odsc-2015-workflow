
# maybe add in FitExpectations

create_random_forest <- function(...) {
  return(list(
    fit = function(train, target_name, feature_names) {
      fitted <- randomForest(train[feature_names], train[[target_name]], ...)
      return(list(fitted = fitted,
                  feature_names = feature_names))
    },
    predict = function(model, new_data) {
      return(predict(model$fitted, new_data[feature_names]))
    }
  ))
}

create_linear_model <- function(...) {  
  return(list(
    fit=function(train, target_name, feature_names) {
      y <- train[[target_name]]
      return(lm(y ~ ., data=train[feature_names]))
    },
    predict = function(model, new_data) {      
      predictions <- predict(model, new_data)
      return(predictions)
    }
  ))  
}

models <- list(
  rf = create_random_forest(ntree = 2),
  lm = create_linear_model()
)
