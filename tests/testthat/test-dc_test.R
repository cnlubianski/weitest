test_that("Given weights of 1, p-value should be 1 with lower tail false", {
  data("LLCP2020")
  results = dc_test(y = "WEIGHT2", x = "HTIN4", w = NULL, data = LLCP2020, lower.tail = FALSE)
  expect_equal(results$p_value, 1)
})

test_that("Standard error estimates should be greater for weighted linear model (bias-variance tradeoff)", {
  data("LLCP2020")
  results = dc_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020, lower.tail = TRUE)
  expect_gte(results$weighted_model$coefficients[2,2], results$unweighted_model$coefficients[2,2])
})

test_that("Confirming that the Chi-Squared test matches the percentile of the test statistic", {
  data("LLCP2020")
  results = dc_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020, lower.tail = TRUE)
  expect_equal(results$p_value, as.numeric(pchisq(results$test_stat, length(results$weighted_model$coefficients) - 1, lower.tail = TRUE)))
})
