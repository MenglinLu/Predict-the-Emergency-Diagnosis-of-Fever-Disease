# datathon project
# group 4

# load data
library(readr)
data <- read.csv('C:/Users/lenovo/Desktop/datathon4/data_final.csv')[, -8]
data$sex <- as.factor(data$sex)
data$antibiotic_flag <- as.factor(data$antibiotic_flag)
data$infection <- as.factor(data$infection)
data$baso <- as.numeric(data$baso)

# baseline characteristic
library(tableone)
cvar <- c("sex", "age", "wbc", "nit", "uwbc", "plt", "pct", "il6", "crp", "baso", "eos", "lym", "mono", "neut", 'antibiotic_flag')
a <- CreateTableOne(vars = cvar, strata = 'infection', data = data)
a <- print(a)
write.csv(a, 'C:/Users/lenovo/Desktop/datathon4/baseline.csv')

# logistic regression
model.logistic <- glm(infection ~ sex + age + wbc + nit + uwbc + plt + pct + il6 + crp + baso + eos + lym + mono + neut,
                      data = data,
                      family = binomial(link = 'logit'))
summary(model.logistic)
b <- cbind(round(exp(coef(model.logistic)), 3), round(exp(confint(model.logistic)), 3), p_value = round(coef(summary(model.logistic))[, 4], 3))
b <- cbind(paste(b[, 1], '(', b[, 2], ',', b[, 3], ')'), b[, 4])
b <- as.data.frame(b)
colnames(b) <- c('OR(95% CI)', 'P_value')
write.csv(b, 'C:/Users/lenovo/Desktop/datathon4/logistic_summary.csv')