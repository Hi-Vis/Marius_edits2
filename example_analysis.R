### Load libraries ##########
library(sjPlot)

### Load data ###########
# A short, simple name for you main dataset is nice because you'll
#   probably have to type it out a lot
cow = carData::Cowles

### Recode data ########
# Create a vector that's all "Low" to start with
cow$high_extraversion = "Low"
# Replace the values where extraversion is high
cow$high_extraversion[cow$extraversion > mean(cow$extraversion)] = "High"
# Make it a factor
cow$high_extraversion = factor(
    cow$high_extraversion,
    levels = c("Low", "High")
)

cow$personality_type = ifelse(
    test = cow$extraversion > cow$neuroticism,
    yes = "Extravert",
    no = "Introvert"
)
# Make it a factor
cow$personality_type = factor(
    cow$personality_type,
    levels = c("Introvert", "Extravert")
)

cow$high_neuroticism = ifelse(
    cow$neuroticism > mean(cow$neuroticism),
    "High",
    "Low"
)
cow$high_neuroticism = factor(
    cow$high_neuroticism,
    levels = c("Low", "High")
)

# Advanced code: run this but don't worry too much about what
#   it's doing
set.seed(1)
cow$depression = round(
  19 + 
  0.5 * cow$neuroticism +
  -0.8 * cow$extraversion +
  0.5 * (cow$sex == "female") +
  rnorm(nrow(cow), sd = 3)
)

cow$depression_diagnosis = cut(
    cow$depression,
    breaks = c(0, 20, 25, 33),
    labels = c("None", "Mild", "Severe"),
    include.lowest = TRUE
)

### Descriptive statistics ######
table(cow$sex)
table(cow$sex, cow$volunteer)

hist(cow$neuroticism)

plot(cow$neuroticism, cow$depression, type='p')
cor(cow$neuroticism, cow$depression)

### Analysis ###########
# T-test of depression scores: male vs. female
dep_sex_test = t.test(cow$depression[cow$sex == "male"],
                      cow$depression[cow$sex == "female"])
dep_sex_test

# Alternative way of running the same test
t.test(depression ~ sex, data = cow)

# Regression: predicting depression
dep_reg = lm(depression ~ neuroticism + extraversion + sex,
             data = cow)
summary(dep_reg)

# This temporarily switches R's plotting to a 2x2 layout
par(mfrow = c(2, 2))
# Regression diagnostics
plot(dep_reg)
# Switch plots back to normal
par(mfrow = c(1, 1))
# If you wanted to create the first plot from scratch,
# you could plot `fitted(dep_reg)` against `resid(dep_reg)`.

# Plot predicted effects
plot_model(dep_reg, 
           # We want to see the effect of each predictor,
           #   but lots of other plot types are available
           type = "eff",
           terms = "neuroticism")

plot_model(dep_reg, 
           type = "eff",
           terms = "sex")

# Regression table
tab_model(dep_reg)