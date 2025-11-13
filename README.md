## What is this?
This repository contains an R script where I modeled Arizona Cardinals quarterback Kyler Murray's fantasy football output by week, as well as the gamelogs I used.

### Where did the data come from?
I saved Murray's career gamelogs from his Pro Football Reference page, which Sport Reference makes incredibly easy - I was able to export the stats in .txt
format with one click. I then used Claude to clean up the column names. Due to injuries, Murray has not played since his last game before I got the data as I write this.

### What libraries are used?
Tidyverse and Lubridate were used to do the necessary processing, including creating a grouped set by week (tidyverse) and converting the game dates to actual
date format (lubridate). Regclass was used to create and run the models, while ggplot2 was used to visualize the main model.

### Note
The data file needs to be in the same file location as the R script, or you will have to include the whole file directory for the data in the read.csv() function.
