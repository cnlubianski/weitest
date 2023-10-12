
# weitest

<center>

![Weitest R Package Hex](img/weitest_hex.png)

</center>

The goal of `weitest` is to explore diagnostic tests of survey weights.
Survey weights represent the number of population units that the
observational unit $i$ represents. Let $\pi_{Si} = P(i \in S)$ be the
selection probability of surveying observation $i$ from sample $S$. The
adoption of survey weights into analysis is usually determined by field
practices instead of diagnostic tests which might leave estimates
significantly high levels of variance with little reduction in bias.
Therefore, survey weight diagnostic tests are crucial to gaining a
better understanding and grasp of how survey weights fit in statistical
analysis and inference.

## Installation

You can install the development version of weitest from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("harvard-stat108s23/project2-group21")
#> rlang (1.1.0 -> 1.1.1) [CRAN]
#> cli   (3.4.1 -> 3.6.1) [CRAN]
#> package 'rlang' successfully unpacked and MD5 sums checked
#> package 'cli' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\cnlub\AppData\Local\Temp\RtmpovzHEf\downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\cnlub\AppData\Local\Temp\RtmpovzHEf\remotes26407c0f712d\harvard-stat108s23-project2-group21-22a82772b5f88a77e560e54423b88b14fbad4749/DESCRIPTION' ...  ✔  checking for file 'C:\Users\cnlub\AppData\Local\Temp\RtmpovzHEf\remotes26407c0f712d\harvard-stat108s23-project2-group21-22a82772b5f88a77e560e54423b88b14fbad4749/DESCRIPTION'
#>       ─  preparing 'weitest':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>      NB: this package now depends on R (>=        NB: this package now depends on R (>= 3.5.0)
#>        WARNING: Added dependency on R >= 3.5.0 because serialized objects in
#>      serialize/load version 3 cannot be read in older versions of R.
#>      File(s) containing such objects:
#>        'weitest/README_cache/gfm/unnamed-chunk-3_8bb7ee5534f60745e584fb9c651d928c.RData'
#>        'weitest/README_cache/gfm/unnamed-chunk-3_8bb7ee5534f60745e584fb9c651d928c.rdx'
#> ─  building 'weitest_0.0.0.9000.tar.gz'
#>      
#> 
```

## Bias-Variance Tradeoff

A natural phenomena in statistics is the bias-variance tradeoff where if
you gain a little bias to your estimators, you might be able to see a
dramatic reduction in your variance, and vice versa. The package
`weitest` imulates this by bootstrapping the RMSE estimates from
weighted and unweighted linear regressions to find whether the
difference of RMSE estimates are statistically significant. The
`rmsewt_test` outputs a list of RMSE estimates, the $t$-statistic, and
the corresponding $p$-value. With an Type I error rate of
$\alpha = 0.05$, $p$-values less than 0.05 indicate that including
weights in your linear regression significantly increase your RMSE such
that the predictions are spread further away from the line of best fit.

``` r
library(weitest)
data("LLCP2020")
rmsewt_test(y = "WEIGHT2", x = "HTIN4", covariates = c("RACE", "SEX"), weights = "LLCPWT",
            data = LLCP2020, boot_size = 500, iterations = 1000, alt_hypo = "two.sided")
