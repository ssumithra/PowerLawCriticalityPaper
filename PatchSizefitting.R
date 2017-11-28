# Load the MLE fit and comparison and template.Rdata
#load packages 'poweRlaw'and 'ggplot2'

library(grid)

data<- read.csv("q0p7225PSD.csv", header=FALSE)
data0 = t(data)
data0 = as.vector(data0)

head(data0)
data = data0

pow = displ$new(as.numeric(data0)) # stores data in prep for parameter estimation
minx = estimate_xmin(pow) #use if you need xmin to be estimated
pow$setXmin(minx)
est1 = estimate_pars(pow) # estimates parameters using MLE
pow$setPars(est1$pars) # store estimated pars in the appropriate way

exp = disexp$new(as.numeric(data0)) # stores data in prep for parameter estimation
#minx = estimate_xmin(pow) #use if you need xmin to be estimated
exp$setXmin(minx)
est1 = estimate_pars(exp) # estimates parameters using MLE
exp$setPars(est1$pars) # store estimated pars in the appropriate way

Lnorm = dislnorm$new(as.numeric(data0)) # stores data in prep for parameter estimation
#minx = estimate_xmin(pow) #use if you need xmin to be estimated
Lnorm$setXmin(minx)
est1 = estimate_pars(Lnorm) # estimates parameters using MLE
Lnorm$setPars(est1$pars) # store estimated pars in the appropriate way


exp1 = discexp.fit(data0,minx$xmin) # exponential
pow1 = pareto.exp.llr(data0,minx$xmin) # power law
lnorm1 = fit.lnorm.disc(data0,minx$xmin) # log-normal
powexp = discpowerexp.fit(data0,minx$xmin) # power law with exponential cut-off

# Compare fits between these three

com = compare_distributions(pow,Lnorm) # all combinations as required
com$test_statistic # vuong test statistic (pvals calculated from this)
com$p_two_sided
# p = 1 implies that both distributions are equally far from the data
# p = 0 implies that one of the distributions fits the data significantly better
com$p_one_sided
# p = 1 implies that the first distribution is the better fit
# p = 0 implies that the first distribution can be rejected in favour of the second

# p-2 sided = 0; p-1 sided = 1 => 1st distribution wins
# p-2 sided = 0; p-1 sided = 0 => 2nd distribution wins

# 3) Compare these distributions with power law with exp cutoff (Note: cannot compare exp and powerexp yet)
# all the attached functions have to be run

power.powerexp.lrt(pow1,powexp) # compare pareto and powerexp
# gives only a single p-value. If p = 0, powerexp is better
exp.powerexp.lrt(exp1,powexp)
# gives only a single p-value. There is an issue here.
# If it is an underlying exponential distribution (extreme case), powerexp will be chosen for
# large sample sizes. In such a case, the rate of decline will be similar
vuong(lnorm.powerexp.llr(data0, lnorm1, powexp, minx$xmin)) # compare lnorm and powerexp
# 2 p values similar to the previous analysis



