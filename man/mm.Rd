% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mm.R
\name{mm}
\alias{mm}
\title{Marginal Means}
\usage{
mm(data, formula, id = NULL, weights = NULL, feature_order = NULL,
  feature_labels = NULL, level_order = c("ascending", "descending"),
  h0 = 0, alpha = 0.05, ...)
}
\arguments{
\item{data}{A data frame containing variables specified in \code{formula}. All RHS variables should be factors.}

\item{formula}{A formula specifying an outcome (LHS) and conjoint features (RHS) to describe. All variables should be factors; all levels across features should be unique, with constraints specified with an asterisk (*) between features, as in \code{amce}.}

\item{id}{An RHS formula specifying a variable holding respondent identifiers, to be used for clustering standard errors.}

\item{weights}{An (optional) RHS formula specifying a variable holding survey weights.}

\item{feature_order}{An (optional) character vector specifying the names of feature (RHS) variables in the order they should be encoded in the resulting data frame.}

\item{feature_labels}{A named list of \dQuote{fancy} feature labels to be used in output. By default, the function looks for a \dQuote{label} attribute on each variable in \code{formula} and uses that for pretty printing. This argument overrides those attributes or otherwise provides fancy labels for this purpose. This should be a list with names equal to variables on the righthand side of \code{formula} and character string values; arguments passed here override variable attributes.}

\item{level_order}{A character string specifying levels (within each feature) should be ordered increasing or decreasing in the final output. This is mostly only consequential for plotting via \code{\link{plot.cj_mm}}, etc.}

\item{h0}{A numeric value specifying a null hypothesis value to use when generating z-statistics and p-values.}

\item{alpha}{A numeric value indicating the significance level at which to calculate confidence intervals for the MMs (by default 0.95, meaning 95-percent CIs are returned).}

\item{\dots}{Ignored.}
}
\description{
Calculate (descriptive) marginal means (MMs) from a conjoint design
}
\details{
\code{mm} provides descriptive representations of conjoint data as marginal means (MMs), which represent the mean outcome across all appearances of a particular conjoint feature level, averaging across all other features. In forced choice conjoint designs with two profiles per choice task, MMs by definition average 0.5 with values above 0.5 indicating features that increase profile favorability and values below 0.5 indicating features that decrease profile favorability. For continuous outcomes, MMs can take any value in the full range of the outcome.

But note that if feature levels can co-occur, such that both alternatives share a feature level, then the MMs on forced choice outcomes are bounded by the probability of co-occurrence (as a lower bound) and 1 minus that probability as an upper bound.

Plotting functionality is provided in \code{\link{plot.cj_mm}}.
}
\examples{
\donttest{
data(immigration)
# marginal means
mm(immigration, ChosenImmigrant ~ Gender + Education + LanguageSkills,
   id = ~ CaseID, h0 = 0.5)

# marginal means with design constraints
mm(immigration, ChosenImmigrant ~ Gender + LanguageSkills + PriorEntry + 
     CountryOfOrigin * ReasonForApplication, id = ~CaseID)

# higher-order marginal means with feature interactions
immigration$language_entry <- 
  interaction(immigration$LanguageSkills, immigration$PriorEntry, sep = "_")
mm(immigration, ChosenImmigrant ~ language_entry,
   id = ~CaseID)
}
}
\seealso{
\code{\link{mm_diffs}} \code{\link{plot.cj_mm}}
}
