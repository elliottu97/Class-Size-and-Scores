# Class-Size-and-Scores
Testing the conditional average treatment effects for different variables on test scores in R. 

Analyzing data from the Tennessee STAR experiment on the effects of class size reduction on standardized test scores. 
Data gathered on students in Kindergarten through 2nd grade. The outcome variable is test scores. Outcome = yi = test scores, wi = dummy variable for student i being in a small class.
The covariates examined in this regression are
gender (dummy variable fem = female), race (dummy variable wh = white), age in years, cost of lunch (dummy variable fl = free lunch), 
teacher experience in years (exp), teacher position on the career ladder (lad), teacher's highest degree (deg), and location of school (dummy variable urb = urban). 
I'm examining here whether being in a small class has different effects on average test scores for students in different subpopulations.
I use the grf package to estimate the conditional average treatment effects for the 16 different combinations of fem, wh, fl, and urb using 4000 trees.
All other covariate values are kept at their mean values. Results are the estimates, standard errors, and 95% confidence intervals of the combinations in a table. 

Uses 1 dataset and 2 R packages, matrixStats and grf

PDF included contains results table. 
