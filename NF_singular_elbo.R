library(readr)
library(tidyverse)


#--------------------------------------------------
# 1 Layer Tanh Neural Network
# RLCT = 1/2 , Multiplicity = 2
#--------------------------------------------------

# (2,4), (2,16) good, no log(log) 
# (4,4), better,  no log(log) 
# (2,32), (4,16) good, log(log) supprisingly close to correct? 
#  looks good

path <- "Documents/PythonCode/BNN_via_SLT-main/Results/tanh_zeromean/gengamma_4_16/gengamma_4_16.csv"

data <- read_csv(path, show_col_types = FALSE)

summary(lm(ELBO ~ log(n), data = data))

summary(lm(ELBO ~ -1 + log(n) + log(log(n)), data = data)) 

ggplot(data = data, aes(x = log(n), y = ELBO)) +
  geom_point() +
  geom_smooth(method = 'lm') 

# (2,4), (4,4) not that good
# (2,16), (4,16) better, but still not that good. 2_16 no log(log) 
# (2,32), (8,16) okay, log(log) supprisingly close to correct? 
#  looks good

path <- "Documents/PythonCode/BNN_via_SLT-main/Results/tanh_zeromean/gaussian_4_16/gaussian_4_16.csv"

data <- read_csv(path, show_col_types = FALSE)

summary(lm(ELBO ~ log(n), data = data))

summary(lm(ELBO ~ -1 + log(n) + log(log(n)), data = data)) 

ggplot(data = data, aes(x = log(n), y = ELBO)) +
  geom_point() +
  geom_smooth(method = 'lm')

#--------------------------------------------------
# 2 Dimensional Non-linear regression
# RLCT = 1/3 , Multiplicity = 1
#--------------------------------------------------

# (2,4), (4,4) Convergence Issues and off
# (2,16),  Less convergence issues but still off
# (2,32) Some convergence issues which can be adjusted out
# (4,16) looks good 
 
path <- "Documents/PythonCode/BNN_via_SLT-main/Results/nonlinreg/gengamma_2_32/gengamma_2_32.csv"

#path <- "Documents/PythonCode/BNN_via_SLT-main/Results/nonlinreg_unifx_gaussian_prior/gengamma_4_16/gengamma_4_16.csv"

data <- read_csv(path, show_col_types = FALSE)

# Works well if you exclude poorly converged points. 
# ELBO > -3.4 cut-off for 2_32. 
# 4_16 just works. 

data_2_32 <- data %>% 
  filter(seed != 12) %>%
  group_by(n) %>%
  filter(ELBO > quantile(ELBO, c(0.1)))
  

data_2_16 <- data %>% 
  filter(seed != 6)

data_4_4 <- data %>% 
  filter(seed != 6)

data_4_4 <- data %>% 
  filter(seed != 6)

quantile(data_2_32$ELBO, prob = c(0.75))

summary(lm(ELBO ~  log(n), data = data_2_32))  

summary(lm(ELBO ~ -1 + log(n) + log(log(n)), data = data_2_32)) 

ggplot(data = data_2_32, aes(x = log(n), y = ELBO)) +
  geom_point(aes(color = as.factor(seed))) +
  geom_smooth(method = 'lm') 


# (2,4), (4,4), (2,16) Convergence issues
# (8,16), (16,32) No convergence issues just off
# (4,16),  Some convergence issues which can be adjusted out 
#           by removing bad seeds 
# (2,32),  Less convergence issues but off a little.

# path <- "Documents/PythonCode/BNN_via_SLT-main/Results/nonlinreg_unifx_gaussian_prior/gaussian_2_32/gaussian_2_32.csv"

path <- "Documents/PythonCode/BNN_via_SLT-main/Results/nonlinreg/gaussian_2_32/gaussian_2_32.csv"

data <- read_csv(path, show_col_types = FALSE) 

data_4_16 <- data %>% 
  filter(seed < 9 | seed %in% 11:15 | seed > 17)

data_2_32 <- data %>% 
  filter(seed != 13)

summary(lm(ELBO ~  log(n), data = data))

summary(lm(ELBO ~  -1 + log(n) + log(log(n)), data = data)) 

ggplot(data = data, aes(x = log(n), y = ELBO)) +
  geom_point(aes(color = as.factor(seed))) +
  geom_smooth(method = 'lm') 

#--------------------------------------------------
# 3 Dimensional Non-linear regression
# RLCT = 3/4 , Multiplicity = 2
#--------------------------------------------------


path <- "Documents/PythonCode/BNN_via_SLT-main/Results/nonlinear/gaussian_4_32/gaussian_4_32.csv"

data <- read_csv(path, show_col_types = FALSE)

summary(lm(ELBO ~ log(n), data = data[data$ELBO>-6, ])) 

summary(lm(ELBO ~ -1 + log(n) + log(log(n)), data = data[data$ELBO>-6, ])) 

ggplot(data = data, aes(x = log(n), y = ELBO)) +
  geom_point() +
  geom_smooth(method = 'lm') 


# (4, 16),  okay need more data 
# (8, 32),   Appear good no log(log) 
# (4, 128)  good, no log(log) term
# (2, 32) good,  log(log) is closer to correct term
path <- "Documents/PythonCode/BNN_via_SLT-main/Results/nonlinear/gengamma_2_16/gengamma_2_16.csv"

data <- read_csv(path, show_col_types = FALSE)

summary(lm(ELBO ~ log(n), data = data[data$ELBO>-6, ]))

summary(lm(ELBO ~ -1 + log(n) + log(log(n)), data = data)) 

ggplot(data = data, aes(x = log(n), y = ELBO)) +
  geom_point() +
  geom_smooth(method = 'lm') 



