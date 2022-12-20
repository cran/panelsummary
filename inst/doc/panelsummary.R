## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.height = 4
)

## ----setup--------------------------------------------------------------------
library(panelsummary)

## -----------------------------------------------------------------------------
## estimating the model with two depedent variables:
## 1) mpg and 2) disp
mpg_1 <- lm(mpg ~ hp + cyl, data = mtcars)
disp_1 <- lm(disp ~ hp + cyl, data = mtcars)

## -----------------------------------------------------------------------------
## creating a beautiful regression table with panelsummary
panelsummary(mpg_1, disp_1, 
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))

## -----------------------------------------------------------------------------
panelsummary(mpg_1, disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder"),
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))

## -----------------------------------------------------------------------------
## mapping the goodness of fit statistics to new names - see modelsummary for more details
gm <- tibble::tribble(
        ~raw,      ~clean,          ~fmt,  ~omit,
        "nobs",      "Observations",     0,  FALSE,
        "F", "F-stat",               3,  FALSE
)
panelsummary(mpg_1, disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder"),
             gof_map = gm,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))

## -----------------------------------------------------------------------------
## creating two additional models for the first panel 
mpg_2 <- lm(mpg ~ hp + cyl + drat, data = mtcars)
mpg_3 <- lm(mpg ~hp + cyl + drat + wt, data = mtcars)

## -----------------------------------------------------------------------------
panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))

## -----------------------------------------------------------------------------
panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, list(mpg_1, mpg_2),
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement", "Panel C: Demonstration of Additional Panel"))

## -----------------------------------------------------------------------------
## change the significance stars to match economic convention
table_stars <- panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             stars = c('*' = .1, '**' = .05, '***' = .01),
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"))
table_stars 

## -----------------------------------------------------------------------------
library(kableExtra)

## customizing the table with kableExtra
table_stars |> 
  kable_classic(full_width = F, html_font = "Cambria") |> 
  add_header_above(c(" " = 1, "Models Using mtcars" = 3)) |> 
  footnote(list("* p < 0.1, ** p < 0.05, *** p < 0.01",
                "Customizations done using kableExtra package"))

## -----------------------------------------------------------------------------
panelsummary(list(mpg_1, mpg_2, mpg_3), disp_1, 
             coef_map = c("hp" = "Horse Power",
                          "cyl" = "Cylinder",
                          "drat" = "Rear Axle Ratio",
                          "wt" = "Weight (1000lbs)"),
             gof_map = gm,
             stars =c('*' = .1, '**' = .05, '***' = .01),
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"),
             colnames = c("Column 1", "Column 2", "Column 3", "Column 4")) |> 
  kable_classic(full_width = F, html_font = "Cambria") 

