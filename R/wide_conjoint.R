#' @rdname wide_conjoint
#' @docType data
#' @title Example of a raw, \dQuote{wide} conjoint dataset to demonstrate functionality of \code{\link{cj_tidy}}
#' @description A simulated dataset containing 100 respondents' responses to four decision tasks (a,b,c,d) involving a forced choice between two alternative profiles, described by three features (1,2,3), as well as a secondary rating-scale outcome and a response time measure, along with two respondent-varying covariates. This is used in testing and examples within the package.
#' @format A data frame with 100 observations on the following variables:
#'  \describe{
#'    \item{\samp{respondent}}{a numeric vector indicating the respondent identifier}
#'    \item{\samp{feature1a1}}{Feature 1 for task A left profile, a factor}
#'    \item{\samp{feature1b1}}{Feature 1 for task B left profile, a factor}
#'    \item{\samp{feature1c1}}{Feature 1 for task C left profile, a factor}
#'    \item{\samp{feature1d1}}{Feature 1 for task D left profile, a factor}
#'    \item{\samp{feature1a2}}{Feature 1 for task A right profile, a factor}
#'    \item{\samp{feature1b2}}{Feature 1 for task B right profile, a factor}
#'    \item{\samp{feature1c2}}{Feature 1 for task C right profile, a factor}
#'    \item{\samp{feature1d2}}{Feature 1 for task D right profile, a factor}
#'    \item{\samp{feature2a1}}{Feature 2 for task A left profile, a factor}
#'    \item{\samp{feature2b1}}{Feature 2 for task B left profile, a factor}
#'    \item{\samp{feature2c1}}{Feature 2 for task C left profile, a factor}
#'    \item{\samp{feature2d1}}{Feature 2 for task D left profile, a factor}
#'    \item{\samp{feature2a2}}{Feature 2 for task A right profile, a factor}
#'    \item{\samp{feature2b2}}{Feature 2 for task B right profile, a factor}
#'    \item{\samp{feature2c2}}{Feature 2 for task C right profile, a factor}
#'    \item{\samp{feature2d2}}{Feature 2 for task D right profile, a factor}
#'    \item{\samp{feature3a1}}{Feature 3 for task A left profile, a factor}
#'    \item{\samp{feature3b1}}{Feature 3 for task B left profile, a factor}
#'    \item{\samp{feature3c1}}{Feature 3 for task C left profile, a factor}
#'    \item{\samp{feature3d1}}{Feature 3 for task D left profile, a factor}
#'    \item{\samp{feature3a2}}{Feature 3 for task A right profile, a factor}
#'    \item{\samp{feature3b2}}{Feature 3 for task B right profile, a factor}
#'    \item{\samp{feature3c2}}{Feature 3 for task C right profile, a factor}
#'    \item{\samp{feature3d2}}{Feature 3 for task D right profile, a factor}
#'    \item{\samp{choice_a}}{outcome for task A indicating which profile was chosen, randomly 1 or 2, each equally probable}
#'    \item{\samp{choice_b}}{outcome for task B indicating which profile was chosen, randomly 1 or 2, each equally probable}
#'    \item{\samp{choice_c}}{outcome for task C indicating which profile was chosen, randomly 1 or 2, each equally probable}
#'    \item{\samp{choice_d}}{outcome for task D indicating which profile was chosen, randomly 1 or 2, each equally probable}
#'    \item{\samp{rating_a1}}{rating for task A left profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_a2}}{rating for task A right profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_b1}}{rating for task B left profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_b2}}{rating for task B right profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_c1}}{rating for task C left profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_c2}}{rating for task C right profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_d1}}{rating for task D left profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{rating_d2}}{rating for task D right profile, random variable between 1 and 7, uniformly distributed}
#'    \item{\samp{timing_a}}{timing for task A in seconds, random draws from a beta distribution (2,5) times 10}
#'    \item{\samp{timing_b}}{timing for task A in seconds, random draws from a beta distribution (2,5) times 10}
#'    \item{\samp{timing_c}}{timing for task A in seconds, random draws from a beta distribution (2,5) times 10}
#'    \item{\samp{timing_d}}{timing for task A in seconds, random draws from a beta distribution (2,5) times 10}
#'    \item{\samp{covariate1}}{random draws from a uniform distribution between -1 and 1}
#'    \item{\samp{covariate2}}{random draws from the set of 1 and 2}
#'  }
#' @examples
#' \dontrun{
#' data("wide_conjoint")
#' # feature_variables
#' list1 <- list(
#'  feature1 = list(
#'      names(wide_conjoint)[grep("^feature1.{1}1", names(wide_conjoint))],
#'      names(wide_conjoint)[grep("^feature1.{1}2", names(wide_conjoint))]
#'  ),
#'  feature2 = list(
#'      names(wide_conjoint)[grep("^feature2.{1}1", names(wide_conjoint))],
#'      names(wide_conjoint)[grep("^feature2.{1}2", names(wide_conjoint))]
#'  ),
#'  feature3 = list(
#'      names(wide_conjoint)[grep("^feature3.{1}1", names(wide_conjoint))],
#'      names(wide_conjoint)[grep("^feature3.{1}2", names(wide_conjoint))]
#'  ),
#'  rating = list(
#'      names(wide_conjoint)[grep("^rating.+1", names(wide_conjoint))],
#'      names(wide_conjoint)[grep("^rating.+2", names(wide_conjoint))]
#'  )
#' )
#' # task variables
#' list2 <- list(choice = paste0("choice_", letters[1:4]),
#'               timing = paste0("timing_", letters[1:4]))
#' str(cj_tidy(wide_conjoint, profile_variables = list1, task_variables = list2, id = ~ respondent))
#' }
#' @seealso \code{\link{cj_tidy}} \code{\link{cj}}
"wide_conjoint"
