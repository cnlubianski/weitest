test_that("multiplication works", {
  data("LLCP2020")
  expect_output(str(wa_test(y = "WEIGHT2", x = "HTIN4", w = "LLCPWT", data = LLCP2020)), label = "list")
})
