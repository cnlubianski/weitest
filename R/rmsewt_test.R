#' RMSE Weight Bootstrap Test
#'
#' As a part of the bias-variance trade-off, weighted linear regressions increase RMSE as it constructs unstable standard errors. To determine whether the RMSE difference is statistically significant, difference in RMSE is bootstrapped to calculate a t-test.
#'
#' @param y is a numeric vector denoting the dependent variable which will be regressed
#' @param x is a numeric vector denoting the independent variable which will be weighted by the weights w
#' @param covariates is an optional argument of numeric vectors to denoting covariates to condition on the weighted independent variables
#' @param weights is a numeric vector denoting the weights (population representation) which weigh the independent variable x
#' @param data is a dataframe containing y, x, and weights
#' @param boot_size is an integer argument to determine the number of observations to sample each bootstrap
#' @param iterations is an integer argument to determine the number of iterations for bootstrapping
#' @param alt_hypo is a character argument to determine the type of t-test. See t.test() for more information.
#'
#' @return list
#' @export
#'
#' @examples
#' data("LLCP2020")
#' rmsewt_test(y = "WEIGHT2", x = "HTIN4", covariates = c("RACE", "SEX"), weights = "LLCPWT", data = LLCP2020, boot_size = 500, iterations = 1000, alt_hypo = "two.sided")
rmsewt_test <- function(y, x, covariates = NULL, weights = NULL, data, boot_size = length(data) / 100, iterations = 10000, alt_hypo = "two.sided") {
  RMSE = function(y, yhat) {
    SSE = sum((y - yhat)^2)
    return(sqrt(SSE / length(y)))
  }
  stopifnot(is.numeric(boot_size) | is.numeric(iterations))
  stopifnot(is.data.frame(data))

  dat = NULL

  if (is.null(weights) == TRUE) {
    dat <- dplyr::mutate({{data}}, weights = 1) |>
      dplyr::select({{y}}, weights, {{x}}, {{covariates}})
  } else {
    dat <- dplyr::select({{data}}, {{y}}, {{weights}}, {{x}}, {{covariates}})
  }

  equation <- paste(names(dat)[1], "~", paste(names(dat)[-c(1:2)], collapse = " + "))

  unweighted_lm <- stats::lm(equation, dat)
  unweighted_rmse <- RMSE(dat[[1]], unweighted_lm$fitted.values)

  weighted_design <- survey::svydesign(id = ~1, weight = ~dat[[2]], data = dat)
  weighted_glm <- survey::svyglm(equation, design = weighted_design)
  weighted_rmse <- RMSE(dat[[1]], weighted_glm$fitted.values)

  obs_rmse_diff <- weighted_rmse - unweighted_rmse

  sample_distribution <- rep(NA, iterations)

  for (i in 1:iterations) {
    sample_dat <- dplyr::sample_n(dat, boot_size, replace = TRUE)

    unweighted_lm <- stats::lm(equation, sample_dat)
    weighted_design <- survey::svydesign(id = ~1, weight = ~sample_dat[[2]], data = sample_dat)
    weighted_glm <- survey::svyglm(equation, design = weighted_design)

    sample_distribution[i] <- RMSE(sample_dat[[1]], weighted_glm$fitted.values) -
      RMSE(sample_dat[[1]], unweighted_lm$fitted.values)
  }

  test_boot <- stats::t.test(sample_distribution, alternative = alt_hypo, mu = 0)
  return(list("Weighted_rmse" = weighted_rmse,
              "Unweighted_rmse" = unweighted_rmse,
              "Test_statistic" = test_boot$statistic,
              "p_value" = test_boot$p.value))
}
