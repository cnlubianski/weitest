test_that("Given weights of 1, RMSE should be equal", {
  data("LLCP2020")
  results = rmsewt_test(y = "WEIGHT2", x = "HTIN4", covariates = c("RACE", "SEX"), weights = NULL,
                        data = LLCP2020, boot_size = 1000, iterations = 100, alt_hypo = "two.sided")
  expect_equal(results$Weighted_rmse, results$Unweighted_rmse)
})

test_that("Given the statistically significant relationship between height and weight, more iterations increases significance", {
  data("LLCP2020")
  less_iterations = rmsewt_test(y = "WEIGHT2", x = "HTIN4", covariates = c("RACE", "SEX"), weights = "LLCPWT",
                                data = LLCP2020, boot_size = 100, iterations = 50, alt_hypo = "two.sided")
  more_iterations = rmsewt_test(y = "WEIGHT2", x = "HTIN4", covariates = c("RACE", "SEX"), weights = "LLCPWT",
                                data = LLCP2020, boot_size = 100, iterations = 500, alt_hypo = "two.sided")
  expect_gte(less_iterations$p_value, more_iterations$p_value)
})
