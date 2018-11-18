---
Title: "PCA_Analysis"
Author: "Kamal"
Date: "February 15, 2018"
Output: Outputs for PCA analysis
---

# Principal Component Analysis in R

```
# Load desired packages
install.packages("scatterplot3d")
library(scatterplot3d)

# Retrieve the "iris" dataset, sans the "Species" column.
iris_numerical <- iris[,-5]
```
3D Scatter plot for IRIS dataset

```
scatterplot3d(iris[,1:3],xlab = "Sepal Length",ylab="Sepal Width",zlab="Petal Length")
```
![plot of chunk scatterplot3D](/PCA_Analysis1.PNG)

