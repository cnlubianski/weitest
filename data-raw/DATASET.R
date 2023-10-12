## Commented code represents the wrangling that was performed with the large dataset
## read README.md for more information

# LLCP2020_all = foreign::read.xport("LLCP2020.XPT")
#
# LLCP2020 = LLCP2020_all |>
#   dplyr::select(X_STSTR, WEIGHT2, HTIN4, X_RACE, X_SEX, X_AGE_G, X_LLCPWT, X_STRWT) |>
#   dplyr::mutate(STSTR = as.factor(X_STSTR),
#                 RACE = as.factor(X_RACE),
#                 SEX = as.factor(X_SEX),
#                 AGE_G = as.factor(X_AGE_G),
#                 LLCPWT = X_LLCPWT,
#                 STRWT = X_STRWT) |>
#   dplyr::select(-c(X_STSTR, X_RACE, X_SEX, X_AGE_G, X_LLCPWT, X_STRWT)) |>
#   dplyr::filter(RACE %in% c(1:8), WEIGHT2 %in% c(50:999)) |>
#   tidyr::drop_na()

LLCP2020 = read.csv("data-raw/LLCP2020.csv")[,-1]

usethis::use_data(LLCP2020, overwrite = TRUE)
