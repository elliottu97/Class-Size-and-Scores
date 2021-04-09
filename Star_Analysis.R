library(matrixStats)
library(grf)

set.seed(1)
data <- read.csv('star.csv')
attach(data)

y <- data$y
w <- data$w
x <- as.matrix(cbind(fem, wh, fl, urb, age, exp, lad, deg))

tauforest <- causal_forest(x, y, w, num.trees = 4000)

subg <- expand.grid(c(0,1), c(0,1), c(0,1), c(0,1))
numsubg <- nrow(subg)
numxvars <- ncol(x)
xeval <- matrix(0, nrow = numsubg, ncol= numxvars)
for(j in 1:numsubg) {
  xeval[j, 1:4] <- as.matrix(subg[j,])
  xeval[j, -c(1:4)] <- colMeans(x)[-c(1:4)]
}

tauhat <- predict(tauforest, xeval, estimate.variance = T)

SE <- sqrt(tauhat$variance.estimates)
CI <- cbind(tauhat$predictions - 1.96 * SE,
            tauhat$predictions + 1.96 * SE)

results <- cbind(subg, tauhat$predictions, SE, CI)
colnames(results) <- c("fem", "wh", "fl", "urb", "estimate", "SE", "CI lower", "CI upper")
print(results)

#Estimating the effects of being in a small class for students
#at the mean and at 18 different quantiles of the test score distribution 
#from 0.1 to 0.95. Effects are plotted with 95% confidence bands. 

rm(list = ls())
mydata <- read.csv(file = "star.csv")
attach(mydata)
#registerDoParallel(cores = 7)
#Do not use the above command unless you've installed doParallel, and if you do
#make sure that you change the cores to match the cores you want to use for YOUR
#computer, otherwise you'll crash your computer. 

taus <- seq(0.1, 0.95, length = 18)
rqfits <- summary(rq(y ~ w + fem + wh +fl + exp + lad + deg + urb, data = mydata, tau = taus))
plot(rqfits, parm = c(2), level = .95, main = "Effects at 18 Quantiles")

###################

#Computing two-sided equal-tailed nominal 95% bootstrap confidence intervals 
#and bootstrap standard errors using 1000 iterations for all estimates in the above plot

B <- 1000
N <- nrow(mydata)
ntaus <- length(taus)
bootCI <- matrix(0, nrow = ntaus, ncol = 2)
bootSE <- matrix(0, nrow = ntaus, ncol = 1)

i = 1
t <- taus[i]
for(i in 1:ntaus){
  t <- taus[i]
  bootDist <- foreach(b = 1:B,.combine = rbind)%dopar%{
    set.seed(b)
    indices <- sample(N, N, replace = T)
    library(quantreg)
    fitrq <- rq(y[indices] ~ w[indices] + fem[indices] + wh[indices] + fl[indices] + exp[indices]
                + lad[indices] + deg[indices] + urb[indices], data = mydata, tau = taus[i])
    fitrq$coefficients[2]
  }
  alpha <- .05
  bootCI[i,] <- colQuantiles(bootDist, probs = c(alpha/2, (1-alpha/2)))
  bootSE[i,] <- colSds(bootDist)
}
bootCI
bootSE
stargazer(bootCI, type = "html", title = "Quantile Regression 95% CI",
          out = "C:/Users/eugen/Desktop/P2ci.xls")
stargazer(bootSE, type = "html", title = "Quantile Regression SE",
          out = "C:/Users/eugen/Desktop/P2se.xls")