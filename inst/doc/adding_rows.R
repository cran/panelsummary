## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.height = 4
)

## ----setup--------------------------------------------------------------------
library(panelsummary)

## Panel A: mpg dependent variable
mpg_1 <- fixest::feols(mpg ~cyl + disp, data = mtcars)
mpg_2 <- fixest::feols(mpg ~ cyl + am, data = mtcars)

## Panel B: wt dependent variable
wt_1 <- fixest::feols(wt ~ cyl + disp, data = mtcars)
wt_2 <- fixest::feols(wt ~ cyl + am, data = mtcars)


## -----------------------------------------------------------------------------
## putting each panel's models into a list—one for each panel
panel_a_mpg <- list(mpg_1, mpg_2)
panel_b_wt <- list(wt_1, wt_2)

## -----------------------------------------------------------------------------
## creating the dataframe
panelsummary_raw(panel_a_mpg, panel_b_wt,
                 stars = "econ",
                 mean_dependent = T,
                 gof_omit = "^R")

## -----------------------------------------------------------------------------
## adding rows using dplyr::add_row
bootstrap_table <- panelsummary_raw(panel_a_mpg, panel_b_wt,
                 stars = "econ",
                 mean_dependent = T,
                 gof_omit = "R") |> 
  dplyr::add_row(term = "Wild Cluster Boot P-value (cyl)",
                 `Model 1` = ".001",
                 `Model 2` = ".002",
                .before = 10) |> 
  dplyr::add_row(term = "Wild Cluster Boot P-value (cyl)",
                 `Model 1` = ".001",
                 `Model 2` = ".005",
                 .before = 22)

bootstrap_table

## -----------------------------------------------------------------------------
## creating a kableExtra object with a few desirable defaults
bootstrap_table |> 
  clean_raw(caption = "A customized panelsummary table with added rows.")

## -----------------------------------------------------------------------------
## creating the final panels.
bootstrap_table |> 
  clean_raw(caption = "A customized panelsummary table with added rows.") |> 
  kableExtra::pack_rows("Panel A: MPG", 1, 14,
                        italic = T,
                        bold = F) |> 
  kableExtra::pack_rows("Panel B: Cyl", 15, 28, 
                        italic = T,
                        bold = F) |> 
  kableExtra::footnote(list("* p < 0.1, ** p < 0.05, *** p < 0.01")) |> 
  kableExtra::kable_classic(full_width = F, html_font = "Cambria") 