#> $Weighted_rmse
#> [1] 40.68676
#> 
#> $Unweighted_rmse
#> [1] 40.66544
#> 
#> $Test_statistic
#>        t 
#> 23.18827 
#> 
#> $p_value
#> [1] 1.627597e-95
```

On the other hand, survey weights offer a way to reduce biased
estimators when sampling bias exists in the sample. Similar to
`rmsewt_test`, `meanwt_test` aims to showcase statistically significant
reductions in the bias of the mean estimator such that survey weights
are adjusting the mean estimator towards the true mean of the target
population. Below, we want to determine whether mean height (inches) is
statistically different when it is weighted by population weights and
when it is nonweighted. Similarly, $p$-values less than 0.05 indicate
that applying weights to height significantly alters to the mean such
that weights are decreasing the bias.

``` r
meanwt_test(LLCP2020$HTIN4, LLCP2020$LLCPWT, boot_size = 500, iterations = 1000, alt_hypo = "two.sided")
#> 
#>  One Sample t-test
#> 
#> data:  sample_distribution
#> t = -1.6424, df = 999, p-value = 0.1008
#> alternative hypothesis: true mean is not equal to 0
#> 95 percent confidence interval:
#>  -0.049518097  0.004395499
#> sample estimates:
#>  mean of x 
#> -0.0225613
```

## Model-Based Diagnostic Tests

There are two categories of survey weight diagnostic tests: weight
association tests and difference in coefficients tests. Each used
model-based inference using linear regression coefficients, but differ
in their linear model setup. First, difference in coefficients tests
compare weighted and unweighted regression coefficients on the exogenous
variable to determine whether including weights led to a statistically
different coefficient estimate between the two different linear models.
The inferential test uses a $\chi_k^2$ with number of predictors $k$
degrees of freedom.

``` r
dc_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020)
#> $unweighted_model
#> 
#> Call:
#> stats::lm(formula = dat[[1]] ~ dat[[2]], data = dat)
#> 
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -169.02  -27.50   -6.81   19.91  828.22 
#> 
#> Coefficients:
#>               Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) -176.54189    1.09624  -161.0   <2e-16 ***
#> dat[[2]]       5.34341    0.01631   327.5   <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 40.72 on 353863 degrees of freedom
#> Multiple R-squared:  0.2326, Adjusted R-squared:  0.2326 
#> F-statistic: 1.073e+05 on 1 and 353863 DF,  p-value: < 2.2e-16
#> 
#> 
#> $weighted_model
#> 
#> Call:
#> svyglm(formula = equation, design = weighted_design)
#> 
#> Survey design:
#> survey::svydesign(id = ~1, weight = ~dat[[3]], data = dat)
#> 
#> Coefficients:
#>               Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) -158.06245    3.44537  -45.88   <2e-16 ***
#> HTIN4          5.06054    0.05119   98.86   <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for gaussian family taken to be 1740.797)
#> 
#> Number of Fisher Scoring iterations: 2
#> 
#> 
#> $test_statistic
#>               [,1]
#> [1,] -0.0001883652
#> 
#> $p_value
#> [1] 6.96982e-16
```

Alternatively, we can use weight association tests which runs a single
linear regression model but with a weighted and nonweighted predictor to
determine whether the corresponding $p$-value is statistically
significant.

``` r
wa_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020)
#> $summary
#> 
#> Call:
#> stats::lm(formula = dat[[1]] ~ dat[[2]] + dat[[2]]:dat[[3]], 
#>     data = dat)
#> 
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -169.05  -27.50   -6.84   19.91  828.33 
#> 
#> Coefficients:
#>                     Estimate Std. Error  t value Pr(>|t|)    
#> (Intercept)       -1.766e+02  1.096e+00 -161.057  < 2e-16 ***
#> dat[[2]]           5.345e+00  1.632e-02  327.493  < 2e-16 ***
#> dat[[2]]:dat[[3]] -2.841e-06  7.358e-07   -3.861 0.000113 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 40.72 on 353862 degrees of freedom
#> Multiple R-squared:  0.2327, Adjusted R-squared:  0.2327 
#> F-statistic: 5.365e+04 on 2 and 353862 DF,  p-value: < 2.2e-16
```

The strengths and weaknesses of difference of coefficients and weight
association tests are still not known empirically as to how robust they
are to heterogenity of standard errors and when their asymptotic
properties “kick-in”. Here is a preliminary simulation conducted as a
prelude to my senior thesis escapade.

<center>

![Simulation Robustness Results](img/test_results.png)

</center>
