# Logistic Regression for Diabetes Prediction

**Author:** Mònica Rodríguez Gómez  
**Dataset:** Pima Indians Diabetes (`mlbench`, n = 768)  
**Tools:** R, mlbench, ggplot2, caret

---

## Overview

This project applies **logistic regression** to predict diabetes status from clinical and anthropometric variables in the Pima Indians Diabetes dataset. The analysis covers:

- Exploratory data analysis and distribution assessment
- Handling of missing values encoded as zeros (median imputation)
- Log transformations for skewed variables
- Logistic regression modelling and odds ratio interpretation
- Model evaluation via confusion matrix, sensitivity, specificity, and balanced accuracy
- Prediction for a new individual

The goal is to illustrate how statistical modelling can support **clinical risk assessment** using routinely collected data.

---

## Data

The dataset contains **768 observations** and **9 variables**:

- `pregnant`: number of pregnancies
- `glucose`: plasma glucose concentration
- `pressure`: diastolic blood pressure (mm Hg)
- `triceps`: triceps skin fold thickness (mm)
- `insulin`: 2-hour serum insulin (mu U/ml)
- `mass`: body mass index (kg/m²)
- `pedigree`: diabetes pedigree function
- `age`: age (years)
- `diabetes`: factor with two levels (`neg`, `pos`)

Several variables contain zeros that are physiologically implausible and were treated as missing values.

---

## Methods

### 1. Exploratory Data Analysis
- Histograms of all quantitative variables
- Assessment of skewness
- Log transformations for `insulin` and `pedigree`

### 2. Missing Data Handling
- Zeros in `glucose`, `pressure`, `triceps`, `insulin`, and `mass` were replaced with `NA`
- Missing values were imputed with the **median** of each variable

### 3. Relationship Between Age and Glucose
- Scatterplot with LOESS and linear regression smoothers
- Pearson correlation

### 4. Logistic Regression
- Model: `diabetes ~ pregnant + glucose + pressure + triceps + log(insulin) + mass + log(pedigree) + age`
- Odds ratios for interpretation

### 5. Model Evaluation
- Confusion matrix (threshold = 0.5)
- Accuracy, sensitivity, specificity, balanced accuracy

### 6. Prediction
- Probability of diabetes for a new individual with specified clinical values

---

## Key Results

### Model Summary
- Globally significant model.
- Significant predictors: `pregnant`, `glucose`, `mass`, `log(pedigree)`.
- Non-significant predictors: `pressure`, `triceps`, `log(insulin)`, `age`.

### Odds Ratios
- `pregnant`, `glucose`, `mass`, and `log(pedigree)` increase the odds of diabetes.
- `log(pedigree)` shows the strongest effect.
- `pressure` shows an odds ratio below 1, suggesting little contribution.

### Confusion Matrix (threshold = 0.5)

|            | Actual neg | Actual pos |
|------------|------------|------------|
| Predicted neg | 439 | 115 |
| Predicted pos | 61  | 153 |

- **Accuracy:** 77.08%
- **Sensitivity:** 57.09%
- **Specificity:** 87.80%
- **Balanced accuracy:** 72.44%

The model is better at identifying healthy individuals than diabetic ones; nearly half of positive cases are missed (false negatives), which is clinically relevant.

### New Individual Prediction
For a woman with 1 pregnancy, glucose = 150, pressure = 80, median triceps, insulin = 180, mass = 35, pedigree = 0.8, and age = 50:

**Predicted probability of diabetes: 0.639 (63.9%)**

---

## Conclusions

- Logistic regression provides an interpretable framework for clinical risk prediction.
- Median imputation and log transformations improve data quality and model stability.
- The model shows high specificity but moderate sensitivity, highlighting the trade-off between false positives and false negatives in clinical settings.
- Future work could explore **piecewise regression** for the non-linear age–glucose relationship, **regularized logistic regression** (LASSO/Ridge), or **longitudinal models** for repeated clinical measurements.

---

## Requirements

- R (>= 4.0)
- Packages: `mlbench`, `ggplot2`, `caret`

```r
install.packages(c("mlbench", "ggplot2", "caret"))

