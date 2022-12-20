## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(panelsummary)
library(fixest) ## for regressions
library(kableExtra) ## for further table customization

## -----------------------------------------------------------------------------
## estimating two models for mpg
mpg_1 <- mtcars |>
    feols(mpg ~  cyl | gear + carb, cluster = ~hp)

mpg_2 <- mtcars |>
    feols(mpg ~  cyl | gear + carb + am, cluster = ~hp)


## estimating the same two models for disp
disp_1 <- mtcars |> 
  feols(disp ~ cyl | gear + carb, cluster = ~hp)

disp_2 <- mtcars |> 
  feols(disp ~ cyl | gear + carb + am, cluster = ~hp)

## -----------------------------------------------------------------------------
panelsummary(list(mpg_1, mpg_2), list(disp_1, disp_2), 
             mean_dependent = TRUE,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"),
             caption = "Automated Mean of Dependent Variable") |> 
  kable_classic(full_width = F, html_font = "Cambria") 

## -----------------------------------------------------------------------------
## creating a renaming tibble to pass into panelsummary 
gm <- tibble::tribble(
        ~raw,      ~clean,          ~fmt,  ~omit,
        "nobs", "Observations", 0,  FALSE,
        "FE: gear", "FE: Gear", 0, FALSE,
        "FE: carb", "FE: Carb", 0, FALSE,
        "FE: am", "FE: AM", 0, FALSE
)

## creating the regression table
panelsummary(list(mpg_1, mpg_2), list(disp_1, disp_2),
             mean_dependent = TRUE,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"),
             gof_map = gm,
             caption = "Automated Mean of Dependent Variable-Renamed and Reordered") |> 
  kable_classic(full_width = F, html_font = "Cambria") 


## -----------------------------------------------------------------------------
## collapsing fixed effects with collapse_fe = T
panelsummary(list(mpg_1, mpg_2), list(disp_1, disp_2),
             mean_dependent = TRUE,
             panel_labels = c("Panel A: MPG", "Panel B: Displacement"),
             gof_map = gm,
             caption = "Collapsed Fixed Effects",
             collapse_fe = T) |> 
  kable_classic(full_width = F, html_font = "Cambria") |> 
  footnote("Collapsing the fixed effects assumes the fixed effects in all panels are the same!")

