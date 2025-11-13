library(tidyverse)
library(ggplot2)
library(regclass)

library(lubridate)

Kyler <- read.csv("kylermurray_stats.txt", stringsAsFactors = TRUE)

# Set up game dates
Kyler$Date <- ymd(Kyler$Date)
Kyler$month <- month(Kyler$Date, label = FALSE)
Kyler$day <- day(Kyler$Date)

# Add month labels
Kyler <- Kyler |>
  mutate(monthlabel = ifelse(month == 9, "September",
                             ifelse(month == 10, "October",
                                    ifelse(month == 11, "November",
                                           "Dec/Jan"))) )
Kyler$monthlabel <- as.factor(Kyler$monthlabel)
table(Kyler$monthlabel)

# Fix home/away status of games
Kyler$Home.Away <- ifelse(Kyler$Home.Away == "@", "Away", "Home")

# Calculate FanDuel fantasy points
Kyler = Kyler |>
  mutate(fantpts = (Passing_Yds / 25) + (Passing_TD * 4) + (Passing_Int * -2) +
           (Rushing_Yds / 10) + (Rushing_TD * 6) + (Fumbles_FL * -2) )

# Fantasy points per pass attempt. Right now takes all fantasy points, so is bloated by great rushing performances
Kyler$fant_pt_per_att <- round((Kyler$fantpts / Kyler$Passing_Att), 2)
plot(fant_pt_per_att ~ Week, data = Kyler)

# Clone dataset grouped by week
kyavg <- Kyler |>
  group_by(Week) |>
  summarize(avg_fant_pt = mean(fantpts))

# Graph average fantasy points each week
kyplot <- kyavg |>
  ggplot(aes(x = Week, y = avg_fant_pt)) +
  geom_line(col = "black", size = 1) + geom_smooth(method = "lm", se = FALSE, col = "red", size = 0.5) +
  labs(title = "Kyler Murray Fantasy Points by Season Game", subtitle = "Based on ESPN standard scoring") +
  labs(x = "Season Game (1-17)", y = "Average fantasy points that week") +
  theme(plot.title = element_text(size = 18, hjust = 0.5, face = "bold")) +
  theme(plot.subtitle = element_text(size = 10, hjust = 0.5))
kyplot

# Make a linear model of Murray's fantasy points by week using regclass
m <- lm(fantpts ~ Week, data = Kyler)
visualize_model(m)
summary(m)
# Prediction intervals
to.predict <- data.frame(Week = c(1, 5, 9, 13, 17))
to.predict$ExpFantPts <- predict(m, newdata = to.predict)
to.predict

# Same deal except with the grouped dataset instead of the base one
m1 <- lm(avg_fant_pt ~ Week, data = kyavg)
visualize_model(m1)
summary(m1)

to.p1 <- data.frame(Week = c(1, 5, 9, 13, 17))
to.p1$exp_fant_pts <- predict(m1, newdata = to.p1)
to.p1
