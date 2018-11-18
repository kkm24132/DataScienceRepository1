---
Title: "Anomaly Detection using R"
Output: Exploratory Data Analysis
Author: Kamal
---

# Anomaly Detection using R's anomalize

Load both tidyverse and anomalize libraries

```
library(tidyverse)
library(anomalize)
```

Get some time series data Anomalize ships with a data set called tidyverse_cran_downloads that contains the daily CRAN download counts 
for 15 “tidy” packages from 2017-01-01 to 2018-03-01.

```
tidyverse_cran_downloads %>%
  ggplot(aes(date, count)) +
  geom_point(color = "#2c3e50", alpha = 0.25) +
  facet_wrap(~ package, scale = "free_y", ncol = 3) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
  labs(title = "Tidyverse Package Daily Download Counts",
       subtitle = "Data from CRAN by way of cranlogs package")
```

Daily Download Counts for TidyVerse package

![plot of chunk DailyDownloadCount](/TidyVerseDailyDownloadCount.PNG)

We want to determine which daily download “counts” are anomalous. 
It’s as simple as using the 3 main functions (time_decompose(), anomalize(), and time_recompose()) 
along with a visualization function, plot_anomalies()

Anomalize() uses 2 techniques for seasonal decomposition
* STL: Seasonal Decomposition of Time series by Loess - good for long term trend
* Twitter: Seasonal Decomposition of Time series by Median - works well if seasonal component is more dominant

```
tidyverse_cran_downloads %>%
  # Data Manipulation / Anomaly Detection
  time_decompose(count, method = "stl") %>%
  anomalize(remainder, method = "iqr") %>%
  time_recompose() %>%
  # Anomaly Visualization
  plot_anomalies(time_recomposed = TRUE, ncol = 3, alpha_dots = 0.25) +
  labs(title = "Tidyverse Anomalies", subtitle = "STL + IQR Methods") 
```
Anomalies for TidyVerse package (using STL and IQR methods)

![plot of chunk DailyDownloadCount](/TidyVerseAnomalies.PNG)


