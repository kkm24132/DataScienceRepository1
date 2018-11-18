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

![plot of chunk TidyVerse DailyDownloadCount](/TidyVerseDailyDownloadCount.PNG)

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

![plot of chunk TidyVerse Anomalies](/TidyVerseAnomalies.PNG)

Twitter’s AnomalyDetection package: we can implement that method by combining time_decompose(method = "twitter") 
with anomalize(method = "gesd"). Additionally, we’ll adjust the trend = "2 months" to adjust the median spans,
which is how Twitter’s decomposition method works.

```
# Get only lubridate downloads
lubridate_dloads <- tidyverse_cran_downloads %>%
  filter(package == "lubridate") %>% 
  ungroup()

# Anomalize!!
lubridate_dloads %>%
  # Twitter + GESD
  time_decompose(count, method = "twitter", trend = "2 months") %>%
  anomalize(remainder, method = "gesd") %>%
  time_recompose() %>%
  # Anomaly Visualziation
  plot_anomalies(time_recomposed = TRUE) +
  labs(title = "Lubridate Anomalies", subtitle = "Twitter + GESD Methods")
```

Lubridate package Anomalies (using Twitter + GESD methods)

![plot of chunk Lubridate Anomalies with GESD](/LubridateAnomalies_TwitterGESD.PNG)

Finally, we can compare to STL + IQR methods, which use different decomposition and anomaly detection approaches.
```
lubridate_dloads %>%
  # STL + IQR Anomaly Detection
  time_decompose(count, method = "stl", trend = "2 months") %>%
  anomalize(remainder, method = "iqr") %>%
  time_recompose() %>%
  # Anomaly Visualization
  plot_anomalies(time_recomposed = TRUE) +
  labs(title = "Lubridate Anomalies", subtitle = "STL + IQR Methods")
```

Lubridate package Anomalies (using STL + IQR methods)
![plot of chunk Lubridate Anomalies with STL](/LubridateAnomalies_STLIQR.PNG)


More capabilities for auto selection of frequency and trend...

```
# Time Frequency
time_frequency(lubridate_dloads, period = "auto")

# Time Trend
time_trend(lubridate_dloads, period = "auto")

# plot_anomaly_decomposition() for visualizing the inner workings of how algorithm detects anomalies in the “remainder”.
tidyverse_cran_downloads %>%
  filter(package == "lubridate") %>%
  ungroup() %>%
  time_decompose(count) %>%
  anomalize(remainder) %>%
  plot_anomaly_decomposition() +
  labs(title = "Decomposition of Anomalized Lubridate Downloads")
```

Decomposition of Anomalized Lubridate Downloads
![plot of chunk Anomalized Lubridate Downloads](/AnomalizedLubridateDownloads.PNG)
