# ============================================================
# Logistic Regression for Diabetes Prediction
# Pima Indians Diabetes Dataset
# ------------------------------------------------------------
# Author: Mònica Rodríguez Gómez
# Dataset: PimaIndiansDiabetes (mlbench), n = 768
# ============================================================

# ------------------------------------------------------------
# 0. Setup
# ------------------------------------------------------------

library(mlbench)
library(ggplot2)
library(caret)

set.seed(123)

# ------------------------------------------------------------
# 1. Data Loading and Exploration
# ------------------------------------------------------------

data(PimaIndiansDiabetes)
datos2 <- PimaIndiansDiabetes

dim(datos2)        # 768 observations, 9 variables
str(datos2)
summary(datos2)

# Check zero values in continuous variables
sapply(datos2[, c("glucose", "pressure", "triceps", "insulin", "mass")],
       function(x) sum(x == 0))

# ------------------------------------------------------------
# 2. Exploratory Data Analysis
# ------------------------------------------------------------

# 2.1 Distribution of quantitative variables
par(mfrow = c(2, 2))
for (x in names(datos2)[1:8]) {
  hist(datos2[[x]], main = x, xlab = "Observed value",
       col = "lightblue", border = "white")
}

# 2.2 Log transformations for skewed variables
par(mfrow = c(2, 2))
hist(datos2$insulin, col = "lightblue", border = "white",
     main = "insulin", xlab = "")
hist(log(datos2$insulin), col = "tomato", border = "white",
     main = "log(insulin)", xlab = "")
hist(datos2$pedigree, col = "lightblue", border = "white",
     main = "pedigree", xlab = "")
hist(log(datos2$pedigree), col = "tomato", border = "white",
     main = "log(pedigree)", xlab = "")

# ------------------------------------------------------------
# 3. Missing Data Handling (Zero Imputation)
# ------------------------------------------------------------

variables <- c("glucose", "pressure", "triceps", "insulin", "mass")

for (v in variables) {
  datos2[[v]][datos2[[v]] == 0] <- NA
  datos2[[v]][is.na(datos2[[v]])] <- median(datos2[[v]], na.rm = TRUE)
}

# ------------------------------------------------------------
# 4. Relationship Between Age and Glucose
# ------------------------------------------------------------

ggplot(datos2, aes(x = age, y = glucose)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  geom_smooth(method = "lm", se = TRUE, linetype = "dashed", color = "red") +
  labs(title = "Relationship between age and glucose") +
  theme_minimal()

cor(datos2$age, datos2$glucose, use = "complete.obs")

# ------------------------------------------------------------
# 5. Logistic Regression Model
# ------------------------------------------------------------

m2_log <- glm(
  diabetes ~ pregnant + glucose + pressure + triceps +
    log(insulin) + mass + log(pedigree) + age,
  data = datos2, family = "binomial"
)
summary(m2_log)

# Odds ratios
OR <- exp(coef(m2_log))
OR

# ------------------------------------------------------------
# 6. Model Evaluation
# ------------------------------------------------------------

# Predicted probabilities
log_pred <- predict(m2_log, type = "response")

# Classification with threshold 0.5
pred_clas <- ifelse(log_pred > 0.5, "pos", "neg")
pred_clas <- factor(pred_clas, levels = c("neg", "pos"))
datos2$diabetes <- factor(datos2$diabetes, levels = c("neg", "pos"))

# Confusion matrix
table(Predicted = pred_clas, Actual = datos2$diabetes)

conf_mat <- confusionMatrix(pred_clas, datos2$diabetes, positive = "pos")
conf_mat

# ------------------------------------------------------------
# 7. Prediction for a New Individual
# ------------------------------------------------------------

nuevo <- data.frame(
  pregnant = 1,
  glucose  = 150,
  pressure = 80,
  triceps  = median(datos2$triceps),
  insulin  = 180,
  mass     = 35,
  pedigree = 0.8,
  age      = 50
)

prob_nueva <- predict(m2_log, newdata = nuevo, type = "response")
prob_nueva

# ------------------------------------------------------------
# 8. Session Information
# ------------------------------------------------------------

sessionInfo()