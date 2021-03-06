context("Estimates are correct")

# tolerance
tol <- 0.0001

# example data
require("stats")
set.seed(12345)
N <- 1000L
dat <- data.frame(id = seq_len(N),
                  group = factor(rep(c(1L,2L), each = N/2L), 1:2, c("Low", "High")),
                  x1 = factor(sample(1:3, N, TRUE), 1:3, c("A", "B", "C")),
                  x2 = factor(sample(1:3, N, TRUE), 1:3, c("D", "E", "F")))
attr(dat$x1, "label") <- "First Factor"
attr(dat$x2, "label") <- "Second Factor"
dat$y_star <- plogis(with(dat, model.matrix(~ 0 + interaction(x1, x2)) %*% c(0.5, -1, 0.5, 2, 0.3, 0.8, -0.2, 0.6, -0.8))[,1L])
dat$y <- rbinom(N, 1L, dat$y_star)
dat$y_star <- NULL

test_that("mm() returns correct marginal means", {
    mm_x1 <- aggregate(y~x1, data = dat, mean)
    mm_x2 <- aggregate(y~x2, data = dat, mean)
    est <- mm(dat, y ~ x1 + x2, id = ~ id)
    expect_true(all(c("outcome", "statistic", "feature", "level", "estimate", "std.error", "lower", "upper") %in% names(est)),
                label = "mm() returns correct column names")
    expect_true(identical(nrow(est), 6L),
                label = "mm() returns correct number of estimates")
    expect_true(all(est$feature %in% c("First Factor", "Second Factor")),
                label = "mm() returns correct feature labels")
    expect_true(all(est$level %in% c(levels(dat$x1), levels(dat$x2))),
                label = "mm() returns correct levels of factors")
    expect_true(all(est$outcome == "y"),
                label = "mm() returns correct outcome label")
    expect_true(all.equal(est$estimate, c(mm_x1$y, mm_x2$y), tolerance = tol),
                label = "mm() returns correct MMs")
    expect_true(inherits(mm(dat, y ~ x1 + x2, by = ~ group), "cj_mm"),
                label = "mm() works w/o 'id' argument")
})

test_that("mm_diffs() returns correct differences", {
    mm_x1 <- aggregate(y~x1 + group, data = dat, mean)
    mm_x2 <- aggregate(y~x2 + group, data = dat, mean)
    est <- mm_diffs(dat, y ~ x1 + x2, id = ~ id, by = ~ group)
    expect_true(all(c("BY", "outcome", "statistic", "feature", "level", "estimate", "std.error", "lower", "upper", "group") %in% names(est)),
                label = "mm_diffs() returns correct column names")
    expect_true(all(est$group == "High") & all(est$BY == "High - Low"),
                label = "mm_diffs() returns correct comparisons")
    expect_true(identical(nrow(est), 6L),
                label = "mm_diffs() returns correct number of estimates")
    expect_true(all(est$feature %in% c("First Factor", "Second Factor")),
                label = "mm_diffs() returns correct feature labels")
    expect_true(all(est$level %in% c(levels(dat$x1), levels(dat$x2))),
                label = "mm_diffs() returns correct levels of factors")
    expect_true(all(est$outcome == "y"),
                label = "mm_diffs() returns correct outcome label")
    expect_true(all.equal(est$estimate, c(mm_x1$y[4:6] - mm_x1$y[1:3], mm_x2$y[4:6] - mm_x2$y[1:3]), tolerance = tol),
                label = "mm_diffs() returns correct differences")
    expect_true(inherits(mm_diffs(dat, y ~ x1 + x2, by = ~ group), "cj_diffs"),
                label = "mm_diffs() works w/o 'id' argument")
})

test_that("amce() returns correct marginal effects for unconstrained designs", {
    reg <- glm(y~x1+x2, data = dat)
    est <- amce(dat, y ~ x1 + x2, id = ~ id)
    expect_true(all(c("outcome", "statistic", "feature", "level", "estimate", "std.error", "lower", "upper") %in% names(est)),
                label = "amce() returns correct column names")
    expect_true(identical(nrow(est), 6L),
                label = "amce() returns correct number of estimates")
    expect_true(all(est$feature %in% c("First Factor", "Second Factor")),
                label = "amce() returns correct feature labels")
    expect_true(all(est$level %in% c(levels(dat$x1), levels(dat$x2))),
                label = "amce() returns correct levels of factors")
    expect_true(all(est$outcome == "y"),
                label = "amce() returns correct outcome label")
    expect_true(all.equal(est$estimate,
                          unname(c(0, coef(reg)["x1B"], coef(reg)["x1C"], 0, coef(reg)["x2E"], coef(reg)["x2F"])),
                          tolerance = tol),
                label = "amce() returns correct effects for unconstrained design")
    ## should probably have a test of variances
    expect_true(all.equal(est$estimate, 
                         c(0, 
                           est[est$feature == "First Factor" & est$level == "B", "estimate"],
                           est[est$feature == "First Factor" & est$level == "C", "estimate"],
                           0, 
                           est[est$feature == "Second Factor" & est$level == "E", "estimate"],
                           est[est$feature == "Second Factor" & est$level == "F", "estimate"]
                         ), tolerance = tol),
                label = "amce() returns effects in correct order")
    expect_true(inherits(amce(dat, y ~ x1 + x2, id = ~ id), "cj_amce"),
                label = "amce() works w/o 'id' argument")
})

