#' Difference in Coefficients Diagnostic Test
#'
#' A difference in coefficients diagnostic test determines the necessity of weighted covariates by comparing the regression coefficient estimate of one weighted and one unweighted regression and then using a Chi-Squared test to determine statistical significance.
#'
#' @param y is a numeric vector denoting the dependent variable which will be regressed
#' @param x is a numeric vector denoting the independent variable which will be weighted by the weights w
#' @param w is a numeric vector denoting the weights (population representation) which weigh the independent variable x
#' @param data is a dataframe containing y, x, and w
#' @param lower.tail is a logical indicator (see pchisq() for details)
#'
#' @return list
#' @export
#'
#' @examples
#' data("LLCP2020")
#' results = dc_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020)
dc_test <- function(y, x, w = NULL, data, lower.tail = TRUE) {
  stopifnot(is.data.frame({{data}}))
  stopifnot(is.logical(lower.tail))

  dat = NULL

  if (is.null({{w}}) == TRUE) {
    dat <- dplyr::mutate({{data}}, weights = 1) |>
      dplyr::select({{y}}, {{x}}, weights)
  } else {
    dat <- dplyr::select({{data}}, {{y}}, {{x}}, {{w}})
  }

  unweighted <- stats::lm(dat[[1]] ~ dat[[2]], data = dat)

  equation <- paste(names(dat)[1], "~", names(dat)[2])
  weighted_design <- survey::svydesign(id = ~1, weight = ~dat[[3]], data = dat)
  weighted <- survey::svyglm(equation, design = weighted_design)

  unweighted_coef <- summary(unweighted)$coefficients
  weighted_coef <- summary(weighted)$coefficients

  test_stat <-  t(unweighted_coef[2,1] - weighted_coef[2,1]) *
    (stats::vcov(unweighted)[2,2] - stats::vcov(weighted)[2,2]) *
    (unweighted_coef[2,1] - weighted_coef[2,1])

  p_value <- stats::pchisq(abs(test_stat), length(weighted_coef) - 1, lower.tail = lower.tail)
  return(list("unweighted_model" = summary(unweighted),
              "weighted_model" = summary(weighted),
              "test_statistic" = test_stat,
              "p_value" = as.numeric(p_value)))
}
