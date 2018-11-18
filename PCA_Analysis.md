---
Title: "PCA_Analysis"
Author: "Kamal"
Date: "February 15, 2018"
Output: Outputs for PCA analysis
---

## Principal Component Analysis in R

Load packages that are required and get IRIS dataset for analysis
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

Perform PCA on the numerical data from "iris"
prcomp does all the work of centering and scaling our data for us!
```
pcaSolution <- prcomp(iris_numerical,center = TRUE,scale. = TRUE)
```

Print a summary of the analysis
```
print(pcaSolution)
summary(pcaSolution)
```
![plot of chunk printPCA](/PCA_Analysis1b.PNG)
![plot of chunk summaryPCA](/PCA_Analysis1c.PNG)

Eigenvalues of each Principal Component
```
plot(pcaSolution, type="l", main="Eigenvalues for each Principal Component")
```
![plot of chunk eigenvaluesPCA](/PCA_Analysis2.PNG)

