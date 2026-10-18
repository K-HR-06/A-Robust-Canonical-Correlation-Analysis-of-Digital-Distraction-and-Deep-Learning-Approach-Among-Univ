# Multivariate Statistics: Digital Distraction and Deep Learning Approach

A Multivariate Statistics group project exploring the relationship between digital distraction and students’ deep learning approach using **Robust Canonical Correlation Analysis (RCCA)**.

Here, deep learning approach refers to how students critically evaluate, understand, and reflect on learning material.

## Dataset

The study uses questionnaire responses from **107 university students**, collected through purposive sampling. The questionnaire contains 24 items rated on a six-point Likert scale, covering six dimensions:

| Digital Distraction | Deep Learning Approach |
|---|---|
| Social Media Urge | Critical Thinking |
| Digital Notification Sensitivity | Conceptual Understanding |
| Attention Fragmentation | Reflective Learning |

`MVN Test.csv` contains the six dimension-average scores used for the main analysis.

## Methods

- Pearson item–total correlations to assess questionnaire items.
- Cronbach’s alpha reliability results documented in the project report.
- Mardia’s tests for multivariate normality.
- Within-group correlation checks.
- Data standardization.
- RCCA using Minimum Covariance Determinant (MCD) covariance estimation.
- Canonical weights, scores, and loadings to interpret the relationship between the two variable groups.

The analysis is implemented in **R**, with `readxl`, `MVN`, and `robustbase`. The supplied script also loads `lavaan`, `semPlot`, and `car`.

## Key Results

The project report presents the following findings:

- Cronbach’s alpha values ranged from **0.886 to 0.936** across the six dimensions.
- Mardia’s tests indicated that both variable groups departed from multivariate normality.
- The first canonical function showed the strongest relationship between the two groups.

| Canonical Function | Canonical Correlation | Squared Correlation |
|---|---:|---:|
| 1 | 0.6476 | 41.94% |
| 2 | 0.2668 | 7.12% |
| 3 | 0.0020 | <0.01% |

The 41.94% value is the squared correlation between the first pair of canonical variates; it does not represent the percentage of variance explained across all original learning dimensions.

For the first function, **Attention Fragmentation** had the largest reported loading within digital distraction (**0.9781**), while **Reflective Learning** had the largest within deep learning approach (**0.9039**).

These findings describe associations in self-reported questionnaire data and do not establish causation. The final script does not include significance tests for the canonical correlations.

## How to Run

1. Open `Code (Final).R` in R or RStudio.
2. Install the packages used by the script:

   ```r
   install.packages(c(
     "lavaan", "semPlot", "readxl",
     "MVN", "car", "robustbase"
   ))
   ```

3. To run the main analysis using `MVN Test.csv`, execute the script from the multivariate normality section beginning with `library(MVN)`.
4. Select `MVN Test.csv` when the file-selection window appears, then continue through the remaining analysis.

The initial item-validity section requires the questionnaire workbook, with item columns `x1`–`x24` beginning at column 29. It cannot be reproduced from the dimension-average CSV alone.

Package versions and a random seed are not specified in the supplied script, so reproduced results may differ from the reported values.

## Authors

- I Made Rayxelvio Erawan Rustiadi
- Kelvin Fardiman
- Marcell Prasetyo

Multivariate Statistics — Group 8  
BINUS University
