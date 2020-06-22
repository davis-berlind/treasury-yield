# treasury-yield R Shiny App
### Davis Berlind
### June 22, 2020
------

This repository contains an `R` Shiny application that allows the user to scrape Daily Treasury Yield Curve Rates from [https://www.treasury.gov/](https://www.treasury.gov/) and plot these rates as a 3D surface to examine changes in the yield curve over time. 

First, you will need R studio and the `shiny` package to be installed.

```{r eval=FALSE}
install.packages("shiny")
```

This application also relies on the `rvest` package for webscraping, `dplyr` for data cleaning, and `plotly` for plotting interactive plots.

```{r eval=FALSE}
install.packages(c("rvest", "dplyr", "plotly"))
```

Once these packages are installed, there are at least two ways to use this application. First, you can clone this repo, open it and run the following code: 

```{r eval=FALSE}
library(shiny)
runApp("treasury-yield")
```

Second, you can skip cloning the repo and just run the following code:

```{r eval=FALSE}
library(shiny)
runGitHub("treasury-yield", "davis-berlind")
```

For the lazy, the app is also available [here](https://davis-berlind.shinyapps.io/treasury-yield/) without ever having to install R studio.

There are also two helper scripts in this repo. `yield_scraper.R` is the main webscraping routine and will return a `data.frame` of daily yield curve rates and `yield_plot.R` contains the 3D plotting code. 
