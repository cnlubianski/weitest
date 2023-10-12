#' Title
#'
#' @param x is a numeric vector denoting the independent variable which will be weighted by the weights w
#' @param w is a numeric vector denoting the weights (population representation) which weigh the independent variable x
#' @param boot_size is an integer argument to determine the number of observations to sample each bootstrap
#' @param iterations is an integer argument to determine the number of iterations for bootstrapping
#' @param alt_hypo is a character argument to determine the type of t-test. See t.test() for more information.
#'
#' @return numeric value
#' @export
#'
#' @examples
#' data("LLCP2020")
#' meanwt_test(LLCP2020$HTIN4, LLCP2020$LLCPWT, boot_size = 500, iterations = 100, alt_hypo = "two.sided")
meanwt_test <- function(x, w, boot_size = length(n) / 100, iterations = 10000, alt_hypo = "two.sided") {
  stopifnot(is.numeric(boot_size) | is.numeric(iterations) | is.numeric({{x}}) | is.numeric({{w}}))
  stopifnot(is.character(alt_hypo))

  obs_diff <- mean({{x}}) - stats::weighted.mean({{x}}, {{w}})
  sample_distribution <- rep(NA, iterations)

  for (i in 1:iterations) {
    sample_rows <- sample(c(1:length({{x}})), boot_size, replace = TRUE)
    x_boot <- {{x}}[sample_rows]; w_boot <- {{w}}[sample_rows]
    sample_distribution[i] <- mean(x_boot) - stats::weighted.mean(x_boot, w_boot)
  }
  test_boot <- stats::t.test(sample_distribution, alternative = alt_hypo, mu = 0)
  return(test_boot)
}
