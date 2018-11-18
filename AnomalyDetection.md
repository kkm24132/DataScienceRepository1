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

![plot of chunk DailyDownloadCount](/TidyVerseDailyDownloadCount.png)


