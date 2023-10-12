test_that("Given weights of 1, weighted mean should equal arithmetic mean", {
  data("LLCP2020")
  expect_identical(mean(LLCP2020$HTIN4), weighted.mean(LLCP2020$HTIN4, rep(1, length(LLCP2020$HTIN4))))
})

test_that("Given the statistically significant relationship between height and weight, more iterations increases significance", {
  data("LLCP2020")
  less_iterations = meanwt_test(x = LLCP2020$HTIN4, w = LLCP2020$LLCPWT, boot_size = 500, iterations = 500)
  more_iterations = meanwt_test(x = LLCP2020$HTIN4, w = LLCP2020$LLCPWT, boot_size = 500, iterations = 5000)
  expect_gte(less_iterations$p.value, more_iterations$p.value)
})
