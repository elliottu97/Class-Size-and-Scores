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