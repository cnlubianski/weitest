#' Weight Association Diagnostic Test
#'
#' A weight association diagnostic test determines whether the the weights applied to the covariates X add a statistically significant amount of predictive power. A method to determine survey weight necessity.
#'
#' @param y is a numeric vector denoting the dependent variable which will be regressed
#' @param x is a numeric vector denoting the independent variable which will be weighted by the weights w
#' @param w is a numeric vector denoting the weights (population representation) which weigh the independent variable x
#' @param data is a dataframe containing y, x, and w
#'
#' @return list
#' @export
#'
#' @examples
#' data("LLCP2020")
#' wa_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020)
wa_test <- function(y, x, w = NULL, data) {
  stopifnot(is.data.frame({{data}}))

  dat = NULL

  if (is.null({{w}}) == TRUE) {
    dat <- dplyr::mutate({{data}}, weights = 1) |>
      dplyr::select({{y}}, {{x}}, weights)
  } else {
    dat <- dplyr::select({{data}}, {{y}}, {{x}}, {{w}})
  }

  weight_association_lm <- stats::lm(dat[[1]] ~ dat[[2]] + dat[[2]]:dat[[3]], dat)
  return(list("summary" = summary(weight_association_lm)))
}
