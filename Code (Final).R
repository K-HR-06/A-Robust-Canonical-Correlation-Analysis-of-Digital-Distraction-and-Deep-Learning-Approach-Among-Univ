library(lavaan)
library(semPlot)
library(readxl)
data <- read_excel(file.choose())
View(data)
data_numerik <- data[, 29:ncol(data)]
View(data_numerik)

# ==========================================
# 2. UJI VALIDITAS (ITEM-TOTAL CORRELATION) PER DIMENSI
# ==========================================

# Membuat list yang berisi pembagian item per dimensi
dimensi_list <- list(
  "DD_D1" = c("x1", "x2", "x3", "x4"),
  "DD_D2"   = c("x5", "x6", "x7", "x8"),
  "DD_D3"    = c("x9", "x10", "x11", "x12"),
  "DLA_D1"    = c("x13", "x14", "x15", "x16"),
  "DLA_D2"        = c("x17", "x18", "x19", "x20"),
  "DLA_D3"     = c("x21", "x22", "x23", "x24")
)

# Fungsi untuk menghitung korelasi pearson tiap item dengan total dimensinya
uji_validitas_dimensi <- function(data, dimensi_nama, item_cols) {
  skor_total <- rowSums(data[, item_cols])
  
  cat(sprintf("\n--- Validitas Dimensi: %s ---\n", dimensi_nama))
  cat(sprintf("%-10s %-15s %-15s %-15s\n", "Item", "R Hitung", "P-Value", "Status (Validitas)"))
  cat("------------------------------------------------------------\n")
  
  for (item in item_cols) {
    uji <- cor.test(data[[item]], skor_total, method = "pearson")
    
    r_hitung <- round(uji$estimate, 3)
    p_value <- round(uji$p.value, 4)
    
    status <- ifelse(p_value < 0.1, "Valid", "TIDAK Valid")
    
    cat(sprintf("%-10s %-15.3f %-15.4f %-15s\n", item, r_hitung, p_value, status))
  }
}

# Jalankan fungsi untuk keenam dimensi
for (nama in names(dimensi_list)) {
  uji_validitas_dimensi(data_numerik, nama, dimensi_list[[nama]])
}

# Semua pertanyaan valid semua
# Reliabilitas juga (dari file Reliability Test.xlsx)

# Uji Normality Multivariate (antara DD dan DLA)

# install.packages("MVN")
library(MVN)

# pakai data (MVN Test)
data_MVN <- read.csv(file.choose(), header = TRUE, sep = ";")
head(data_MVN)
nrow(data_MVN)

data_dd <- data_MVN[, 1:3]
head(data_dd)
data_dla <- data_MVN[, 4:6]
head(data_dla)

result_dd <- mvn(data = data_dd, mvn_test = "mardia")
print(result_dd$multivariate_normality)

result_dla <- mvn(data = data_dla, mvn_test = "mardia")
print(result_dla$multivariate_normality)

# Multicolinearity Test
library(car)

sapply(data_dd, length)
sapply(data_dla, length)

sapply(data_dd, class)
sapply(data_dla, class)

# Multicollinearity Check (VIF = 1 / 1 - r^2)
cor_matrix_dd <- cor(data_dd)
print(cor_matrix_dd)

cor_matrix_dla <- cor(data_dla)
print(cor_matrix_dla)

# Standardized Data
X_scaled <- scale(data_dd)
Y_scaled <- scale(data_dla)

# RCCA (Robust Canonical Correlation Analysis [MCD Approach]) -> PAKE YANG INI!!!!!!!!!!
library(robustbase)

# Hitung MCD Covariance
XY <- cbind(X_scaled, Y_scaled)
mcd <- covMcd(XY)
S <- mcd$cov

# Pisahkan matriks kovarians
p <- ncol(X_scaled)
q <- ncol(Y_scaled)

Sxx <- S[1:p, 1:p]

Syy <- S[(p+1):(p+q), (p+1):(p+q)]

Sxy <- S[1:p, (p+1):(p+q)]

Syx <- t(Sxy)

# Canonical correlations
M <- solve(Sxx) %*%
  Sxy %*%
  solve(Syy) %*%
  Syx

eig <- eigen(M)
eig$values

canonical_correlations <- sqrt(pmax(eig$values, 0))

canonical_correlations

# Canonical weights
weights_X <- Re(eig$vectors)

My <- solve(Syy) %*% Syx %*% solve(Sxx) %*% Sxy
eig_Y <- eigen(My)
weights_Y <- Re(eig_Y$vectors)

# Canonical Scores
scores_X <- as.matrix(X_scaled) %*% weights_X
scores_Y <- as.matrix(Y_scaled) %*% weights_Y

# Canonical loadings
loadings_X <- cor(X_scaled, scores_X)
loadings_Y <- cor(Y_scaled, scores_Y)

cat("\n--- LOADINGS VARIABEL X (Fungsi 1) ---\n")
print(round(loadings_X[, 1], 4))

cat("\n--- LOADINGS VARIABEL Y (Fungsi 1) ---\n")
print(round(loadings_Y[, 1], 4))

# ---------------------------------------------------------------