test_that("amce() returns correct marginal effects for constrained designs", {
    reg <- glm(y~x1*x2, data = subset(dat, !(x1 == "C" & x2 == "F")))
    reg_coef <- coef(reg)
    est <- amce(subset(dat, !(x1 == "C" & x2 == "F")), y ~ x1 * x2, id = ~ id)
    expect_true(all(c("outcome", "statistic", "feature", "level", "estimate", "std.error", "lower", "upper") %in% names(est)),
                label = "amce() returns correct column names")
    expect_true(identical(nrow(est), 6L),
                label = "amce() returns correct number of estimates")
    ## NOTE: SUBSETTING DROPS 'label' ATTRIBUTES FROM VARIABLES, SO LABELS ARE "WRONG" HERE
    expect_true(all(est$feature %in% c("x1", "x2")),
                label = "amce() returns correct feature labels")
    expect_true(all(est$level %in% c(levels(dat$x1), levels(dat$x2))),
                label = "amce() returns correct levels of factors")
    expect_true(all(est$outcome == "y"),
                label = "amce() returns correct outcome label")
    expect_true(all.equal(est$estimate,
                          c(0,
                            mean(c(reg_coef["x1B"], reg_coef["x1B"] + reg_coef["x1B:x2E"], reg_coef["x1B"] + reg_coef["x1B:x2F"])),
                            mean(c(reg_coef["x1C"], reg_coef["x1C"] + reg_coef["x1C:x2E"])),
                            0,
                            mean(c(reg_coef["x2E"], reg_coef["x2E"] + reg_coef["x1B:x2E"], reg_coef["x2E"] + reg_coef["x1C:x2E"])),
                            mean(c(reg_coef["x2F"], reg_coef["x2F"] + reg_coef["x1B:x2F"]))),
                          tolerance = tol),
                label = "amce() returns correct effects for constrained design")
    ## should probably have a test of variances
    expect_true(all.equal(est$estimate, 
                         c(0, 
                           est[est$feature == "x1" & est$level == "B", "estimate"],
                           est[est$feature == "x1" & est$level == "C", "estimate"],
                           0, 
                           est[est$feature == "x2" & est$level == "E", "estimate"],
                           est[est$feature == "x2" & est$level == "F", "estimate"]
                         ), tolerance = tol),
                label = "amce() returns effects in correct order")
})

test_that("cj() by group returns correct marginal effects", {
    reg_low <- glm(y~x1+x2, data = dat, subset = group == "Low")
    reg_high <- glm(y~x1+x2, data = dat, subset = group == "High")
    est <- cj(dat, y ~ x1 + x2, id = ~ id, by = ~ group)
    expect_true(all(c("outcome", "statistic", "feature", "level", "estimate", "std.error", "lower", "upper") %in% names(est)),
                label = "grouped cj() returns correct column names")
    expect_true(identical(nrow(est), 12L),
                label = "grouped cj() returns correct number of estimates")
    expect_true(all(est$feature %in% c("First Factor", "Second Factor")),
                label = "grouped cj() returns correct feature labels")
    expect_true(all(est$level %in% c(levels(dat$x1), levels(dat$x2))),
                label = "grouped cj() returns correct levels of factors")
    expect_true(all(est$outcome == "y"),
                label = "grouped cj() returns correct outcome label")
    expect_true(all(est$group %in% c("Low", "High")),
                label = "grouped cj() returns correct group labels")
    expect_true(all.equal(est$estimate[est$level %in% c("A", "D")], rep(0L, 4), tolerance = tol),
                label = "group cj() returns correct 0s")
    expect_true(all.equal(c(coef(reg_low)[2:5], coef(reg_high)[2:5]),
                          est$estimate[c(2:3, 5:6, 8:9, 11:12)],
                          tolerance = tol,
                          check.attributes = FALSE),
                label = "group cj() returns correct marginal effects")
    expect_true(inherits(cj(dat, y ~ x1 + x2, by = ~ group), "cj_amce"),
                label = "group cj() works w/o 'id' argument")
})

test_that("amce_diffs() returns correct differences", {
    reg_low <- glm(y~x1+x2, data = dat, subset = group == "Low")
    reg_high <- glm(y~x1+x2, data = dat, subset = group == "High")
    est <- amce_diffs(dat, y ~ x1 + x2, id = ~ id, by = ~ group)
    expect_true(all(c("outcome", "statistic", "feature", "level", "estimate", "std.error", "lower", "upper") %in% names(est)),
                label = "amce_diffs() returns correct column names")
    expect_true(identical(nrow(est), 4L),
                label = "amce_diffs() returns correct number of estimates")
    expect_true(all(est$feature %in% c("First Factor", "Second Factor")),
                label = "amce_diffs() returns correct feature labels")
    expect_true(all(est$level %in% c(levels(dat$x1), levels(dat$x2))),
                label = "amce_diffs() returns correct levels of factors")
    expect_true(all(est$outcome == "y"),
                label = "amce_diffs() returns correct outcome label")
    expect_true(all(est$group == "High"),
                label = "amce_diffs() returns correct group labels")
    expect_true(all.equal(est$estimate,
                          (coef(reg_high) - coef(reg_low))[2:5],
                          tolerance = tol,
                          check.attributes = FALSE),
                label = "amce_diffs() returns correct differences")
    expect_true(inherits(amce_diffs(dat, y ~ x1 + x2, by = ~ group), "cj_diffs"),
                label = "amce_diffs() works w/o 'id' argument")
})

