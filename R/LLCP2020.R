#' The Behavioral Risk Factor Surveillance System (BRFSS) is a state-based telephone survey that collects data on a number of health outcomes, health-related risk behaviors, use of preventive services, and chronic conditions from noninstitutionalized adults who reside in each of the states and participating US territories. In 2011, BRFSS changed its data collection procedures, structure, and weighting
#'
#' @format A tibble with 353865 rows and 8 variables:
#' \describe{
#'   \item{WEIGHT2}{a number denoting the reported weight (pounds)}
#'   \item{HTIN4}{a number denoting the reported height (inches)}
#'   \item{STSTR}{a number denoting the sample design stratification variable that takes into account state, geospatial strata, and density. Can be used as strata ID}
#'   \item{RACE}{a factor denoting race/ethnicity categories: white, 1; black 2; American Indian, 3; Asian, 4; Nativa Hawaiian, 5; Other, 6; Multiracial, 7; Hispanic, 8}
#'   \item{SEX}{a factor denoting the surveyed individual's birthsex: male, 1; female 2}
#'   \item{AGE_G}{a factor representing the imputed age in six groups: age 18 to 24, 1; age 25 to 34, 2; age 35 to 44, 3; age 45 to 54, 4; age 55 to 64, 5; age 65 or older, 6.}
#'   \item{LLCPWT}{a number denoting the final weight assigned to each respondent to represent how representative they are of the general population}
#'   \item{STRWT}{a number denoting the stratum weight of the number of records in the stratum divided by the number of records selected}
#' }
#' @source {Centers for Disease Control and Prevention: Behavioral Risk Factor Surveillance System 2020. health-related telephone surveys that collect state data about U.S. residents regarding their health-related risk behaviors, chronic health conditions, and use of preventive services.} \url{https://www.cdc.gov/brfss/about/index.htm}
"LLCP2020"
