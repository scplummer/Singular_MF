library(plotly)
library(MASS)
library(readr)
library(patchwork)
library(tidyverse)

N <- 1000

ws_plot <- read_csv("/Users/seanp/Documents/PythonCode/BNN_via_SLT-main/Modified Wei 2022 Code/ws_plot_gengamma_8_32_n_1000.csv", show_col_types = FALSE)

#post.true.vec <- numeric(400)
a.nf <- as.numeric(t(ws_plot[, 1]))
b.nf <- as.numeric(t(ws_plot[, 2]))
c.nf <- as.numeric(t(ws_plot[, 3]))
subset.index <- which(abs(c.nf - 0) < 0.1) #&  abs(a.nf) < 1 & abs(b.nf) < 1)
rm(ws_plot)
#Gaussian KDE plot of q_nf values
kde = kde2d(x= a.nf[subset.index], y= b.nf[subset.index], h = 0.5)
kde = kde2d(x= a.nf, y= c.nf, h = 0.3)
kde.df <- data.frame(x = kde$x, y= kde$y)
figure_nf <- plot_ly(x=kde.df$x , y= kde.df$y, z= kde$z , type = "contour")
figure_nf

rescale_01 <- function(x) (x-min(x))/(max(x) - min(x))
#rescale_01(a.nf[subset.index])
kde2 = kde2d(x= rescale_01(a.nf[subset.index]), y= rescale_01(b.nf[subset.index]), h = 0.2)
#kde = kde2d(x= a.nf, y= c.nf, h = 0.3)
kde2.df <- data.frame(x = kde2$x, y= kde2$y)
figure_nf2 <- plot_ly(x=kde2.df$x , y= kde2.df$y, z= kde2$z , type = "contour")
figure_nf2


num.plot <- 500
a <- seq(0, 1, length = num.plot)
b <- seq(0, 1, length = num.plot)
c <- seq(0, 1, length = num.plot)
post.true <- matrix(0, num.plot, num.plot)
posterior <- function(a,b,c, N){exp(-N*(1/2 * a^2 * b^2 + a*b*c + 1/2*c^2 + 1/6*a^2*b^4))}
posterior.coord4 <- function(a,b,c, N){a^2*b^2*c^2* exp(-N * a^2*c^2*(1/2*b^2 + 1/6*b^4))}
posterior.coord3 <- function(a,b,c, N){a*b^2* exp(-N * (1/6 * a^2*b^4 + 1/2*a^2*b^4*c^2) )}
#post.nf <- matrix(0, num.plot, num.plot)
for (i in 1:num.plot){
  for(j in 1:num.plot){
    post.true[i,j] = posterior.coord3(a[i], b = b[j], c=0 , N)
  }
}

fig_post <- plot_ly(x= a, y= b, z = post.true, type = "contour")
fig_post 

par(mfrow=c(1,2))
fig_post 
figure_nf 


#---------------------------------
# Generate Regression for NF ELBO
#---------------------------------


