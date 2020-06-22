---
title: "treasury-yield R Shiny App"
author: "Davis Berlind"
date: "June 22, 2020"
output: html_document
---

This repository contains an \code{R} Shiny application that allows the user to scrape Daily Treasury Yield Curve Rates from \url{https://www.treasury.gov/} and plot these rates as a 3D surface to examine changes in the yield curve over time. 

First, you will need Shiny to be installed.

```{r eval=FALSE}
install.packages("shiny")
```

This application also relies on the \code{rvest} package for webscraping, \code{dplyr} for data cleaning, and \code{plotly} for plotting interactive plots.

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
runGitHub( "<your repository name>", "<your user name>")
```

There are also two helper scripts in this repo. \code{yield_scraper.R} is the main webscraping routine and will return a \code{data.frame} of daily yield curve rates and \code{yield_plot.R} contains the 3D plotting code. 
