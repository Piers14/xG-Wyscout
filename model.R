# Simple logistic regression model
logreg_model <- glm(data = train_shots, is_scored ~ angle + distance + shot_type + is_counter, family = binomial)
val_preds <- predict(logreg_model, val_shots, type = "response")