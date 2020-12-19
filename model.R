# Simple logistic regression model
logreg_model <- glm(data = train_shots, is_scored ~ distance + angle + shot_type + is_counter, family = binomial)
val_preds <- predict(logreg_model, val_shots, type = "response")

# Performance metric - mae
get_mae <- function(actual, predicted){
  if(is.factor(actual[1])){
    actual <- as.numeric(as.character(actual))
  }
  return(mean(abs(actual - predicted)))
}

val_error <- get_mae(val_shots$is_scored, val_preds)


# Neural Network
set.seed(42)
require(caret)
nn_model <- train(is_scored ~ ., data = train_shots, method='nnet', 
               trControl=trainControl(method='cv'))
nn_model
nn_probs <- predict(nn_model, val_shots, type='prob')
head(nn_probs)

set.seed(42)
nn_model_mae <- train(is_scored ~ ., data = train_shots, method='nnet', metric = "AUC",
                  trControl=trainControl(method='cv'))
nn_model
nn_probs_mae <- predict(nn_model_mae, val_shots, type='prob')
head(nn_probs)
get_mae(val_shots$is_scored, nn_probs_mae[,2 ])




